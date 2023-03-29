classdef vpscStressStrain < handle
    %VPSCSTRESSSTRAIN Stress-strain information from a VPSC run
    %   Stress-strain information from a VPSC run. Contains all of the
    %   information from STR_STR.OUT, including von Mises stress, von Mises
    %   strain, tensorial stress, tensorial strain, and temperature
    
    properties
        strainVM;       % stepwise von Mises strain
        stressVM;       % stepwise von Mises stress
        stress;         % stepwise stress tensor
        strain;         % stepwise strain tensor
        temperature;    % temperature
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

