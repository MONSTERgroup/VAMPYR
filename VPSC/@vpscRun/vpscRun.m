classdef vpscRun < handle
    % class guiding through the process of running VPSC.
    %
    % Syntax
    %   run = vpscRunner(vpscRun, *)
    %
    %   run = vpscRunner(vpscRun, *, *)
    %
    % Input
    %  vpscRun - @vpscRun
    %
    % Class Properties
    %  grains    - grains at the current stage of reconstruction
    %
    % References
    %
    % * <https://arxiv.org/abs/2201.02103 The variant graph approach to
    % improved parent grain reconstruction>, arXiv, 2022,
    %
    % See also
    % ThisThing ThatThing
    %

    properties
        parameters;
        single_crystal;
        processes;
        texture_in;
        texture_out;
        morphology_in;
        morphology_out;
        stress_strain;
        slip_activity;
        timestamp;
        id;
        magic_vpsc_box_path = 'VPSC\magic_vpsc_box';
        vpsc_executable_name = 'vpsc_precise.exe';
        output_path;
    end

    properties(Dependent)
        n_phases;
        n_processes;
    end

    methods

        function run = vpscRun(varargin)

            if check_option(varargin,{'follow'})
                old_run = varargin{1};
                run.parameters = old_run.parameters;
                run.single_crystal = old_run.single_crystal;
                run.processes = old_run.processes;
                run.texture_in = old_run.texture_out;
                run.morphology_in = old_run.morphology_out;
                return;
            end

            if isa(varargin{1},'vpscRun')
                old_run = varargin{1};
                run.parameters = old_run.parameters;
                run.single_crystal = old_run.single_crystal;
                run.processes = old_run.deformation;
                run.texture_in = old_run.texture_in;
                run.morphology_in = old_run.morphology_in;
                return;
            end

            if isa(varargin{1}, 'vpscParameters')
                run.parameters = varargin{1};

                for ii = 1:run.parameters.nPhase
                    run.single_crystal{ii} = vpscSingleCrystal;
                    run.texture_in{ii} = vpscTexture;
                    run.morphology_in{ii} = vpscMorphology;
                end
                
                for ii = 1:run.parameters.nProcess
                    if run.parameters.processType(ii) == 0
                        run.processes{ii} = vpscDeformation;
                    end
                    if run.parameters.processType(ii) == 4
                        run.processes{ii} = vpscRotation;
                    end
                end

            end

        end

        %prompt_for_run_setup(run);
        write_inputs_to_magic_vpsc_box(run);
        call_VPSC_executable(run);
        store_run_data(run);
        %generate_plots(run);
        cleanup(run);

        %% Dependent properties get fcns

        function n = get.n_phases(run)
            n = run.parameters.nPhase;
        end

        function n = get.n_processes(run)
            n = run.parameters.nProcess;
        end

    end
end