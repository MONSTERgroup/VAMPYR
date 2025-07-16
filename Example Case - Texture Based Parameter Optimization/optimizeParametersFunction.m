function [x, resnorm, residual, exitflag] = optimizeParametersFunction(run_0,o) 

%Set optimization options for coarse optimization
options=optimset('TolFun',0.1,'TolX',0.1,'DiffMinChange',0.1,'MaxIter',500,...
    'MaxFunEvals', 1000,'FinDiffRelStep',1e-2);


%Initial parameter multiplier guess
a=[50  100 0 0;... basal 
   100 100 0 0;... prismatic
   100 100 0 0;... pyramidal c+a
   50  100 0 0]; % tension twin

% lower bound
lb = [10 1 1 0;...
      10 1 1 0;...
      10 1 1 0;...
      10 1 1 0];

% upper bound
ub = [500 500 500 500;...
      500 500 500 500;...
      1000 500 500 500;...
      1000 500 500 500];


% Optimize the fit using the nested "Calculation" function
[x, resnorm, residual,exitflag]=lsqnonlin(@calcVPSCerrorTex,a,...
     lb, ub,options)
     % function, initial x values, lb, ub, options


    function delta = calcVPSCerrorTex(a)

        % Update the slip system values
        run_0.single_crystal{1,1}.Modes{2,1}.voceParams = a(1,:); % basal
        run_0.single_crystal{1,1}.Modes{1,1}.voceParams = a(2,:); % prismatic
        run_0.single_crystal{1,1}.Modes{4,1}.voceParams = a(3,:); % pyramidal c+a
        run_0.single_crystal{1,1}.Modes{5,1}.voceParams = a(4,:); % tension twin

        % run VPSC
        run_0.write_inputs_to_magic_vpsc_box; 
        run_0.call_VPSC_executable;

        % simulated texture
        odf_f = calcDensity(run_0.texture_out{1}.orientations, 'weights', run_0.texture_out{1}.weights); 

        delta = calcError(o,odf_f); 

    end

end