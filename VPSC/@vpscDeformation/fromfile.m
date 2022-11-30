function fromfile(def,fname_def)
%FROMFILE Summary of this function goes here
%   Detailed explanation goes here

%% Load SX file
try
    infile = fopen(fname_def);
    c = onCleanup(@()fclose(infile));
catch me
    throw(me);
end

%% get first line information
tline = fgetl(infile); %1

first_line = num2cell(sscanf(tline, '%i %i %f %f %*s'));
[def.nsteps, def.ictrl, def.increment, def.temperature] = deal(first_line{:});

%% read velocity gradient flags
tline = fgetl(infile); %2
tline = fgetl(infile); %3
def.vg_flag(1,:) = sscanf(tline, '%i %i %i %*s');
tline = fgetl(infile); %4
def.vg_flag(2,:) = sscanf(tline, '%i %i %i %*s');
tline = fgetl(infile); %5
def.vg_flag(3,:) = sscanf(tline, '%i %i %i %*s');

%% read velocity gradient
tline = fgetl(infile); %6
tline = fgetl(infile); %7
def.velocity_gradient(1,:) = sscanf(tline, '%f %f %f %*s');
tline = fgetl(infile); %8
def.velocity_gradient(2,:) = sscanf(tline, '%f %f %f %*s');
tline = fgetl(infile); %9
def.velocity_gradient(3,:) = sscanf(tline, '%f %f %f %*s');

%% read cauchy flags
tline = fgetl(infile); %10
tline = fgetl(infile); %11
def.cauchy_flag(1,:) = sscanf(tline, '%i %i %i %*s');
tline = fgetl(infile); %12
def.cauchy_flag(2,2:3) = sscanf(tline, '%i %i %*s');
tline = fgetl(infile); %13
def.cauchy_flag(3,3) = sscanf(tline, '%i %*s');

%def.update_cauchy_flag;

%% read cauchy stress
tline = fgetl(infile); %14
tline = fgetl(infile); %15
def.cauchy_stress(1,:) = sscanf(tline, '%f %f %f %*s');
tline = fgetl(infile); %16
def.cauchy_stress(2,2:3) = sscanf(tline, '%f %f %*s');
tline = fgetl(infile); %17
def.cauchy_stress(3,3) = sscanf(tline, '%f %*s');

%def.update_cauchy_stress;

end

