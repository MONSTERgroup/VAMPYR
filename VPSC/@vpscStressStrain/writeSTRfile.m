
pname = 'C:\Users\victoria.miller\Documents\GitHub\Random-VPSC-MTEX-code-snippets\Sample Files to Write';
fname_str = [pname filesep 'STR_STR.OUT'];
fID = fopen(fname_str,'w');

%% Format data as a single matrix

%initialize
data = zeros(length(strainVM),14);

%organize
data(:,1) = strainVM;
data(:,2) = stressVM;

data(:,3) = strain(:,1,1)';
data(:,4) = strain(:,2,2)';
data(:,5) = strain(:,3,3)';
data(:,6) = strain(:,2,3)';
data(:,7) = strain(:,1,3)';
data(:,8) = strain(:,1,2)';

data(:,9)  = stress(:,1,1)';
data(:,10) = stress(:,2,2)';
data(:,11) = stress(:,3,3)';
data(:,12) = stress(:,2,3)';
data(:,13) = stress(:,1,3)';
data(:,14) = stress(:,1,2)';

%% Write the data

fprintf(fID, '%s\n', '          Evm           Svm             E11           E22           E33           E23           E13           E12          SCAU11        SCAU22        SCAU33        SCAU23        SCAU13        SCAU12       TEMP');
fprintf(fID, '%13f %13f %15f %13f %13f %13f %13f %13f %15f %13f %13f %13f %13f %13f\r\n', data');

fclose(fID)


