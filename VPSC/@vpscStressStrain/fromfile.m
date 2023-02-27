function fromfile(str_str, str_str_file)

%% Load str_str_file
try
    infile = fopen(str_str_file);
    c = onCleanup(@()fclose(infile));
catch me
    throw(me);
end 

%% Read the file

startRow = 2;
formatSpec = '%13f%13f%15f%13f%13f%13f%13f%13f%15f%13f%13f%13f%13f%13f%[^\n\r]';

data = textscan(infile, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
data = [data{1:end}];

%% Organize the data

str_str.strainVM = data(:,1);
str_str.stressVM = data(:,2);
str_str.temperature(:,1) = data(:,15);

str_str.strain = zeros(size(data,1),3,3);
str_str.stress = zeros(size(data,1),3,3); 

str_str.strain(:,1,1) = data(:,3)';
str_str.strain(:,2,2) = data(:,4)';
str_str.strain(:,3,3) = data(:,5)';
str_str.strain(:,2,3) = data(:,6)';
str_str.strain(:,3,2) = data(:,6)';
str_str.strain(:,1,3) = data(:,7)';
str_str.strain(:,3,1) = data(:,7)';
str_str.strain(:,1,2) = data(:,8)';
str_str.strain(:,2,1) = data(:,8)';

str_str.stress(:,1,1) = data(:,9)';
str_str.stress(:,2,2) = data(:,10)';
str_str.stress(:,3,3) = data(:,11)';
str_str.stress(:,2,3) = data(:,12)';
str_str.stress(:,3,2) = data(:,12)';
str_str.stress(:,1,3) = data(:,13)';
str_str.stress(:,3,1) = data(:,13)';
str_str.stress(:,1,2) = data(:,14)';
str_str.stress(:,2,1) = data(:,14)';

end
