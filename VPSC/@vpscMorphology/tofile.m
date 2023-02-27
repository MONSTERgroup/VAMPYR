function tofile(morph, morph_file)
%TOFILE Summary of this function goes here
%   Detailed explanation goes here

%% Load morph_file
try
    outfile = fopen(morph_file, 'w');
    c = onCleanup(@()fclose(outfile));
catch me
    throw(me);
end 
%% Now let's print it all back out. 

d = zeros(morph.ngrain,6);
d(:,1:3) = morph.orientations.Euler;
d = d ./ degree;
d(:,4:6) = morph.axes_lengths(:,1:3);

tline = ' '; %line 1 blank
fprintf(outfile,'%s \n',tline);
tline = ' '; %line 2 blank
fprintf(outfile,'%s \n',tline);
tline = ' '; %line 3 blank
fprintf(outfile,'%s \n',tline);
tline = ['B    ' num2str(morph.ngrain)]; %line 4 nGrains
fprintf(outfile,'%s \n',tline);

% now the real data

fprintf(outfile,'%f %f %f %f %f %f \n',d');

end

