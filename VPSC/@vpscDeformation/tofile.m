function tofile(def, fname_def)
%TOFILE Summary of this function goes here
%   Detailed explanation goes here

%% Open writable DEF file
try
    infile = fopen(fname_def, 'w');
    c = onCleanup(@()fclose(infile));
catch me
    throw(me);
end

%% write first line
fprintf(infile, '%u\t%u\t%g\t%g\t\t\tnsteps\tictrl\teqincr\ttemp\n', def.nsteps, def.ictrl, def.increment, def.temperature);

%% write second line
fprintf(infile, '* boundary conditions\n');

%% write velocity gradient flags

fprintf(infile, '%u\t%u\t%u\t\tiudot\t|\tflag for vel.grad.\n', def.vg_flag(1,:));
fprintf(infile, '%u\t%u\t%u\t\t\t\t|\t(0:unknown-1:known)\n', def.vg_flag(2,:));
fprintf(infile, '%u\t%u\t%u\t\t\t\t|\n', def.vg_flag(3,:));
fprintf(infile, '\t\t\t\t\t\t|\n');

%% write velocity gradient

fprintf(infile, '%g\t%g\t%g\t\tudot\t|\tvel.grad\n', def.velocity_gradient(1,:));
fprintf(infile, '%g\t%g\t%g\t\t\t\t|\n', def.velocity_gradient(2,:));
fprintf(infile, '%g\t%g\t%g\t\t\t\t|\n', def.velocity_gradient(3,:));
fprintf(infile, '\t\t\t\t\t\t|\n');

%% write cauchy stress flags

fprintf(infile, '%u\t%u\t%u\t\tiscau\t|\tflag for Cauchy\n', def.cauchy_flag(1,:));
fprintf(infile, '\t%u\t%u\t\t\t\t|\n', def.cauchy_flag(2,2:3));
fprintf(infile, '\t\t%u\t\t\t\t|\n', def.cauchy_flag(3,3));
fprintf(infile, '\t\t\t\t\t\t|\n');

%% write cauchy stress

fprintf(infile, '%g\t%g\t%g\t\tscauchy\t|\tCauchy stress\n', def.cauchy_stress(1,:));
fprintf(infile, '\t%g\t%g\t\t\t\t|\n', def.cauchy_stress(2,2:3));
fprintf(infile, '\t\t%g\t\t\t\t|\n', def.cauchy_stress(3,3));
end