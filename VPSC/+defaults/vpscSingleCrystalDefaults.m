classdef vpscSingleCrystalDefaults < handle
    %VPSCSINGLECRYSTALDEFAULTS Summary of this class goes here
    %   Detailed explanation goes here

    properties
        matName
        CS
        C
        alpha
        nModesTotal
        nModesActive
        activeModes
        Modes
        constitutive
        iRateSens
        grainSize
        nRSX
    end

    properties(Dependent)
        crystalSym;
        crystalAxes;
        crystalAngles;
    end

    methods
        function sx = vpscSingleCrystalDefaults()
            %VPSCSINGLECRYSTALDEFAULTS Construct an instance of this class
            %   Detailed explanation goes here
            sx.matName = 'placeholder';
            sx.CS = crystalSymmetry('-1');
            C = [[  1    1   1   0     0     0];...
                [   1    1   1   0     0     0];...
                [   1    1   1   0     0     0];...
                [   0    0   0   1     0     0];...
                [   0    0   0   0     1     0];...
                [   0    0   0   0     0     1]];
            sx.C = tensor(C,'rank',4);
            sx.alpha = zeros([6 1]);
            sx.nModesTotal = 0;
            sx.nModesActive = 0;
            sx.activeModes = 0;
            sx.constitutive = 0;
            sx.iRateSens = 1;
            sx.grainSize = 25;
            sx.nRSX = 20; %override for independent plast. modes.
        end
    end

    methods
        function crySym = get.crystalSym(sx)
            crySym = upper(char(sx.CS.lattice));
        end
        function crystalAxes = get.crystalAxes(sx)
            crystalAxes = norm(sx.CS.axes);
        end
        function crystalAngles = get.crystalAngles(sx)
            crystalAngles = [sx.CS.alpha sx.CS.beta sx.CS.gamma]./degree;
        end
    end
end

