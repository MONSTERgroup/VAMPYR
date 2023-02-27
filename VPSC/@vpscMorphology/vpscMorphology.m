classdef vpscMorphology < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        ngrain;
        orientations;
        axes_lengths;
    end
    properties(Hidden)
        CS = crystalSymmetry('orthorhombic');
        SS = specimenSymmetry('-1');
    end

    methods
        function morph = vpscTexture(varargin)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            return;
            %TODO: add ability to send euler lists instead of read from file.
        end
        fromfile(morph, fname);
        tofile(morph, fname);
    end

end