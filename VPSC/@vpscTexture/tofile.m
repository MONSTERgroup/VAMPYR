function tofile(tex, tex_file)
%TOFILE Writes vpsc TEX file from vpscTexture variable
%   Writes vpsc TEX file (including orientations, weights, and number of
%   grains) from vpscTexture variable. 
%   Uses Bunge notation. 
    
%% Load tex_file
try
    infile = fopen(tex_file, 'w');
    c = onCleanup(@()fclose(infile));
catch me
    throw(me);
end 

d = zeros(tex.ngrain,4);
d(:,1:3) = tex.orientations.Euler;
d = d ./ degree;
d(:,4) = tex.weights;

% header
% fourth line has to include the angle convention (B for Bunge)
% and the total number of grains in the phase
fprintf(infile,'\n\n\nB %d\n',tex.ngrain);

fprintf(infile,'%7.2f %7.2f %7.2f %11.7f\n',d');

end