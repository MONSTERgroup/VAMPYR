function tofile(str_str, str_str_file)

%% Load str_str_file
try
    outfile = fopen(str_str_file, 'w');
    c = onCleanup(@()fclose(outfile));
catch me
    throw(me);
end 

%% Format data as a single matrix

%initialize
data = zeros(length(str_str.strainVM),15);

%organize
data(:,1) = str_str.strainVM;
data(:,2) = str_str.stressVM;
data(:,15) = str_str.temperature;

data(:,3) = str_str.strain(:,1,1)';
data(:,4) = str_str.strain(:,2,2)';
data(:,5) = str_str.strain(:,3,3)';
data(:,6) = str_str.strain(:,2,3)';
data(:,7) = str_str.strain(:,1,3)';
data(:,8) = str_str.strain(:,1,2)';

data(:,9)  = str_str.stress(:,1,1)';
data(:,10) = str_str.stress(:,2,2)';
data(:,11) = str_str.stress(:,3,3)';
data(:,12) = str_str.stress(:,2,3)';
data(:,13) = str_str.stress(:,1,3)';
data(:,14) = str_str.stress(:,1,2)';

%% Write the data

fprintf(outfile, '%s\n', '          Evm           Svm             E11           E22           E33           E23           E13           E12          SCAU11        SCAU22        SCAU33        SCAU23        SCAU13        SCAU12       TEMP');
fprintf(outfile, '%13f %13f %15f %13f %13f %13f %13f %13f %15f %13f %13f %13f %13f %13f %13f\r\n', data');

end


