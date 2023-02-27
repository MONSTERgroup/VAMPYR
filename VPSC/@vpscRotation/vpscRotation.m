classdef vpscRotation < handle
    %VPSCROTATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        rot
    end
    
    methods
        function r = vpscRotation(varargin)
            %VPSCROTATION Construct an instance of this class
            %   Detailed explanation goes here
            if nargin == 0
                r.rot = rotation.byMatrix(eye(3));
                return;
            end

            if isa(varargin{1}, 'rotation')
                r.rot = varargin{1};
            end
        end
        
        tofile(r, fname);
        fromfile(r,fname);

    end
end

