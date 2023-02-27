classdef vpscParameters < defaults.vpscParametersDefaults
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        doNormalizePhaseFrac = false;
    end
    
    methods
        function param = vpscParameters(varargin)
            %vpscParameters Construct an instance of this class
            %   Read in vpsc7.in or default to default parameters
            
            % generate defaults and return if no inputs
            param = param@defaults.vpscParametersDefaults;
            if nargin < 1; return; end

            param.doNormalizePhaseFrac = get_flag(varargin,'NormalizePhaseFrac');
            varargin = delete_option(varargin,'NormalizePhaseFrac');
            
            % read from file if first argument is valid file path
            if nargin >= 1 && looksLikePath(varargin{1})
                if ~isfile(varargin{1})
                    ME = MException('MTEX:VPSC:noInputFileAtPath',...
                        'There is no VPSC input file at: %s', varargin{1});
                    throw(ME);
                end
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
            param.ellipsoidAspect = get_option(varargin,'ellpsoidAspect', extendArrayVert(param.ellipsoidAspect, param.nPhase),{'int', 'uint', 'double'});
            param.ellipsoidAxesAngles = get_option(varargin,'ellpsoidAxesAngles', extendArrayVert(param.ellipsoidAxesAngles, param.nPhase),{'int', 'uint', 'double'});
            
            % array of names 'phase1.tex...phaseN.tex'
            fnameArray = @(fn, nP) cellfun(@(y) sprintf('phase%u.%s', y,fn),num2cell(1:nP), 'UniformOutput',false)';
            param.fnameTEX = get_option(varargin,'TEX', fnameArray('tex', param.nPhase), {'cell', 'char', 'string'});
            param.fnameSX = get_option(varargin,'SX', fnameArray('sx', param.nPhase), {'cell', 'char', 'string'});
            param.fnameMORPH = get_option(varargin,'MORPH', fnameArray('morph', param.nPhase), {'cell', 'char', 'string'});
            
            % set parameters dependent on nProcess
            param.processType = get_option(varargin,'processType', extendArrayVert(param.processType, param.nPhase), {'int', 'uint', 'double'});
            fnameArray = @(fn, nP) cellfun(@(y) sprintf('process%u.%s', y,fn),num2cell(1:nP), 'UniformOutput',false)';
            param.fnameMORPH = get_option(varargin,'MORPH', fnameArray('def', param.nProcess), {'cell', 'char', 'string'});
            
        end
    end

    methods
        result = fromfile(param, fname)
        result = tofile(param, fname)
    end

    methods
        function set.doNormalizePhaseFrac(param, val)
            if strcmp(val, 'NormalizePhaseFrac')
                param.doNormalizePhaseFrac = true;
            else
                param.doNormalizePhaseFrac = false;
            end
        end
    end
    
end

function out = looksLikePath(str)
    pat1 = asManyOfPattern(alphanumericsPattern(1)) + '.' + asManyOfPattern(alphanumericsPattern(1));
    pat2 = filesep + asManyOfPattern(alphanumericsPattern(1));
    pat = pat1+pat2;
    out = contains(str, pat);
end
