function [sol, fval] = patternsearch_optim(run_0,o)

basal = optimvar('basal',4, "LowerBound",[10 1 1 0], 'UpperBound', [500 500 500 500])
prism = optimvar('prism',4, "LowerBound",[10 1 1 0], 'UpperBound', [500 500 500 500])
pyram = optimvar('pyram',4, "LowerBound",[10 1 1 0], 'UpperBound', [1000 500 500 500])
twin  = optimvar('twin',4, "LowerBound",[10 1 1 0], 'UpperBound', [1000 500 500 500])
obj = fcn2optimexpr(@calcVPSCerrorTex, basal, prism, pyram, twin);
prob = optimproblem('Objective', obj);
show(prob)

x0.basal = [50 0 0 0];
x0.prism = [100 0 0 0];
x0.pyram = [100 0 0 0];
x0.twin = [50 0 0 0];

% options = optimoptions(@ga, 'PlotFcn', ...
%     {@gaplotscorediversity, @gaplotbestf, @gaplotgenealogy, @gaplotrange},...
%     'Display', 'iter');
options = optimoptions(@particleswarm, 'SwarmSize', 100, 'HybridFcn', @patternsearch, 'PlotFcn', {@pswplotbestf});

[sol,fval] = solve(prob,x0,'Solver','particleswarm', 'Options',options);

    function delta = calcVPSCerrorTex(basal, prism, pyram, twin)

        if basal(4) >= basal(3) || prism(4) >= prism(3) || pyram(4) >= pyram(3) || twin(4) >= twin(3)
            delta = 0.75;
            disp(delta);
        elseif basal(1)>pyram(1) || prism(1)>pyram(1) || twin(1)>pyram(1)
            delta = 0.75;
            disp(delta);
        else
            % Update the slip system values
            run_0.single_crystal{1,1}.Modes{2,1}.voceParams = basal'; % basal
            run_0.single_crystal{1,1}.Modes{1,1}.voceParams = prism'; % prismatic
            run_0.single_crystal{1,1}.Modes{4,1}.voceParams = pyram'; % pyramidal c+a
            run_0.single_crystal{1,1}.Modes{5,1}.voceParams = twin'; % tension twin

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

end