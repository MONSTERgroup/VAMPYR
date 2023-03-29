classdef vpscRotation < handle
    %VPSCROTATION Rigid body rotation matrix for VPSC, represented as MTEX
    %rotation
    %   When IGVAR = 4, VPSC executes a rigid body rotation on all of the
    %   grains. This represents processes like crossrolling and ECAE.
    %   VPSC represents this rotation as a matrix, but it is held in VAMPYR
    %   as an MTEX rotation object. 
    
    properties
        rot % rotation 
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

