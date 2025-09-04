load('50lsqnonlin_startingpoints.mat');
parameter_names = {'Basal \tau_{0}', 'Basal \tau_{1}', 'Basal \theta_{0}', 'Basal \theta_{1}';...
    'Prism \tau_{0}', 'Prism \tau_{1}', 'Prism \theta_{0}', 'Prism \theta_{1}';...
    '<c+a> \tau_{0}', '<c+a> \tau_{1}', '<c+a> \theta_{0}', '<c+a> \theta_{1}';...
    'Twin \tau_{0}', 'Twin \tau_{1}', 'Twin \theta_{0}', 'Twin \theta_{1}';};
hardening_parameters = cell(4,4);
ff = figure;
tt = tiledlayout(4,4);


for ii = 1:4
    for jj = 1:4

        hardening_parameters{ii,jj} = cellfun(@(a) a(ii,jj), x);

        nexttile;
        histogram(hardening_parameters{ii,jj});
        title(parameter_names{ii,jj});

    end
end

%%

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

stress_0 = cell(1,50);
stress_90 = cell(1,50);
strain_0 = cell(1,50);
strain_90 = cell(1,50);

for ii = 1:50

    % Update the slip system values
    run_0.single_crystal{1,1}.Modes{2,1}.voceParams = [hardening_parameters{1,1}(ii)  hardening_parameters{1,2}(ii)  hardening_parameters{1,3}(ii)  hardening_parameters{1,4}(ii)]; % basal
    run_0.single_crystal{1,1}.Modes{1,1}.voceParams = [hardening_parameters{2,1}(ii)  hardening_parameters{2,2}(ii)  hardening_parameters{2,3}(ii)  hardening_parameters{2,4}(ii)]; % prismatic
    run_0.single_crystal{1,1}.Modes{4,1}.voceParams = [hardening_parameters{3,1}(ii)  hardening_parameters{3,2}(ii)  hardening_parameters{3,3}(ii)  hardening_parameters{3,4}(ii)]; % pyramidal c+a
    run_0.single_crystal{1,1}.Modes{5,1}.voceParams = [hardening_parameters{4,1}(ii)  hardening_parameters{4,2}(ii)  hardening_parameters{4,3}(ii)  hardening_parameters{4,4}(ii)]; % tension twin

    run_90.single_crystal{1,1}.Modes{2,1}.voceParams = [hardening_parameters{1,1}(ii)  hardening_parameters{1,2}(ii)  hardening_parameters{1,3}(ii)  hardening_parameters{1,4}(ii)]; % basal
    run_90.single_crystal{1,1}.Modes{1,1}.voceParams = [hardening_parameters{2,1}(ii)  hardening_parameters{2,2}(ii)  hardening_parameters{2,3}(ii)  hardening_parameters{2,4}(ii)]; % prismatic
    run_90.single_crystal{1,1}.Modes{4,1}.voceParams = [hardening_parameters{3,1}(ii)  hardening_parameters{3,2}(ii)  hardening_parameters{3,3}(ii)  hardening_parameters{3,4}(ii)]; % pyramidal c+a
    run_90.single_crystal{1,1}.Modes{5,1}.voceParams = [hardening_parameters{4,1}(ii)  hardening_parameters{4,2}(ii)  hardening_parameters{4,3}(ii)  hardening_parameters{4,4}(ii)]; % tension twin

    % run VPSC
    run_0.write_inputs_to_magic_vpsc_box;
    run_0.call_VPSC_executable;
    run_90.write_inputs_to_magic_vpsc_box;
    run_90.call_VPSC_executable;

    strain_0{ii} = str2double(run_0.stress_strain.strainVM);
    strain_90{ii} = str2double(run_90.stress_strain.strainVM);
    stress_0{ii} = str2double(run_0.stress_strain.stressVM);
    stress_90{ii} = str2double(run_90.stress_strain.stressVM);

end

%%

load(fullfile(input_path, "experimentalStressStrain.mat"));

failcounter_0 = 0;
failindex_0 = [];
failcounter_90 = 0;
failindex_90 = [];

figure;
patchline(exp_strain_0, exp_stress_0,'edgecolor',[1 0 0],'linewidth',4)
hold on;
for ii = 1:length(strain_0)
    if stress_0{ii}(1)<500
        patchline(strain_0{ii}, stress_0{ii},'edgecolor',[0.4 0.4 0.4],'linewidth',2,'edgealpha',0.5)
    else
        failcounter_0 = failcounter_0 +1;
        failindex_0(end+1)=ii;
    end
end
patchline(exp_strain_0, exp_stress_0,'edgecolor',[1 0 0],'linewidth',4)
hold off;
PrettyPlotsSingle;
title('0')


figure;
patchline(exp_strain_90, exp_stress_90,'edgecolor',[0 1 0],'linewidth',4)
hold on;
for ii = 1:length(strain_90)
    if stress_90{ii}(1)<500
        patchline(strain_90{ii}, stress_90{ii},'edgecolor',[0.4 0.4 0.4],'linewidth',2,'edgealpha',0.5)
    else
        failcounter_90 = failcounter_90 +1;
        failindex_90(end+1)=ii;
    end
end
patchline(exp_strain_90, exp_stress_90,'edgecolor',[0 1 0],'linewidth',4)
hold off;
PrettyPlotsSingle;
title('90')