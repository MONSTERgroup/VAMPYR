classdef vpscSingleCrystal < defaults.vpscSingleCrystalDefaults
    %VPSCSINGLECRYSTAL Contains the *.SX file information for a given phase
    %   The vpsc *.SX file contains the single crystal information for a
    %   given phase, including the slip/twinning systems, hardening
    %   parameters, etc. 

    properties
    end

    methods
        function sx = vpscSingleCrystal(varargin)
            %VPSCSINGLECRYSTAL Construct an instance of this class
            %   Detailed explanation goes here

            % generate defaults and return if no inputs
            sx = sx@defaults.vpscSingleCrystalDefaults;
            if nargin < 1; return; end

            % read from file if first argument is valid file path
            if nargin >= 1 && looksLikePath(varargin{1})
                if ~isfile(varargin{1})
                    ME = MException('MTEX:VPSC:noSXFileAtPath',...
                        'There is no VPSC Single Crystal file at: %s', varargin{1});
                    throw(ME);
                end
                sx.fromfile(varargin{1});
            end
        end

    end

    methods
        tofile(sx, fname_sx)
        fromfile(sx, fname_sx)
    end
end

function out = looksLikePath(str)
    pat1 = asManyOfPattern(alphanumericsPattern(1)) + '.' + asManyOfPattern(alphanumericsPattern(1));
    pat2 = filesep + asManyOfPattern(alphanumericsPattern(1));
    pat = pat1+pat2;
    out = contains(str, pat);
end