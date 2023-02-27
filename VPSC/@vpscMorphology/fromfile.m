function fromfile(morph,morph_file)
%FROMFILE Summary of this function goes here
%   Detailed explanation goes here

%% Load morph_file
try
    infile = fopen(morph_file);
    c = onCleanup(@()fclose(infile));
catch me
    throw(me);
end 

% %output file open
% %get the right string for the filename
% if phase_index==1
%     str = 'beta';
% elseif phase_index==2
%     str = 'alpha';
% else
%     error('not a valid phase index')
% end
% 
% fnameOut = [pname filesep str 'Shape.100'];
% fIDout = fopen(fnameOut,'w');

%% This section reads one strain step at a time

% Do all of this the first time. 
    % get to the number of grains in the file. 
    tline = fgetl(infile); %discard line 1
    tline = fgetl(infile); %get line 2
%     Axes_Aspect(1,:) = sscanf(tline, '%f %f %f %*s');
    tline = fgetl(infile); %get line 3
%     Axes_Euler(1,:) = sscanf(tline, '%f %f %f %*s');
    tline = fgetl(infile); %get line 4
    morph.ngrain = sscanf(tline, '%*s %u'); %number of grains in file

    % Reads in all the grain data in a cell structure
    data = textscan(infile,'%f %f %f %f %f %f'); 
    
% Do it again for each additional strain chunk. 
    tline = fgetl(infile); %discard line 1
   
while ischar(tline) %if tline from above is EOF, this loop is skipped;
    %otherwise, it runs until EOF is hit. 
    tline = fgetl(infile); %get line 2
%     Axes_Aspect(1,:) = sscanf(tline, '%f %f %f %*s');
    tline = fgetl(infile); %get line 3
%     Axes_Euler(1,:) = sscanf(tline, '%f %f %f %*s');
    tline = fgetl(infile); %get line 4
    morph.ngrain = sscanf(tline, '%*s %u'); %number of grains in file

    % Reads in all the grain data in a cell structure
    data = textscan(infile,'%f %f %f %f %f %f'); 
    
    tline = fgetl(infile); %test the next chunk
end

% The version of data held right now is the texture at the last step. 
data = [data{1,1} data{1,2} data{1,3} data{1,4} data{1,5} data{1,6}];
    % now it's a nGrains x 6 matrix.

    morph.orientations = orientation('Euler',data(:,1)*degree,data(:,2)*degree,data(:,3)*degree,morph.CS,morph.SS);
    morph.axes_lengths(:, 1:3) = data(:,4:6);



end

