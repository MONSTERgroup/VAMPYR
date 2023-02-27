classdef vpscPlasticityMode < handle
    %VPSCPLASTICITYMODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        modename;
        systems;
        iOpSysX; % 1:Bidirectional, 0:Unidirectional
        twinType; % 0: slip, 1:mode 1 twin, 2: mode 2 twin
        twinShear; % only if itwtypex is 1 or 2
        nRSX;
        voceParams
        hpFactor;
        latentHard;
        iSecondTwin
        twThresh1
        twThresh2
        modeX;
    end

    properties(Dependent)
        nsmx; %number of slip systems per mode
    end
    
    methods
        function mode = vpscPlasticityMode(systems, iOpSysX, twinType, varargin)
            %VPSCPLASTICITYMODE Construct an instance of this class
            %   Detailed explanation goes here
            mode.systems = systems;
            mode.iOpSysX = iOpSysX;
            mode.twinType = twinType;
            %TODO add varargin input
        end
    end

    methods
        function nm = get.nsmx(mode)
            nm = size(mode.systems,1);
        end
    end
end

