%% Setup some plotting things

pfAnnotations = @(varargin) text([vector3d.X,vector3d.Y],{'RD','TD'},...
    'BackgroundColor','w','tag','axesLabels',varargin{:});
setMTEXpref('pfAnnotations',pfAnnotations);
plotx2east;
plotzOutOfPlane;

%% Setup an initial VPSC Run
% The poing here is to demonstrate, for an arbitrary starting texture and
% an arbitrary set of parameters, it can optimize it, instead of just a
% curated one (and I already had the code to do it, so why not).

input_path = [pwd filesep 'input_files'];

CS = crystalSymmetry('622', [2.95 2.95 4.68], 'X||a', 'Y||b*', 'Z||c', 'color', 'light blue');
SS = specimenSymmetry('-1');
psi = deLaValleePoussinKernel('halfwidth', 10*degree);

% Function generates a VPSC .tex input file with the name 'random_Mg.tex'
% at the the given path, with nOrientations orientations. Also takes CS,
% SS, and psi to make sure that ODF calculations remain consistent.

%[odf_uniform, odf_reconstructed_from_vpsc_input, error_reconstructed_from_vpsc_input] = generate_random_HCP_starting_texture(input_path,1000, CS, SS, psi);

% VPSC infile parameters
parameters_0 = vpscParameters;
parameters_0.fnameTEX{1} = 'Texture_0.TEX';
parameters_0.fnameSX{1}  = 'MgAlloy.SX';
parameters_0.processDetail{1} = 'rolling.in';
parameters_0.interactionType = [3 10];

mgSX = vpscSingleCrystal; mgSX.fromfile(fullfile(input_path, 'MgAlloy.SX'))

mgTex_0 = vpscTexture(CS, SS);
mgTex_0.fromfile(fullfile(input_path, 'random_Mg.tex'));

rolling_process = vpscDeformation;
rolling_process.velocity_gradient = [1  0  0;...
                                     0  0  0;...
                                     0  0 -1];
rolling_process.vg_flag = ones(3);
rolling_process.nsteps = 34;
rolling_process.ictrl = 3;
rolling_process.increment = 0.01;
rolling_process.temperature_i = 273;
rolling_process.temperature_f = 273;
rolling_process.cauchy_stress = zeros(3);
rolling_process.cauchy_flag = zeros(3);

run_0 = vpscRun(parameters_0);
run_0.single_crystal{1} = mgSX;
run_0.texture_in{1} = mgTex_0;
run_0.processes{1} = rolling_process;
run_0.magic_vpsc_box_path = 'C:\Users\benjamin.begley\Documents\GitHub\VAMPYR\VPSC\magic_vpsc_box';

% Update the slip system values
run_0.single_crystal{1,1}.Modes{2,1}.voceParams = [30  30  300  0 ]; % basal
run_0.single_crystal{1,1}.Modes{1,1}.voceParams = [60  60  600  0 ]; % prismatic
run_0.single_crystal{1,1}.Modes{4,1}.voceParams = [90  80  800  0 ]; % pyramidal c+a
run_0.single_crystal{1,1}.Modes{5,1}.voceParams = [15  0   30   30]; % tension twin


%%  run VPSC
run_0.write_inputs_to_magic_vpsc_box;
run_0.call_VPSC_executable;

%%

odf_simulated_rolling = calcDensity(run_0.texture_out{1}.orientations, 'weights', run_0.texture_out{1}.weights, psi);
h = Miller({0,0,0,1},{1,0,-1,0},{1,1,-2,0},CS);
Agnew_levels = [0.55 0.74 1.00 1.35 1.83 2.47 3.33 4.50 6.10];

hemisphere = 'upper';
projection = 'earea';

figure;
plotPDF(odf_reconstructed_from_vpsc_input,h, hemisphere, 'projection', projection)
hold on;
plotPDF(odf_reconstructed_from_vpsc_input,h,'contour',Agnew_levels,'linecolor','k','linewith',2, 'ShowText', 'on', hemisphere, 'projection', projection);
hold off;
mtexColorMap LaboTeX;
setColorRange('equal');
mtexColorbar('location','south', 'title', 'mrd');

figure;
plotPDF(odf_simulated_rolling,h, hemisphere, 'projection', projection)
hold on;
plotPDF(odf_simulated_rolling,h,'contour',Agnew_levels,'linecolor','k','linewith',2, 'ShowText', 'on', hemisphere, 'projection', projection);
hold off;
mtexColorMap LaboTeX;
setColorRange('equal');
mtexColorbar('location','south', 'title', 'mrd');

%%

odf_target_texture = odf_simulated_rolling;

optimization_run = vpscRun(parameters_0);
optimization_run.single_crystal{1} = mgSX;
optimization_run.texture_in{1} = mgTex_0;
optimization_run.processes{1} = rolling_process;
optimization_run.magic_vpsc_box_path = 'C:\Users\benjamin.begley\Documents\GitHub\VAMPYR\VPSC\magic_vpsc_box';

tic

[solution, value] = optimize_particleswarm(odf_target_texture, optimization_run);

time = toc