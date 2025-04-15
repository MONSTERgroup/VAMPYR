function fromfile(param, fname)
%FROMFILE Summary of this function goes here
%   Detailed explanation goes here

%% Load vpsc7.in
try
    infile = fopen(fname);
    c = onCleanup(@()fclose(infile));
catch me
    throw(me);
end

%% Read in header information
tline = fgetl(infile);
param.iregime = sscanf(tline, '%f %*s', 1);
tline = fgetl(infile);
param.nPhase = sscanf(tline, '%f %*s', 1);
tline = fgetl(infile);
param.phaseFrac = sscanf(tline,varLengthStrFormat(param.nPhase))';
if param.nPhase == 1
    try 
        param.phaseFrac = sscanf(tline, varLengthStrFormat(2))';
    catch
        param.phaseFrac = sscanf(tline,varLengthStrFormat(param.nPhase))';
    end
end

%% Phase Info
% Initialize the phase-specific variables

%%%%%%@Begley, this can go when we set the defaults?
param.gShapeControl = repmat(0,[param.nPhase 1]);
param.fragmentation = repmat(0,[param.nPhase 1]);
param.critAspectRatio = repmat(25,[param.nPhase 1]);
param.ellipsoidAspect = repmat([1 1 1],[param.nPhase 1]);
param.ellipsoidAxesAngles = repmat([0 0 0],[param.nPhase 1]);
param.fnameTEX = cell(param.nPhase,1);
param.fnameSX = cell(param.nPhase,1);
param.fnameMORPH = cell(param.nPhase,1);
param.gShapeControl = repmat(0,[param.nPhase 1]);
param.fnameDIFF = cell(param.nPhase,1);

for i = 1:param.nPhase %get all the parameters for each phase

    tline = fgetl(infile); %L4
    tline = fgetl(infile); %L5
    temp = sscanf(tline, '%f %f %f %*s', 3);
    param.gShapeControl(i) = temp(1);
    param.fragmentation(i) = temp(2);
    param.critAspectRatio(i) = temp(3);
    tline = fgetl(infile); %L6
    param.ellipsoidAspect(i,:) = sscanf(tline, '%f %f %f %*s', 3)';
    tline = fgetl(infile); %L7
    param.ellipsoidAxesAngles(i,:) = sscanf(tline, '%f %f %f %*s', 3)';
    tline = fgetl(infile); %L8
    tline = fgetl(infile); %L9
    param.fnameTEX{i} = tline;
    tline = fgetl(infile); %L10
    tline = fgetl(infile); %L11
    param.fnameSX{i} = tline;
    tline = fgetl(infile); %L12
    tline = fgetl(infile); %L13
    param.fnameMORPH{i} = tline;
    tline = fgetl(infile); %L14
    tline = fgetl(infile); %L15
    param.idiff(i) = sscanf(tline, '%f');
    tline = fgetl(infile); %L16
    param.fnameDIFF{i} = tline;
end
clear i temp

%% Convergence parameters
tline = fgetl(infile); %L17 (assuming single phase)
tline = fgetl(infile); %L18
temp = sscanf(tline, '%f %f %f %f %*s', 4);
param.errStress = temp(1);
param.errStrRateD = temp(2);
param.errModuli = temp(3);
param.errSecondOrder = temp(4);

tline = fgetl(infile); %L19
temp = sscanf(tline, '%f %f %f %*s', 3);
param.itMaxTot = temp(1);
param.itMaxExternal = temp(2);
param.itMaxInternalSO = temp(3);

tline = fgetl(infile); %L20
temp = sscanf(tline, '%f %f %f %f %*s', 4);
param.irsvar = temp(1);
param.jrsini = temp(2);
param.jrsfin = temp(3);
param.jrstep = temp(4);

% tline = fgetl(infile); %L18
% param.iBCinv = sscanf(tline, '%f %*s', 1);

%% i/o settings
tline = fgetl(infile); %L21
tline = fgetl(infile); %L22
param.iRecover = sscanf(tline, '%f %*s', 1);

tline = fgetl(infile); %L23
param.iSave = sscanf(tline, '%f %*s', 1);

tline = fgetl(infile); %L24
param.iCubeComp = sscanf(tline, '%f %*s', 1);

tline = fgetl(infile); %L25
param.nWrite = sscanf(tline, '%f %*s', 1);


%% modeling conditions
tline = fgetl(infile); %L26
tline = fgetl(infile); %L27
param.interactionType = sscanf(tline, '%f %f %*s', 2);


tline = fgetl(infile); %L28
temp = sscanf(tline, '%f %f %f %*s', 3);
param.iUpdateOri = temp(1);
param.iUpdateMorph = temp(2);
param.iUpdateHardening = temp(3);


tline = fgetl(infile); %L29
param.nNeighbor = sscanf(tline, '%f %*s', 1);

tline = fgetl(infile); %L23
param.iFluctuation = sscanf(tline, '%f %*s', 1);



%% deformation processes
tline = fgetl(infile); %L31
tline = fgetl(infile); %L32
param.nProcess = sscanf(tline, '%f %*s', 1);

param.processType = zeros([param.nProcess 1]);
param.processDetail = cell(param.nProcess, 1);
tline = fgetl(infile); %L33

for i = 1:param.nProcess
    tline = fgetl(infile); %L34
    param.processType(i) = sscanf(tline, '%f %*s', 1);
    tline = fgetl(infile); %L35
    param.processDetail{i} = tline;
end

end

