classdef vpscSlipActivity < handle
    %VPSCSLIPACTIVITY VPSC-calculated relative slip activities for each mode. 
    %   Contains the information in the generated ACT_PHx.OUT files after
    %   a VPSC run, including the phase number (identifier), the number of
    %   slip modes in the phase, a list of strains, the average number of
    %   slip systems active per mode, and the relative activities. 
    
    properties
        phase_number; % identity of phase
        nmodes; % number of slip modes
        strain; % strain level 
        AVACS; % average number of slip systems active per mode
        activities; % relative activity of each defined slip mode
    end
    
    methods
        function act = vpscSlipActivity(phase_number, nmodes, varargin)
            %VPSCSLIPACTIVITY Construct an instance of this class
            %   Detailed explanation goes here
            act.phase_number = phase_number;
            act.nmodes = nmodes;
            return;
        end
        
        fromfile(act,act_file);
        tofile(act,act_file);
    end
end

