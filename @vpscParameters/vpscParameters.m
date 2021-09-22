classdef vpscParameters < handle
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
    end
    
    methods
        function this = vpscParameters(fname)
            %vpscParameters Construct an instance of this class
            %   Read in vpsc7.in or default to default parameters
            
            %% Load vpsc7.in
            infile = fopen(fname);
            
            %% Read in header information
            tline = fgetl(infile);
            this.nElement = sscanf(tline, '%f %*s', 1);
            tline = fgetl(infile);
            this.nPhase = sscanf(tline, '%f %*s', 1);
            tline = fgetl(infile);
            this.phaseFrac = sscanf(tline,varLengthStrFormat(this.nPhase))';
            
            %% Phase Info
            % Initialize the phase-specific variables
            
            %%%%%%@Begley, this can go when we set the defaults?
            this.gShapeControl = repmat(0,[this.nPhase 1]);
            this.fragmentation = repmat(0,[this.nPhase 1]);
            this.critAspectRatio = repmat(25,[this.nPhase 1]);
            this.ellipsoidAspect = repmat([1 1 1],[this.nPhase 1]);
            this.ellipsoidAxesAngles = repmat([0 0 0],[this.nPhase 1]);
            this.fnameTEX = cell(this.nPhase,1);
            this.fnameSX = cell(this.nPhase,1);
            this.fnameMORPH = cell(this.nPhase,1);
            
            for i = 1:this.nPhase %get all the parameters for each phase
                
                tline = fgetl(infile); %L4
                tline = fgetl(infile); %L5
                temp = sscanf(tline, '%f %f %f %*s', 3);
                this.gShapeControl(i) = temp(1);
                this.fragmentation(i) = temp(2);
                this.critAspectRatio(i) = temp(3);
                tline = fgetl(infile); %L6
                this.ellipsoidAspect(i,:) = sscanf(tline, '%f %f %f %*s', 3)';
                tline = fgetl(infile); %L7
                this.ellipsoidAxesAngles(i,:) = sscanf(tline, '%f %f %f %*s', 3)';
                tline = fgetl(infile); %L8
                tline = fgetl(infile); %L9
                this.fnameTEX{i} = tline;
                tline = fgetl(infile); %L10
                tline = fgetl(infile); %L11
                this.fnameSX{i} = tline;
                tline = fgetl(infile); %L12
                tline = fgetl(infile); %L13
                this.fnameMORPH{i} = tline;
                
            end
            clear i temp
            
            %% Convergence parameters
            tline = fgetl(infile); %L14 (assuming single phase)
            tline = fgetl(infile); %L15
            temp = sscanf(tline, '%f %f %f %f %*s', 4);
            this.errStress = temp(1);
            this.errStrRateD = temp(2);
            this.errModuli = temp(3);
            this.errSecondOrder = temp(4);
            
            tline = fgetl(infile); %L16
            temp = sscanf(tline, '%f %f %f %*s', 3);
            this.itMaxTot = temp(1);
            this.itMaxExternal = temp(2);
            this.itMaxInternalSO = temp(3);
            
            tline = fgetl(infile); %L17
            temp = sscanf(tline, '%f %f %f %f %*s', 4);
            this.irsvar = temp(1);
            this.jrsini = temp(2);
            this.jrsfin = temp(3);
            this.jrstep = temp(4);
            
            tline = fgetl(infile); %L18
            this.iBCinv = sscanf(tline, '%f %*s', 1);
            
            %% i/o settings
            tline = fgetl(infile); %L19
            tline = fgetl(infile); %L20
            this.iRecover = sscanf(tline, '%f %*s', 1);
            
            tline = fgetl(infile); %L21
            this.iSave = sscanf(tline, '%f %*s', 1);
            
            tline = fgetl(infile); %L22
            this.iCubeComp = sscanf(tline, '%f %*s', 1);
            
            tline = fgetl(infile); %L23
            this.nWrite = sscanf(tline, '%f %*s', 1);
            
            
            %% modeling conditions
            tline = fgetl(infile); %L24
            tline = fgetl(infile); %L25
            this.interactionType = sscanf(tline, '%f %*s', 1);
            
            
            tline = fgetl(infile); %L26
            temp = sscanf(tline, '%f %f %f %*s', 3);
            this.iUpdateOri = temp(1);
            this.iUpdateMorph = temp(2);
            this.iUpdateHardening = temp(3);
            
            
            tline = fgetl(infile); %L27
            this.nNeighbor = sscanf(tline, '%f %*s', 1);
            
            tline = fgetl(infile); %L28
            this.iFluctuation = sscanf(tline, '%f %*s', 1);
            
            
            
            %% deformation processes
            tline = fgetl(infile); %L29
            tline = fgetl(infile); %L30
            this.nProcess = sscanf(tline, '%f %*s', 1);
            
            this.processType = zeros([this.nProcess 1]);
            this.processDetail = cell(this.nProcess, 1);
            tline = fgetl(infile); %L31
            
            for i = 1:this.nProcess
                tline = fgetl(infile); %L32
                this.processType(i) = sscanf(tline, '%f %*s', 1);
                tline = fgetl(infile); %L33
                this.processDetail{i} = tline;
            end
            
            fclose(infile);
        end
    end
    
    methods(Static)
        function [strFormat] = varLengthStrFormat(nNumber)
            strFormat = repmat(['%f '],[1 nNumber]);
            strFormat = [strFormat '%s'];
        end
    end
    
end

