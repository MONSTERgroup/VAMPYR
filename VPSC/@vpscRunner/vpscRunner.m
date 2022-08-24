classdef vpscRunner < handle
% class guiding through the process of running VPSC. 
%
% Syntax
%   job = vpscRunner(vpscRun, *)
%
%   job = vpscRunner(vpscRun, *, *)
%
% Input
%  vpscRun - @vpscRun
%
% Class Properties
%  grains    - grains at the current stage of reconstruction
%
% References
%
% * <https://arxiv.org/abs/2201.02103 The variant graph approach to
% improved parent grain reconstruction>, arXiv, 2022,
% 
% See also
% ThisThing ThatThing
%

    properties
        vpscRun
    end

    methods

        function job = vpscRunner(vpscRun, varargin)
            job.vpscRun = vpscRun;
        end

    end
end