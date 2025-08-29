function [x, resnorm, residual, exitflag] = optimizeParametersFunction(run_0,o)

%Set optimization options for coarse optimization
options=optimset('TolFun',1e-8,'TolX',1e-8,'DiffMinChange',5,'MaxIter',500,...
    'MaxFunEvals', 1000,'FinDiffRelStep',0.001, 'Display', 'iter');


%Initial parameter multiplier guess
x_init=[50  0 0 0;... basal
    100 0 0 0;... prismatic
    100 0 0 0;... pyramidal c+a
    50  0 0 0]; % tension twin

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

A = [-1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;...
     0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0;...
     0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0;...
     0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0];

B = [0; 0; 0; 0];


% Optimize the fit using the nested "Calculation" function
[x, resnorm, residual,exitflag]=lsqnonlin(@calcVPSCerrorTex,x_init,...
    lb, ub,A,B,[],[],[],options)
% function, initial x values, lb, ub, options


% Update the slip system values
run_0.single_crystal{1,1}.Modes{2,1}.voceParams = x(1,:); % basal
run_0.single_crystal{1,1}.Modes{1,1}.voceParams = x(2,:); % prismatic
run_0.single_crystal{1,1}.Modes{4,1}.voceParams = x(3,:); % pyramidal c+a
run_0.single_crystal{1,1}.Modes{5,1}.voceParams = x(4,:); % tension twin

% run VPSC
run_0.write_inputs_to_magic_vpsc_box;
run_0.call_VPSC_executable;

% run VPSC
run_0.write_inputs_to_magic_vpsc_box;
run_0.call_VPSC_executable;

odf_f = calcDensity(run_0.texture_out{1}.orientations, 'weights', run_0.texture_out{1}.weights);
h = Miller({0,0,0,1},{1,1,-2,0},run_0.texture_in{1}.CS);
plotPDF(odf_f,h)
mtexColorMap LaboTeX;
mtexColorbar;

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
        % h = Miller({0,0,0,1},{1,1,-2,0},run_0.texture_in{1}.CS);
        %
        % plotDiff(o,odf_f,h);
        % mtexColorbar;
        % mtexColorMap blue2red;
        % pause;
        % close all;
        delta = calcError(o,odf_f);
        disp(delta);
    end

end