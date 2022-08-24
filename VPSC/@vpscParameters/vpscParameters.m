classdef vpscParameters < vpscParametersDefaults
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        test
    end
    
    methods
        function param = vpscParameters(varargin)
            %vpscParameters Construct an instance of this class
            %   Read in vpsc7.in or default to default parameters
            
            % generate defaults and return if no inputs
            param = param@vpscParametersDefaults;
            if nargin < 1; return; end
            
            % read from file if first argument is valid file path
            if nargin >= 1 && isfile(varargin{1})
                param.fromfile(varargin{1});
            end

            % set number of phases and processes which require looping and extending
            % default arrays to match.
            param.nPhase = get_option(varargin,'nPhase', param.nPhase, {'int', 'uint', 'double'});
            param.nProcess = get_option(varargin,'nProcess', param.nProcess, {'int', 'uint', 'double'});

            % set parameters dependent on nPhase
            param.phaseFrac = get_option(varargin,'phaseFrac', extendArrayVert(param.phaseFrac./param.nPhase, param.nPhase), {'int', 'uint', 'double'});
            param.gShapeControl = get_option(varargin,'gShapeControl', extendArrayVert(param.gShapeControl, param.nPhase), {'int', 'uint', 'double'});
            param.fragmentation = get_option(varargin,'fragmentation', extendArrayVert(param.fragmentation, param.nPhase), {'int', 'uint', 'double'});
            param.critAspectRatio = get_option(varargin,'critAspectRatio', extendArrayVert(param.critAspectRatio, param.nPhase), {'int', 'uint', 'double'});
            param.fnameTEX = get_option(varargin,'TextureFile', extendArrayVert(param.fnameTEX, param.nPhase), {'cell', 'char', 'string'});
            % set parameters dependent on nProcess
            
        end
    end
    
    methods(Static)
        function [strFormat] = varLengthStrFormat(nNumber)
            strFormat = repmat(['%f '],[1 nNumber]);
            strFormat = [strFormat '%s'];
        end
    end

    methods
        function fromfile(param, fname)
            %% Load vpsc7.in
            infile = fopen(fname);
            
            %% Read in header information
            tline = fgetl(infile);
            param.nElement = sscanf(tline, '%f %*s', 1);
            tline = fgetl(infile);
            param.nPhase = sscanf(tline, '%f %*s', 1);
            tline = fgetl(infile);
            param.phaseFrac = sscanf(tline,varLengthStrFormat(param.nPhase))';
            
            %% Phase Info
            % Initialize the phase-specific variables
            
            %%%%%%@Begley, this can go when we set the defaults?
            param.gShapeControl = repmat(0,[param.nPhase 1]);
            param.fragmentation = repmat(0,[param.nPhase 1]);
            param.critAspectRatio = repmat(25,[param.nPhase 1]);
            param.ellipsoidAspect = repmat([1 1 1],[param.nPhase 1]);
            param.ellipsoidAxesAngles = repmat([0 0 0],[param.nPhase 1]);
            param.fnameTEX = cell(param.nPhase,1);
            param.fnameSX = cell(param.nPhase,1);
            param.fnameMORPH = cell(param.nPhase,1);
            
            for i = 1:param.nPhase %get all the parameters for each phase
                
                tline = fgetl(infile); %L4
                tline = fgetl(infile); %L5
                temp = sscanf(tline, '%f %f %f %*s', 3);
                param.gShapeControl(i) = temp(1);
                param.fragmentation(i) = temp(2);
                param.critAspectRatio(i) = temp(3);
                tline = fgetl(infile); %L6
                param.ellipsoidAspect(i,:) = sscanf(tline, '%f %f %f %*s', 3)';
                tline = fgetl(infile); %L7
                param.ellipsoidAxesAngles(i,:) = sscanf(tline, '%f %f %f %*s', 3)';
                tline = fgetl(infile); %L8
                tline = fgetl(infile); %L9
                param.fnameTEX{i} = tline;
                tline = fgetl(infile); %L10
                tline = fgetl(infile); %L11
                param.fnameSX{i} = tline;
                tline = fgetl(infile); %L12
                tline = fgetl(infile); %L13
                param.fnameMORPH{i} = tline;
                
            end
            clear i temp
            
            %% Convergence parameters
            tline = fgetl(infile); %L14 (assuming single phase)
            tline = fgetl(infile); %L15
            temp = sscanf(tline, '%f %f %f %f %*s', 4);
            param.errStress = temp(1);
            param.errStrRateD = temp(2);
            param.errModuli = temp(3);
            param.errSecondOrder = temp(4);
            
            tline = fgetl(infile); %L16
            temp = sscanf(tline, '%f %f %f %*s', 3);
            param.itMaxTot = temp(1);
            param.itMaxExternal = temp(2);
            param.itMaxInternalSO = temp(3);
            
            tline = fgetl(infile); %L17
            temp = sscanf(tline, '%f %f %f %f %*s', 4);
            param.irsvar = temp(1);
            param.jrsini = temp(2);
            param.jrsfin = temp(3);
            param.jrstep = temp(4);
            
            tline = fgetl(infile); %L18
            param.iBCinv = sscanf(tline, '%f %*s', 1);
            
            %% i/o settings
            tline = fgetl(infile); %L19
            tline = fgetl(infile); %L20
            param.iRecover = sscanf(tline, '%f %*s', 1);
            
            tline = fgetl(infile); %L21
            param.iSave = sscanf(tline, '%f %*s', 1);
            
            tline = fgetl(infile); %L22
            param.iCubeComp = sscanf(tline, '%f %*s', 1);
            
            tline = fgetl(infile); %L23
            param.nWrite = sscanf(tline, '%f %*s', 1);
            
            
            %% modeling conditions
            tline = fgetl(infile); %L24
            tline = fgetl(infile); %L25
            param.interactionType = sscanf(tline, '%f %*s', 1);
            
            
            tline = fgetl(infile); %L26
            temp = sscanf(tline, '%f %f %f %*s', 3);
            param.iUpdateOri = temp(1);
            param.iUpdateMorph = temp(2);
            param.iUpdateHardening = temp(3);
            
            
            tline = fgetl(infile); %L27
            param.nNeighbor = sscanf(tline, '%f %*s', 1);
            
            tline = fgetl(infile); %L28
            param.iFluctuation = sscanf(tline, '%f %*s', 1);
            
            
            
            %% deformation processes
            tline = fgetl(infile); %L29
            tline = fgetl(infile); %L30
            param.nProcess = sscanf(tline, '%f %*s', 1);
            
            param.processType = zeros([param.nProcess 1]);
            param.processDetail = cell(param.nProcess, 1);
            tline = fgetl(infile); %L31
            
            for i = 1:param.nProcess
                tline = fgetl(infile); %L32
                param.processType(i) = sscanf(tline, '%f %*s', 1);
                tline = fgetl(infile); %L33
                param.processDetail{i} = tline;
            end
            
            fclose(infile);
        end
    end
    
end

