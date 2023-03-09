function fromfile(pm, pm_file)
%FROMFILE Summary of this function goes here
%   Detailed explanation goes here

%% Load pm_file
try
    infile = fopen(pm_file);
    c = onCleanup(@()fclose(infile));
catch me
    throw(me);
end

pm.postmort_data = fread(infile);

end

