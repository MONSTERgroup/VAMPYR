classdef vpscSlipActivity < handle
    %VPSCSLIPACTIVITY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        phase_number;
        nmodes;
        strain;
        AVACS;
        activities;
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

