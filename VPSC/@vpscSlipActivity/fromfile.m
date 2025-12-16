function fromfile(act, act_file)
%FROMFILE generates vpscSlipActivity from ACT_PHx.OUT file
%   Detailed explanation goes here

%% Load act_file
try
    infile = fopen(act_file);
    c = onCleanup(@()fclose(infile));
catch me
    throw(me);
end

%% Read Data
tline = fgetl(infile);
header = split(tline);
header = header(~cellfun('isempty', header));
formatSpec = [repmat('%f', [1, size(header,1)])];
data = textscan(infile, formatSpec);

%% Segment Data
act.strain = data{:,strcmp(header, 'STRAIN')};
act.AVACS  = data{:,strcmp(header, 'AVACS')};

for ii = 1:act.nmodes
    act.activities(:,ii) = data{:,strcmp(header, ['MODE' num2str(ii)])};
end
end

