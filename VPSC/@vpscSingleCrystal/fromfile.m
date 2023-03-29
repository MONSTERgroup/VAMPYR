function fromfile(sx,fname_sx)
%FROMFILE creates vpscSingleCrystal variable from VPSC *.SX file
%   Detailed explanation goes here

%% Load SX file
try
    infile = fopen(fname_sx);
    c = onCleanup(@()fclose(infile));
catch me
    throw(me);
end

%% get header information
tline = fgetl(infile); %1
sx.matName = sscanf(tline, '*Material: %s');
tline = fgetl(infile); %2
csname = sscanf(tline, '%s            crysym');
tline = fgetl(infile); %3
temp = sscanf(tline, '%f %f %f %f %f %f %*s', 6);
csaxes = temp(1:3);
csangles = temp(4:6);

% Store as MTEX crystal symmetry
sx.CS = crystalSymmetry(lower(csname),csaxes,csangles);

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

% Store as MTEX tensor
sx.C = tensor(C,'rank',4);

tline = fgetl(infile); %11 text
tline = fgetl(infile); %12
sx.alpha = sscanf(tline, '%f %f %f %f %f %f %*s', 6);

%% Slip/twin system info

tline = fgetl(infile); %13 text
tline = fgetl(infile); %14
sx.nModesTotal = sscanf(tline, '%u %*s', 1);
tline = fgetl(infile); %15
sx.nModesActive = sscanf(tline, '%u %*s', 1);
tline = fgetl(infile); %16
sx.activeModes = sscanf(tline,varLengthStrFormat(sx.nModesActive),sx.nModesActive);

modeLabels = cell(sx.nModesTotal,1);
modeX = zeros(sx.nModesTotal,1);
nsmX = zeros(sx.nModesTotal,1);
iOpSysX = zeros(sx.nModesTotal,1);
iTwTypeX = zeros(sx.nModesTotal,1);
twinShear = zeros(sx.nModesTotal,1); % dummy value of 0 if not twin

% loop over all slip/twin systems in the file
for i = 1:sx.nModesTotal

    % info about the mode
    tline = fgetl(infile); %17 name of system
    modeLabels{i,1} = tline;

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
        modePlaneDir(i,j,:) = sscanf(tline,'%i %i %i %i %i %i %i %i');
    end
end

% Constitutive block
tline = fgetl(infile); % *Constitutive law
tline = fgetl(infile);
sx.constitutive = sscanf(tline,'%i %*s',1);
tline = fgetl(infile);
sx.iRateSens = sscanf(tline,'%i %*s',1);
tline = fgetl(infile);
sx.grainSize = sscanf(tline,'%f %*s',1);

% initialize variables
nRSX = zeros(sx.nModesActive,1);
voce = zeros(sx.nModesActive,4);
hpFactor = zeros(sx.nModesActive,1);
latentHard = zeros(sx.nModesActive,sx.nModesActive);
iSecondTwin = zeros(sx.nModesActive,1);
twThresh1 = zeros(sx.nModesActive,1);
twThresh2 = zeros(sx.nModesActive,1);


% Loop through activeModes
for i = 1:sx.nModesActive

    currentMode = sx.activeModes(i);
    tline = fgetl(infile); %Label
    tline = fgetl(infile); % nrsx
    nRSX(i) = sscanf(tline,'%u %*s',1);
    tline = fgetl(infile); % voce, hp factor
    temp = sscanf(tline, '%f %f %f %f %f %*s',5);
    voce(i,:) = temp(1:4);
    hpFactor(i) = temp(5);
    tline = fgetl(infile); % latent hardening
    latentHard(i,:) = sscanf(tline,[repmat(['%f '],[1 sx.nModesActive]) '%*s'],sx.nModesActive);

    % if mode is a twin mode, there's an extra line
    if iTwTypeX(currentMode) ~= 0
        tline = fgetl(infile);
        temp = sscanf(tline, '%f %f %f %*s',3);
        iSecondTwin(currentMode) = temp(1);
        twThresh1(currentMode) = temp(2);
        twThresh2(currentMode) = temp(3);
    end
end

mode = cell(sx.nModesTotal,1);
clear('temp')
w = size(modePlaneDir,3);
for i = 1:sx.nModesTotal
    j = 1;
    clear('temp')
    while j<=size(modePlaneDir,2) && nnz(modePlaneDir(i,j,:))>0
        if w == 6
            n = Miller(num2cell(squeeze(modePlaneDir(i,j,1:3))),sx.CS, 'hkl');
            b = Miller(num2cell(squeeze(modePlaneDir(i,j,4:6))),sx.CS, 'uvw');
            temp{j} = slipSystem(b,n);
        elseif w == 8
            n = Miller(num2cell(squeeze(modePlaneDir(i,j,1:4))),sx.CS, 'hkil');
            b = Miller(num2cell(squeeze(modePlaneDir(i,j,5:8))),sx.CS, 'uvtw');
            temp{j} = slipSystem(b,n);
        end
        j=j+1;
    end
    sys = vertcat(temp{:});
    mode{i} = vpscPlasticityMode(sys, iOpSysX(i), iTwTypeX(i));
    mode{i}.twinShear = twinShear(i);
    mode{i}.modename = modeLabels{i};

    [~, idx] = ismember(i,sx.activeModes);
    if idx
        mode{i}.nRSX = nRSX(idx);
        mode{i}.voceParams = voce(idx,:);
        mode{i}.hpFactor = hpFactor(idx);
        mode{i}.latentHard = latentHard(idx,:);
        mode{i}.iSecondTwin = iSecondTwin(idx);
        mode{i}.twThresh1 = twThresh1(idx);
        mode{i}.twThresh2 = twThresh2(idx);
    end
end
sx.Modes = mode;
end

