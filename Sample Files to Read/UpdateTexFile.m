% Function to read most recent texture update from a TEX_PHX.OUT file and
% update the corresponding texture input file. 

%function []=UpdateTexFile(pname,phase_index)

%input file open
fname = [pname filesep 'TEX_PH' num2str(phase_index) '.OUT'];
fID = fopen(fname); 

%output file open
%get the right string for the filename
if phase_index==1
    str = 'beta';
elseif pahse_index==2
    str = 'alpha';
else
    error('not a valid phase index')
end

fnameOut = [pname filesep str 'Tex.tex'];
fIDout = fopen(fnameOut,'w');

%% This section reads one strain step at a time

% Do all of this the first time. 
    % get to the number of grains in the file. 
    tline = fgetl(fID); %discard line 1
    tline = fgetl(fID); %get line 2
    Axes_Aspect(1,:) = sscanf(tline, '%f %f %f %*s');
    tline = fgetl(fID); %get line 3
    Axes_Euler(1,:) = sscanf(tline, '%f %f %f %*s');
    tline = fgetl(fID); %get line 4
    nGrain = sscanf(tline, '%*s %u'); %number of grains in file

    % Reads in all the grain data in a cell structure
    data = textscan(fID,'%f %f %f %f'); 
    
% Do it again for each additional strain chunk. 
    tline = fgetl(fID); %discard line 1
   
while ischar(tline) %if tline from above is EOF, this loop is skipped;
    %otherwise, it runs until EOF is hit. 
    tline = fgetl(fID); %get line 2
    Axes_Aspect(1,:) = sscanf(tline, '%f %f %f %*s');
    tline = fgetl(fID); %get line 3
    Axes_Euler(1,:) = sscanf(tline, '%f %f %f %*s');
    tline = fgetl(fID); %get line 4
    nGrain = sscanf(tline, '%*s %u'); %number of grains in file

    % Reads in all the grain data in a cell structure
    data = textscan(fID,'%f %f %f %f'); 
    
    tline = fgetl(fID); %test the next chunk
end

% The version of data held right now is the texture at the last step. 
data = [data{1,1} data{1,2} data{1,3} data{1,4}];
    % now it's a nGrains x 4 matrix. 

%% Now let's print it all back out. 

tline = ' '; %line 1 blank
fprintf(fIDout,'%s \n',tline)
tline = ' '; %line 2 blank
fprintf(fIDout,'%s \n',tline)
tline = ' '; %line 3 blank
fprintf(fIDout,'%s \n',tline)
tline = ['B    ' num2str(nGrain)]; %line 4 nGrains
fprintf(fIDout,'%s \n',tline)

% now the real data
for i=1:size(data,1)
    fprintf(fIDout,'%f %f %f %f \n',data(i,:));
end

fclose all


