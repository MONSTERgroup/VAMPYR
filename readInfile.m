%% Code snippet to read VPSC infile. 

pname = 'C:\Users\victoria.miller\Documents\GitHub\Random-VPSC-MTEX-code-snippets\Sample Files to Read';
fname_in = [pname filesep 'vpsc7.in'];

infile = fopen(fname_in);

% get header information
tline = fgetl(infile);
nElement = sscanf(tline, '%f %*s', 1);
tline = fgetl(infile);
nPhase = sscanf(tline, '%f %*s', 1);
tline = fgetl(infile);
phaseFrac = sscanf(tline,varLengthStrFormat(nPhase));


%Initialize the phase-specific variables
gShapeControl = repmat(0,[nPhase 1]);
fragmentation = repmat(0,[nPhase 1]);
critAspectRatio = repmat(25,[nPhase 1]);
ellipsoidAspect = repmat([1 1 1],[nPhase 1]);
ellipsoidAxesAngles = repmat([0 0 0],[nPhase 1]);
fnameTEX = cell(nPhase,1);
fnameSX = cell(nPhase,1);
fnameMORPH = cell(nPhase,1); 

for i = 1:nPhase %get all the parameters for each phase
    
    tline = fgetl(infile); %L4
    tline = fgetl(infile); %L5
    [gShapeControl(i) fragmentation(i) critAspectRatio(i)] = sscanf(tline, '%f %f %f %*s', 3);
    tline = fgetl(infile); %L6
    ellipsoidAspect(i,:) = sscanf(tline, '%f %f %f %*s', 3);
    tline = fgetl(infile); %L7
    ellipsoidAxesAngles(i,:) = sscanf(tline, '%f %f %f %*s', 3);
    tline = fgetl(infile); %L8
    tline = fgetl(infile); %L9
    fnameTEX(i) = tline;
    tline = fgetl(infile); %L10
    tline = fgetl(infile); %L11
    fnameSX(i) = tline;
    tline = fgetl(infile); %L12
    tline = fgetl(infile); %L13
    fnameMORPH(i) = tline;
    
end

    tline = fgetl(infile); %L14 (assuming single phase)
    tline = fgetl(infile); %L15
    
