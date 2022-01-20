%% Code snippet to read VPSC infile. 

pname = 'C:\Users\victoria.miller\Documents\GitHub\Random-VPSC-MTEX-code-snippets\Sample Files to Read';
fname_in = [pname filesep 'zr_293K.sx'];

infile = fopen(fname_in);


%% get header information
tline = fgetl(infile); %1
matName = sscanf(tline, 'Material: %s');
tline = fgetl(infile); %2
crySym = sscanf(tline, '%s            crysym');
    if strcompi(crySym,'HEXAGONAL')
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

modex = zeros(nModesTotal,1);
nsmx = zeros(nModesTotal,1);
iopsysx = zeros(nModesTotal,1);
itwtypex = zeros(nModesTotal,1);
    
for i = 1:nModesTotal
    
    
    for j = 1:

    
%% Convergence parameters
tline = fgetl(infile); %L14 (assuming single phase)
tline = fgetl(infile); %L15
temp = sscanf(tline, '%f %f %f %f %*s', 4);
    errStress = temp(1);
    errStrRateD = temp(2);
    errModuli = temp(3); 
    errSecondOrder = temp(4);

tline = fgetl(infile); %L16
temp = sscanf(tline, '%f %f %f %*s', 3);
    itMaxTot = temp(1);
    itMaxExternal = temp(2);
    itMaxInternalSO = temp(3);
 
tline = fgetl(infile); %L17
temp = sscanf(tline, '%f %f %f %f %*s', 4);
    irsvar = temp(1);
    jrsini = temp(2);
    jrsfin = temp(3);
    jrstep = temp(4);

tline = fgetl(infile); %L18
iBCinv = sscanf(tline, '%f %*s', 1);

%% i/o settings
tline = fgetl(infile); %L19
tline = fgetl(infile); %L20
iRecover = sscanf(tline, '%f %*s', 1);

tline = fgetl(infile); %L21
iSave = sscanf(tline, '%f %*s', 1);

tline = fgetl(infile); %L22
iCubeComp = sscanf(tline, '%f %*s', 1);

tline = fgetl(infile); %L23
nWrite = sscanf(tline, '%f %*s', 1);


%% modeling conditions
tline = fgetl(infile); %L24
tline = fgetl(infile); %L25
interactionType = sscanf(tline, '%f %*s', 1);


tline = fgetl(infile); %L26
temp = sscanf(tline, '%f %f %f %*s', 3);
    iUpdateOri = temp(1);
    iUpdateMorph = temp(2);
    iUpdateHardening = temp(3);


tline = fgetl(infile); %L27
nNeighbor = sscanf(tline, '%f %*s', 1);

tline = fgetl(infile); %L28
iFluctuation = sscanf(tline, '%f %*s', 1);



%% deformation processes
tline = fgetl(infile); %L29
tline = fgetl(infile); %L30
nProcess = sscanf(tline, '%f %*s', 1);

processType = zeros([nProcess 1]);
processDetail = cell(nProcess, 1);
tline = fgetl(infile); %L31

for i = 1:nProcess
    tline = fgetl(infile); %L32
    processType(i) = sscanf(tline, '%f %*s', 1);
    tline = fgetl(infile); %L33
    processDetail{i} = tline;
end

fclose(infile)



