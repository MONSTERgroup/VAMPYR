function [optimization_solution,function_value] = optimize_particleswarm(odf_optimization_target,optimization_run)
%OPTIMIZE_PARTICLESWARM Run a particleswarm optimization using
%   Detailed explanation goes here
arguments (Input)
    odf_optimization_target ODF;
    optimization_run vpscRun;
end

arguments (Output)
    optimization_solution
    function_value
end


basal = optimvar('basal', 4, "LowerBound", [1 0 1 0], 'UpperBound', [500 500 1000 100])
prism = optimvar('prism', 4, "LowerBound", [1 0 1 0], 'UpperBound', [500 500 1000 100])
pyram = optimvar('pyram', 4, "LowerBound", [1 0 1 0], 'UpperBound', [500 500 1000 100])
twin  = optimvar('twin',  4, "LowerBound", [1 0 1 0], 'UpperBound', [500 500 1000 100])
x0.basal = [1 0 1 0];
x0.prism = [1 0 1 0];
x0.pyram = [1 0 1 0];
x0.twin =  [1 0 1 0];

% basal = optimvar('basal', 1, "LowerBound", 1, 'UpperBound', 15)
% prism = optimvar('prism', 1, "LowerBound", 1, 'UpperBound', 15)
% pyram = optimvar('pyram', 1, "LowerBound", 1, 'UpperBound', 15)
% twin  = optimvar('twin',  1, "LowerBound", 1, 'UpperBound', 15)
% x0.basal = [1];
% x0.prism = [1];
% x0.pyram = [1];
% x0.twin =  [1];

obj = fcn2optimexpr(@calcVPSCerrorTex, basal, prism, pyram, twin);
prob = optimproblem('Objective', obj);
show(prob)

options = optimoptions(@particleswarm, 'PlotFcn', {@pswplotbestf}, 'FunctionTolerance', 1e-4);

[optimization_solution, function_value] = solve(prob, x0,'Solver','particleswarm', 'Options',options);

    function delta = calcVPSCerrorTex(basal, prism, pyram, twin)

        if basal(4) >= basal(3) || prism(4) >= prism(3) || pyram(4) >= pyram(3) || twin(4) >= twin(3)
            delta = 0.75;
            disp(delta);
        elseif basal(1)>pyram(1) || prism(1)>pyram(1) || twin(1)>pyram(1)
            delta = 0.75;
            disp(delta);
        % if basal(1)>pyram(1) || prism(1)>pyram(1) || twin(1)>pyram(1)
        %     delta = 0.75;
        %     disp(delta);
        else
            % Update the slip system values
            optimization_run.single_crystal{1,1}.Modes{2,1}.voceParams = basal'; % basal
            optimization_run.single_crystal{1,1}.Modes{1,1}.voceParams = prism'; % prismatic
            optimization_run.single_crystal{1,1}.Modes{4,1}.voceParams = pyram'; % pyramidal c+a
            optimization_run.single_crystal{1,1}.Modes{5,1}.voceParams = twin'; % tension twin
            % optimization_run.single_crystal{1,1}.Modes{2,1}.voceParams = [basal 0 0 0]; % basal
            % optimization_run.single_crystal{1,1}.Modes{1,1}.voceParams = [prism 0 0 0]; % prismatic
            % optimization_run.single_crystal{1,1}.Modes{4,1}.voceParams = [pyram 0 0 0]; % pyramidal c+a
            % optimization_run.single_crystal{1,1}.Modes{5,1}.voceParams = [twin  0 0 0]; % tension twin

            % run VPSC
            optimization_run.write_inputs_to_magic_vpsc_box;
            optimization_run.call_VPSC_executable;

            % simulated texture
            odf_optimization_run = calcDensity(optimization_run.texture_out{1}.orientations, 'weights', optimization_run.texture_out{1}.weights);
            delta = calcError(odf_optimization_target, odf_optimization_run);
            disp(delta);
        end
    end

end