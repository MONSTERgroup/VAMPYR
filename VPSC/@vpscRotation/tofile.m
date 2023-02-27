function tofile(r,r_file)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Open writable rotation file
try
    outfile = fopen(r_file, 'w');
    c = onCleanup(@()fclose(outfile));
catch me
    throw(me);
end

% Deal with MTEX-VPSC Rotation conversion.
R = r.rot.matrix';

fprintf(outfile,'Rotation Matrix \r\n');
fprintf(outfile, '%f     %f     %f \r\n',R);

end

