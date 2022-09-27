%% Code snippet to read VPSC SX file. 

pname = 'C:\Users\victoria.miller\Documents\GitHub\Random-VPSC-MTEX-code-snippets\Sample Files to Read';
fname_in = [pname filesep 'zr_293K.sx'];

infile = fopen(fname_in);


%% get header information
tline = fgetl(infile); %1
matName = sscanf(tline, '*Material: %s');
tline = fgetl(infile); %2
crySym = sscanf(tline, '%s            crysym');
    if strcmpi(crySym,'HEXAGONAL')
        mfmt = '%i %i %i %i %i %i %i %i';
    else 
        mfmt = '%i %i %i %i %i %i';
    end
tline = fgetl(infile); %3
temp = sscanf(tline, '%f %f %f %f %f %f %*s', 6);
    crystalAxes = temp(1:3);
    crystalAngle = temp(4:6);
tline = fgetl(infile); %4 text
    C = zeros(6);
tline = fgetl(infile); %5 
    C(1,:) = sscanf(tline, '%f %f %f %f %f %f %*s', 6);
tline = fgetl(infile); %6 
    C(2,:) = sscanf(tline, '%f %f %f %f %f %f %*s', 6);
tline = fgetl(infile); %7 
    C(3,:) = sscanf(tline, '%f %f %f %f %f %f %*s', 6);
tline = fgetl(infile); %8 
    C(4,:) = sscanf(tline, '%f %f %f %f %f %f %*s', 6);
tline = fgetl(infile); %9 
    C(5,:) = sscanf(tline, '%f %f %f %f %f %f %*s', 6);
tline = fgetl(infile); %10 
    C(6,:) = sscanf(tline, '%f %f %f %f %f %f %*s', 6);
tline = fgetl(infile); %11 text
tline = fgetl(infile); %12 
    alpha = sscanf(tline, '%f %f %f %f %f %f %*s', 6);


%% Slip/twin system info

tline = fgetl(infile); %13 text
tline = fgetl(infile); %14
    nModesTotal = sscanf(tline, '%i %*s', 1);
tline = fgetl(infile); %15
    nModesActive = sscanf(tline, '%i %*s', 1);
tline = fgetl(infile); %16 
    activeModes = sscanf(tline,varLengthStrFormat(nModesActive),nModesActive);

modeLabels = cell(nModesTotal,1);    
modeX = zeros(nModesTotal,1);
nsmX = zeros(nModesTotal,1);
iOpSysX = zeros(nModesTotal,1);
iTwTypeX = zeros(nModesTotal,1);
twinShear = zeros(nModesTotal,1); % dummy value of 0 if not twin 
    
% loop over all slip/twin systems in the file
for i = 1:nModesTotal
    
    % info about the mode
    tline = fgetl(infile); %17 name of system
        modeLabels{i,1} = sscanf(tline,'%s',1);
        
    tline = fgetl(infile); %18 modex,nsmx,iopsysx,itwtypex
        temp = sscanf(tline,'%i',4);
        modeX(i) = temp(1);
        nsmX(i) = temp(2);
        iOpSysX(i) = temp(3);
        iTwTypeX(i) = temp(4);
    
    % twin systems have an exptra parameter on a separate line
    if iTwTypeX(i) ~= 0
        tline = fgetl(infile); 
        twinShear(i) = sscanf(tline,'%f %*s',1);
    end
    
    % loop over each distinct slip system in the family
    for j = 1:nsmX(i)
        tline = fgetl(infile);
        modePlaneDir(i,j,:) = sscanf(tline,mfmt);        
    end
    
end

% Constitutive block
tline = fgetl(infile); % *Constitutive law
tline = fgetl(infile); 
    constitutive = sscanf(tline,'%i %*s',1);
tline = fgetl(infile);    
    iRateSens = sscanf(tline,'%i %*s',1);
tline = fgetl(infile);    
    grainSize = sscanf(tline,'%f %*s',1);

% initialize variables
nRSX = zeros(nModesActive,1);
voce = zeros(nModesActive,4);
hpFactor = zeros(nModesActive,1);
latentHard = zeros(nModesActive,nModesActive);
iSecondTwin = zeros(nModesActive,1);
twThresh1 = zeros(nModesActive,1);
twThresh2 = zeros(nModesActive,1);
    
    
% Loop through activeModes
for i = 1:nModesActive
    
    currentMode = activeModes(i);
    tline = fgetl(infile); %Label
    tline = fgetl(infile); % nrsx
        nRSX(i) = sscanf(tline,'%u %*s',1);
    tline = fgetl(infile); % voce, hp factor
        temp = sscanf(tline, '%f %f %f %f %f %*s',5);
        voce(i,:) = temp(1:4);
        hpFactor(i) = temp(5);
    tline = fgetl(infile); % latent hardening
        latentHard(i,:) = sscanf(tline,[repmat(['%f '],[1 nModesActive]) '%*s'],nModesActive);
    
    % if mode is a twin mode, there's an extra line
    if iTwTypeX(currentMode) ~= 0 
        tline = fgetl(infile); 
            temp = sscanf(tline, '%f %f %f %*s',3);
            iSecondTwin(currentMode) = temp(1);
            twThresh1(currentMode) = temp(2);
            twThresh2(currentMode) = temp(3); 
    end
    
    
    
end


fclose(infile);



