classdef vpscTexture < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        ngrain;
        orientations;
        weights;
        CS;
        SS;
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