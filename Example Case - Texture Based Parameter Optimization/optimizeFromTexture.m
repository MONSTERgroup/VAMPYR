% Script to optimize VPSC Voce parameters using VAMPYR based on quality of
% texture match. 
% V.M. Miller, July 2025

%% load the target texture

load Mg-1Yodf.mat

%% set up the initial VPSC runs 

path = pwd; 

% VPSC infile parameters
parameters_0 = vpscParameters;
    parameters_0.fnameTEX{1} = 'Texture_0.TEX'; 
    parameters_0.fnameSX{1}  = 'MgAlloy.SX';
    parameters_0.processDetail{1} = 'rolling.in'; 
    parameters_0.interactionType = [3 10];



mgSX = vpscSingleCrystal; mgSX.fromfile(fullfile(path,'MgAlloy.SX'))

mgTex_0 = vpscTexture(crystalSymmetry('hexagonal'), specimenSymmetry('-1')); 
    mgTex_0.fromfile(fullfile(path,'Texture_0.TEX')); 

rolling_process = vpscDeformation;
    rolling_process.velocity_gradient = [0.001 0 0;...
                                         0      0 0;...
                                         0  0   -0.001];
    rolling_process.vg_flag = ones(3);
    rolling_process.nsteps = 20; 
    rolling_process.ictrl = 3; 
    rolling_process.increment = 0.02; 
    rolling_process.temperature_i = 273; 
    rolling_process.temperature_f = 273;
    rolling_process.cauchy_stress = zeros(3);
    rolling_process.cauchy_flag = zeros(3);

run_0 = vpscRun(parameters_0); 
    run_0.single_crystal{1} = mgSX; 
    run_0.texture_in{1} = mgTex_0;
    run_0.processes{1} = rolling_process;
    run_0.magic_vpsc_box_path = 'C:\Users\victoria.miller\Documents\GitHub\VAMPYR\VPSC\magic_vpsc_box';


% %%  run VPSC
% run_0.write_inputs_to_magic_vpsc_box; 
% run_0.call_VPSC_executable;

%% Throw it into an optimization loop

[x, resnorm, residual, exitflag] = optimizeParametersFunction(run_0,o) 

%% Plot the outputs
    