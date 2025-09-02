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

input_path = [pwd filesep 'non_texture_input_files'];

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
parameters_0.processDetail{1} = 'tensile.in';
parameters_0.interactionType = [3 10];

parameters_90 = vpscParameters;
parameters_90.fnameTEX{1} = 'Texture_90.TEX';
parameters_90.fnameSX{1}  = 'MgAlloy.SX';
parameters_90.processDetail{1} = 'tensile.in';
parameters_90.interactionType = [3 10];

mgSX = vpscSingleCrystal; mgSX.fromfile(fullfile(input_path, 'MgAlloy.SX'))

mgTex_0 = vpscTexture(CS, SS);
mgTex_0.fromfile(fullfile(input_path, 'Texture_0.tex'));

mgTex_90 = vpscTexture(CS, SS);
mgTex_90.fromfile(fullfile(input_path, 'Texture_90.tex'));

tensile_process = vpscDeformation;
tensile_process.velocity_gradient = [1  0    0;...
    0 -0.5  0;...
    0  0   -0.5];
tensile_process.vg_flag = ones(3);
tensile_process.nsteps = 40;
tensile_process.ictrl = 1;
tensile_process.increment = 0.0025;
tensile_process.temperature_i = 298;
tensile_process.temperature_f = 298;
tensile_process.cauchy_stress = zeros(3);
tensile_process.cauchy_flag = zeros(3);

run_0 = vpscRun(parameters_0);
run_0.single_crystal{1} = mgSX;
run_0.texture_in{1} = mgTex_0;
run_0.processes{1} = tensile_process;
run_0.magic_vpsc_box_path = 'C:\Users\benjamin.begley\Documents\GitHub\VAMPYR\VPSC\magic_vpsc_box';

run_90 = vpscRun(parameters_90);
run_90.single_crystal{1} = mgSX;
run_90.texture_in{1} = mgTex_90;
run_90.processes{1} = tensile_process;
run_90.magic_vpsc_box_path = 'C:\Users\benjamin.begley\Documents\GitHub\VAMPYR\VPSC\magic_vpsc_box';

% % Update the slip system values
% run_0.single_crystal{1,1}.Modes{2,1}.voceParams = [30  30  300  0 ]; % basal
% run_0.single_crystal{1,1}.Modes{1,1}.voceParams = [60  60  600  0 ]; % prismatic
% run_0.single_crystal{1,1}.Modes{4,1}.voceParams = [90  80  800  0 ]; % pyramidal c+a
% run_0.single_crystal{1,1}.Modes{5,1}.voceParams = [15  0   30   30]; % tension twin
% 
% run_90.single_crystal{1,1}.Modes{2,1}.voceParams = [30  30  300  0 ]; % basal
% run_90.single_crystal{1,1}.Modes{1,1}.voceParams = [60  60  600  0 ]; % prismatic
% run_90.single_crystal{1,1}.Modes{4,1}.voceParams = [90  80  800  0 ]; % pyramidal c+a
% run_90.single_crystal{1,1}.Modes{5,1}.voceParams = [15  0   30   30]; % tension twin

load(fullfile(input_path, "experimentalStressStrain.mat"));

tic

for ii = 1:50

[x{ii}, resnorm{ii}, residual{ii}, exitflag{ii}] = optimize_stress_strain(run_0,run_90,exp_strain_0,exp_strain_90,exp_stress_0,exp_stress_90);
    
end

time = toc

%% Plot the outputs
% sim_strain_0 = str2double(run_0.stress_strain.strainVM);
% sim_strain_90 = str2double(run_90.stress_strain.strainVM);
% sim_stress_0 = str2double(run_0.stress_strain.stressVM);
% sim_stress_90 = str2double(run_90.stress_strain.stressVM);
% 
% figure;
% hold on
% plot(exp_strain_0,exp_stress_0, ':', 'Color', [0.5020 0.5020 1.0000]);
% plot(exp_strain_90,exp_stress_90, ':', 'Color', [0.9255 0.6627 0.5490]);
% plot(sim_strain_0,sim_stress_0, 'Color', [0 0 1]);
% plot(sim_strain_90,sim_stress_90, 'Color', [0.8500 0.3250 0.0980]);
% xlabel('strain')
% ylabel('stress (MPa)')
% ylim([200 350])
% xlim([0 0.1])
% PrettyPlotsSingle;
% legend({'RD', 'TD', 'VPSC RD','VPSC TD'},'Location','southeast')
% hold off
% 
% export_fig optimization_results.tif -png -m2 -transparent

% figure;
% hold on
% plot(sim_strain_0,sim_stress_0, 'Color', [0 0 1]);
% xlabel('strain')
% ylabel('stress (MPa)')
% ylim([0 375])
% xlim([0 0.1])
% PrettyPlotsSingle;
% legend({'RD', 'TD', 'VPSC RD','VPSC TD'},'Location','southeast')
% hold off
% 
% export_fig single_stress_Strain -png -m2 -transparent
% 
% 
% h = Miller({0,0,0,1}, mgTex_0.CS);
% psi = deLaValleePoussinKernel('halfwidth',6*degree);
% original_ODF = calcDensity(mgTex_0.orientations, 'kernel', psi);
% 
% figure;
% plotPDF(original_ODF, h);
% hold on;
% plotPDF(original_ODF, h, 'contour', 0.5:0.5:3,'linecolor', ...
%     'black', 'linewidth', 2, 'ShowText', 'on');
% hold off;
% mtexColorbar;
% mtexColorMap LaboTeX;
% 
% export_fig texture_figure -png -m2 -transparent