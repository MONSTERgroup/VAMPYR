classdef vpscTexture < handle
    % VPSCTEXTURE Texture object for VPSC input or output
    %   Texture object for VPSC input or output

    properties
        ngrain;         % number of grains
        orientations;   % list of orientations
        weights;        % weight correspoinding to each orientation
        CS;             % MTEX crystal symmetry 
        SS;             % MTEX specimen symmetry
    end

    methods
        function tex = vpscTexture(CS, SS, varargin)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            if nargin==2
                tex.CS = CS;
                tex.SS = SS;
            else
                warning('Symmetries have not been set for vpscTexture')
            end
            %TODO: add ability to send euler lists instead of read from file.
        end

        fromfile(tex, fname);
        tofile(tex, fname);
    end

end