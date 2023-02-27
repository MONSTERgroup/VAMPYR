function fromfile(tex, fname)
%UNTITLED2 gets last set of texture data from file
%   Detailed explanation goes here

%% Load tex_file
try
    infile = fopen(fname);
    c = onCleanup(@()fclose(infile));
catch me
    throw(me);
end 

%% This section reads one strain step at a time

% Do all of this the first time. 
    % get to the number of grains in the file. 
    tline = fgetl(infile); %discard line 1
    tline = fgetl(infile); %get line 2
    %Axes_Aspect(1,:) = sscanf(tline, '%f %f %f %*s');
    tline = fgetl(infile); %get line 3
    %Axes_Euler(1,:) = sscanf(tline, '%f %f %f %*s');
    tline = fgetl(infile); %get line 4
    tex.ngrain = sscanf(tline, '%*s %u'); %number of grains in file

    % Reads in all the grain data in a cell structure
    data = textscan(infile,'%f %f %f %f'); 
    
% Do it again for each additional strain chunk. 
    tline = fgetl(infile); %discard line 1
   
while ischar(tline) %if tline from above is EOF, this loop is skipped;
    %otherwise, it runs until EOF is hit. 
    tline = fgetl(infile); %get line 2
    %Axes_Aspect(1,:) = sscanf(tline, '%f %f %f %*s');
    tline = fgetl(infile); %get line 3
    %Axes_Euler(1,:) = sscanf(tline, '%f %f %f %*s');
    tline = fgetl(infile); %get line 4
    tex.ngrain = sscanf(tline, '%*s %u'); %number of grains in file

    % Reads in all the grain data in a cell structure
    data = textscan(infile,'%f %f %f %f'); 
    
    tline = fgetl(infile); %test the next chunk
end

% The version of data held right now is the texture at the last step. 
data = [data{1,1} data{1,2} data{1,3} data{1,4}];
    % now it's a nGrains x 4 matrix. 
tex.orientations = orientation('Euler',data(:,1)*degree,data(:,2)*degree,data(:,3)*degree,tex.CS,tex.SS);
tex.weights = data(:,4);

end
