function tofile(pm, pm_file)
%TOFILE Summary of this function goes here
%   Detailed explanation goes here

%% Load str_str_file
try
    outfile = fopen(pm_file, 'w');
    c = onCleanup(@()fclose(outfile));
catch me
    throw(me);
end 

fwrite(outfile, pm.postmort_data);

end

