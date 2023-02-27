classdef vpscDeformationDefaults < handle
    %VPSCDEFORMATIONDEFAULTS Summary of this class goes here
    %   Detailed explanation goes here

    properties
        nsteps;
        ictrl;
        increment;
        temperature;
        vg_flag;
        velocity_gradient;
        cauchy_flag;
        cauchy_stress;
    end

    methods
        function def = vpscDeformationDefaults()
            %UNTITLED3 Construct an instance of this class
            %   Detailed explanation goes here
            def.vg_flag = [ 0 1 1;
                1 0 1;
                1 1 1];
            def.velocity_gradient = [ 0.0 0.0 0.0;
                0.0 0.0 0.0;
                0.0 0.0 0.0];
            def.cauchy_flag = NaN(3,3,'double');
            def.cauchy_stress = NaN(3,3,'double');
        end

    end

    methods(Hidden)
        function update_cauchy_flag(def)
            def.cauchy_flag(2,1) = def.cauchy_flag(1,2);
            def.cauchy_flag(3,1) = def.cauchy_flag(1,3);
            def.cauchy_flag(3,2) = def.cauchy_flag(2,3);
        end
        function update_cauchy_stress(def)
            def.cauchy_stress(2,1) = def.cauchy_stress(1,2);
            def.cauchy_stress(3,1) = def.cauchy_stress(1,3);
            def.cauchy_stress(3,2) = def.cauchy_stress(2,3);
        end
    end
end