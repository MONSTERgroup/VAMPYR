function fromfile(act, act_file)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Load act_file
try
    infile = fopen(act_file);
    c = onCleanup(@()fclose(infile));
catch me
    throw(me);
end 

%% Read
startRow = 2;
formatSpec = ['%f%f' repmat('%f',[1,act.nmodes])];

data = textscan(infile, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% segment data

act.strain = data{:,1};
act.AVACS = data{:,2};
for ii = 1:act.nmodes
    act.activities(:,ii) = data{:,ii+2};
end
end

