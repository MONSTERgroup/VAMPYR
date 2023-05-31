
function [x, resnorm, residual, exitflag] = optimizeVPSCparameters(run_0,run_90,exp_strain_0,exp_strain_90,exp_stress_0,exp_stress_90) 

%Set optimization options for coarse optimization
options=optimset('TolFun',0.1,'TolX',0.1,'DiffMinChange',0.1,'MaxIter',500,...
    'MaxFunEvals', 1000,'FinDiffRelStep',1e-2);


%Initial parameter multiplier guess
a=[50  100 0 0;... basal 
   100 100 0 0;... prismatic
   100 100 0 0;... pyramidal c+a
   50  100 0 0]; % tension twin

% lower bound
lb = [10 1 1 -100;...
      10 1 1 -100;...
      10 1 1 -100;...
      10 1 1 -100];

% upper bound
ub = [500 500 500 500;...
      500 500 500 500;...
      1000 500 500 500;...
      1000 500 500 500];


% Optimize the fit using the nested "Calculation" function
[x, resnorm, residual,exitflag]=lsqnonlin(@calcVPSCerrorSTR,a,...
     lb, ub,options)
     % function, initial x values, lb, ub, options


    function delta = calcVPSCerrorSTR(a) 
        
        % Update the slip system values
        run_0.single_crystal{1,1}.Modes{2,1}.voceParams = a(1,:); % basal
        run_0.single_crystal{1,1}.Modes{1,1}.voceParams = a(2,:); % prismatic
        run_0.single_crystal{1,1}.Modes{4,1}.voceParams = a(3,:); % pyramidal c+a
        run_0.single_crystal{1,1}.Modes{5,1}.voceParams = a(4,:); % tension twin
        
        run_90.single_crystal{1,1}.Modes{2,1}.voceParams = a(1,:); % basal
        run_90.single_crystal{1,1}.Modes{1,1}.voceParams = a(2,:); % prismatic
        run_90.single_crystal{1,1}.Modes{4,1}.voceParams = a(3,:); % pyramidal c+a
        run_90.single_crystal{1,1}.Modes{5,1}.voceParams = a(4,:); % tension twin
        
        % run VPSC
        run_0.write_inputs_to_magic_vpsc_box; 
        run_0.call_VPSC_executable;
        run_90.write_inputs_to_magic_vpsc_box;
        run_90.call_VPSC_executable;

        sim_strain_0 = str2double(run_0.stress_strain.strainVM); 
        sim_strain_90 = str2double(run_90.stress_strain.strainVM); 
        sim_stress_0 = str2double(run_0.stress_strain.stressVM); 
        sim_stress_90 = str2double(run_90.stress_strain.stressVM);

        % compare values
        deltaSTR0 = compSTRSTR(exp_strain_0, exp_stress_0, sim_strain_0, sim_stress_0);
        deltaSTR90 = compSTRSTR(exp_strain_90, exp_stress_90, sim_strain_90, sim_stress_90); 
        delta = [deltaSTR0 deltaSTR90]; 
        delta(isnan(delta))=0;

        % compute the cost function 
        delta = delta.^2; 

    end 


end 