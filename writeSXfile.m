% script to write SX file
% VMM Feb 2022

pname = 'C:\Users\victoria.miller\Documents\GitHub\Random-VPSC-MTEX-code-snippets\Sample Files to Write';
fname_sx = [pname filesep 'zr76K.SX'];

infile = fopen(fname_in,'w');

%% Header info

fprintf(infile, '*Material: %s',matName); %L1
fprintf(infile, '%s                                crysym',crySym); %L2
fprintf(infile, '%f  %f  %f     %f  %f  %f         cdim(i),cang(i)',crystalAxes,crystalAngle); % L3

