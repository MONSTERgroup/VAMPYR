classdef vpscDeformation < defaults.vpscDeformationDefaults
    %VPSCDEFORMATION Summary of this class goes here
    %   Detailed explanation goes here

    properties
    end

    methods
        function def = vpscDeformation()
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here'
           def@defaults.vpscDeformationDefaults;
        end

       fromfile(def, fname_def);
    end
end