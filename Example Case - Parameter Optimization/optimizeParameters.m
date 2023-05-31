%Script to optimize VPSC Voce parmeters using VAMPYR
%Victoria Miller, May 2023
%To run this script, you must have both MTEX and VAMPYR running already. 

%%  load the experimental stress strain data
% This loads stress and strain variables for specimens pulled along axes 0 degrees and
% 90 degrees from the rolling direction. 

load experimentalStressStrain.mat

%% Set up the initial VPSC runs: 
% Set
path = pwd; 
parameters_0 = vpscParameters; parameters_0.fromfile(fullfile(path, 'vpsc70.in'));
parameters_90 = vpscParameters; parameters_90.fromfile(fullfile(path, 'vpsc790.in'));

mgSX = vpscSingleCrystal; mgSX.fromfile(fullfile(path,'MgAlloy.SX'))
mgTex_0 = vpscTexture(crystalSymmetry('hexagonal'), specimenSymmetry('-1')); 
    mgTex_0.fromfile(fullfile(path,'Texture_0.TEX')); 
mgTex_90 = vpscTexture(crystalSymmetry('hexagonal'), specimenSymmetry('-1')); 
    mgTex_90.fromfile(fullfile(path,'Texture_90.TEX')); 

tensile_process = vpscDeformation; tensile_process.fromfile(fullfile(path,'tensileloading.in'));

run_0 = vpscRun(parameters_0); 
    run_0.single_crystal{1} = mgSX;
    run_0.texture_in{1} = mgTex_0; 
    run_0.processes{1} = tensile_process;
    run_0.output_path = '0 degree';
    run_0.magic_vpsc_box_path = 'C:\Users\victoria.miller\Documents\GitHub\Random-VPSC-MTEX-code-snippets\VPSC\magic_vpsc_box';
run_90 = vpscRun(parameters_90); 
    run_90.single_crystal{1} = mgSX;
    run_90.texture_in{1} = mgTex_90; 
    run_90.processes{1} = tensile_process;
    run_90.output_path = '90 degree';
    run_90.magic_vpsc_box_path = 'C:\Users\victoria.miller\Documents\GitHub\Random-VPSC-MTEX-code-snippets\VPSC\magic_vpsc_box';

%% Throw it into an optimization loop: 
[x, exitflag] = optimizeVPSCparameters(run_0,run_90,exp_strain_0,exp_strain_90,exp_stress_0,exp_stress_90) 


%% Plot the outputs
        sim_strain_0 = str2double(run_0.stress_strain.strainVM); 
        sim_strain_90 = str2double(run_90.stress_strain.strainVM); 
        sim_stress_0 = str2double(run_0.stress_strain.stressVM); 
        sim_stress_90 = str2double(run_90.stress_strain.stressVM);

figure; 
plot(exp_strain_90,exp_stress_90)
hold on
plot(exp_strain_0,exp_stress_0)
plot(sim_strain_0,sim_stress_0)
plot(sim_strain_90,sim_stress_90)
xlabel('strain')
ylabel('stress')
PrettyPlotsSingle;
