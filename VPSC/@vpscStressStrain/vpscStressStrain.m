classdef vpscStressStrain < handle
    %VPSCSTRESSSTRAIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        strainVM;
        stressVM;
        stress;
        strain;
        temperature;
    end
    
    methods
        function str_str = vpscStressStrain(varargin)
            %VPSCSTRESSSTRAIN Construct an instance of this class
            %   Detailed explanation goes here
            return;
        end
        tofile(str_str, fname);
        fromfile(str_str, fname);
    end
end

