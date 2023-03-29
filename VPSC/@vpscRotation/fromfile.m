function fromfile(r, r_file)
%FROMFILE Converts VSPC rotation file into VAMPYR (MTEX) rotation
%   Detailed explanation goes here

try
    infile = fopen(r_file);
    c = onCleanup(@()fclose(infile));
catch me
    throw(me);
end


tline = fgetl(infile);
data = textscan(infile, '%f %f %f');
data = cell2mat(data);

r.rot = rotation.byMatrix(data'); %MTEX rotation convention is the transpose of the VPSC rotation convention

end

