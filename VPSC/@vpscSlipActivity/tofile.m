function tofile(act, act_file)
%TOFILE writes ACT_PHx.OUT file from vpscSlipActivity variable
%   Detailed explanation goes here


%% Load str_str_file
try
    outfile = fopen(act_file, 'w');
    c = onCleanup(@()fclose(outfile));
catch me
    throw(me);
end 

%% Format data as a single matrix

%initialize
data = zeros(length(act.strain),2+act.nmodes);

data(:,1) = act.strain;
data(:,2) = act.AVACS;
for ii = 1:act.nmodes
data(:,ii+2) = act.activities(:,ii);
end

%% Write the data

header_string = '   STRAIN   AVACS   ';
data_string = '%13f %13f';
for ii = 1:act.nmodes
    header_string = [header_string 'MODE' num2str(ii) '   '];
    data_string = [data_string ' %13f'];
end
data_string = [data_string '\r\n'];

fprintf(outfile, '%s\n', header_string);
fprintf(outfile, data_string, data');

end

