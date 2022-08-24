%% function to read STR_STR

pname = 'C:\Users\victoria.miller\Documents\GitHub\Random-VPSC-MTEX-code-snippets\Sample Files to Read';
fname_str = [pname filesep 'STR_STR.OUT'];

infile = fopen(fname_str);

%% Read the file

startRow = 2;
formatSpec = '%13f%13f%15f%13f%13f%13f%13f%13f%15f%13f%13f%13f%13f%f%[^\n\r]';

fID = fopen(fname_str,'r');

data = textscan(fID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
data = [data{1:end-1}];

fclose(fID);

%% Organize the data

strainVM = data(:,1);
stressVM = data(:,2);

strain = zeros(size(data,1),3,3);
stress = zeros(size(data,1),3,3); 

strain(:,1,1) = data(:,3)';
strain(:,2,2) = data(:,4)';
strain(:,3,3) = data(:,5)';
strain(:,2,3) = data(:,6)';
strain(:,3,2) = data(:,6)';
strain(:,1,3) = data(:,7)';
strain(:,3,1) = data(:,7)';
strain(:,1,2) = data(:,8)';
strain(:,2,1) = data(:,8)';

stress(:,1,1) = data(:,9)';
stress(:,2,2) = data(:,10)';
stress(:,3,3) = data(:,11)';
stress(:,2,3) = data(:,12)';
stress(:,3,2) = data(:,12)';
stress(:,1,3) = data(:,13)';
stress(:,3,1) = data(:,13)';
stress(:,1,2) = data(:,14)';
stress(:,2,1) = data(:,14)';
