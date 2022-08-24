classdef vpscParametersDefaults < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        nElement
        nPhase
        phaseFrac
        gShapeControl
        fragmentation
        critAspectRatio
        ellipsoidAspect
        ellipsoidAxesAngles
        fnameTEX
        fnameSX
        fnameMORPH
        errStress
        errStrRateD
        errModuli
        errSecondOrder
        itMaxTot
        itMaxExternal
        itMaxInternalSO
        irsvar
        jrsini
        jrsfin
        jrstep
        iBCinv
        iRecover
        iSave
        iCubeComp
        nWrite
        interactionType
        iUpdateOri
        iUpdateMorph
        iUpdateHardening
        nNeighbor
        iFluctuation
        nProcess
        processType
        processDetail
        pcysSection
        lankfordInc
    end

    methods
        function param = vpscParametersDefaults()
            %vpscParametersDefaults Construct an instance of this class
            %   Read in vpsc7.in or default to default parameters

            param.nElement = 1;
            param.nPhase = 1;
            param.phaseFrac = 1;
            param.gShapeControl = 0;
            param.fragmentation = 0;
            param.critAspectRatio = 25;
            param.ellipsoidAspect = [1 1 1];
            param.ellipsoidAxesAngles = [0 0 0];
            param.fnameTEX = {fullfile('a.tex')};
            param.fnameSX = {fullfile('a.sx')};
            param.fnameMORPH = {fullfile('a.morph')};
            param.errStress = 0.001;
            param.errStrRateD = 0.001;
            param.errModuli = 0.001;
            param.errSecondOrder = 0.001;
            param.itMaxTot = 100;
            param.itMaxExternal = 25;
            param.itMaxInternalSO = 25;
            param.irsvar = 0;
            param.jrsini = 2;
            param.jrsfin = 10;
            param.jrstep = 2;
            param.iBCinv = 1;
            param.iRecover = 0;
            param.iSave = 0;
            param.iCubeComp = 0;
            param.nWrite = 0;
            param.interactionType = 3;
            param.iUpdateOri = 1;
            param.iUpdateMorph = 1;
            param.iUpdateHardening = 1;
            param.nNeighbor = 0;
            param.iFluctuation = 0;
            param.nProcess = 1;
            param.processType = 0;
            param.processDetail = {'process.def'};
            param.pcysSection = [1 2];
            param.lankfordInc = 10;

        end
    end

end

