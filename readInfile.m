%% Code snippet to read VPSC infile. 

pname = 'C:\Users\victoria.miller\Documents\GitHub\Random-VPSC-MTEX-code-snippets\Sample Files to Read';
fname_in = [pname filesep 'vpsc7.in'];

infile = fopen(fname_in);


%% get header information
tline = fgetl(infile);
nElement = sscanf(tline, '%f %*s', 1);
tline = fgetl(infile);
nPhase = sscanf(tline, '%f %*s', 1);
tline = fgetl(infile);
phaseFrac = sscanf(tline,varLengthStrFormat(nPhase),nPhase);


%% Phase info
%Initialize the phase-specific variables
gShapeControl = repmat(0,[nPhase 1]);
iFragment = repmat(0,[nPhase 1]);
critAspect = repmat(25,[nPhase 1]);
axesRatio = repmat([1 1 1],[nPhase 1]);
axesEuler = repmat([0 0 0],[nPhase 1]);
fnameTEX = cell(nPhase,1);
fnameSX = cell(nPhase,1);
fnameMORPH = cell(nPhase,1); 

for i = 1:nPhase %get all the parameters for each phase
    
    tline = fgetl(infile); %L4
    tline = fgetl(infile); %L5
    temp = sscanf(tline, '%f %f %f %*s', 3);
        gShapeControl(i) = temp(1);
        iFragment(i) = temp(2);
        critAspect(i) = temp(3);
    tline = fgetl(infile); %L6
    axesRatio(i,:) = sscanf(tline, '%f %f %f %*s', 3)';
    tline = fgetl(infile); %L7
    axesEuler(i,:) = sscanf(tline, '%f %f %f %*s', 3)';
    tline = fgetl(infile); %L8
    tline = fgetl(infile); %L9
    fnameTEX{i} = tline;
    tline = fgetl(infile); %L10
    tline = fgetl(infile); %L11
    fnameSX{i} = tline;
    tline = fgetl(infile); %L12
    tline = fgetl(infile); %L13
    fnameMORPH{i} = tline;
    
end
clear i temp

%% Convergence parameters
tline = fgetl(infile); %L14 (assuming single phase)
tline = fgetl(infile); %L15
temp = sscanf(tline, '%f %f %f %f %*s', 4);
    errStress = temp(1);
    errStrainRateD = temp(2);
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
iHardLaw = sscanf(tline, '%f %*s', 1);


tline = fgetl(infile); %L26
temp = sscanf(tline, '%f %f %f %*s', 3);
    updateOri = temp(1);
    updateShape = temp(2);
    updateHard = temp(3);


tline = fgetl(infile); %L27
nNeigh = sscanf(tline, '%f %*s', 1);

tline = fgetl(infile); %L28
iFluct = sscanf(tline, '%f %*s', 1);



%% deformation processes
tline = fgetl(infile); %L29
tline = fgetl(infile); %L30
nProcess = sscanf(tline, '%f %*s', 1);

defProcess = cell(nProcess,3);
tline = fgetl(infile); %L31

for i = 1:nProcess
    tline = fgetl(infile); %L32
    defProcess{i,1} = sscanf(tline, '%f %*s', 1);
    tline = fgetl(infile); %L33
    defProcess{i,3} = tline;
end

fclose(infile);



