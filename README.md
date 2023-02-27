# MTEX-VPSC-API
MATLAB API (relying on the MTEX toolbox) for programmatically setting up and dispatching runs of the viscoplastic self-consistent model code (specifically, the FORTRAN version as implemented by Lebensohn and Tome)

```mermaid
classDiagram
class vpscParameters{
fromfile(fname)
tofile(fname)
set.doNormalizePhaseFrac(flag)
}
class vpscParametersDefaults{
        nElement : int = 1
        nPhase : int = 1
        phaseFrac : int = 1
        gShapeControl : int = 0
        fragmentation : int = 0
        critAspectRatio : int = 25
        ellipsoidAspect : intArray = [1 1 1]
        ellipsoidAxesAngles : intArray = [0 0 0]
        fnameTEX : Cell[Char] = 'phase1.tex'
        fnameSX : Cell[Char] = 'phase1.sx'
        fnameMORPH : Cell[Char] = 'phase1.morph'
        errStress : double = 0.001
        errStrRateD : double = 0.001
        errModuli : double = 0.001
        errSecondOrder : double = 0.001
        itMaxTot : int = 100
        itMaxExternal : int = 25
        itMaxInternalSO : int = 25
        irsvar : int = 0
        jrsini : int = 2
        jrsfin : int = 10
        jrstep : int = 2
        iBCinv : int = 1
        iRecover : int = 0
        iSave : int = 0
        iCubeComp : int = 0
        nWrite : int = 0
        interactionType : int = 3
        iUpdateOri : int = 1
        iUpdateMorph : int = 1
        iUpdateHardening : int = 1
        nNeighbor : int = 0
        iFluctuation : int = 0
        nProcess : int = 1
        processType : int = 0
        processDetail : Cell[Char] = 'process1.def'
        pcysSection : double = [1 2]
        lankfordInc : double = 10
set.phaseFrac(phaseFrac) : double
}

class vpscSingleCrystalDefaults{
        matName : char = 'placeholder'
        CS : crystalSymmetry = 'triclinic'
        C : Tensor[rank-4] 
        alpha : double = [0 0 0 0 0 0]
        nModesTotal : int = 0
        nModesActive : int = 0
        activeModes : int = [0]
        Modes : vpscPlasticityMode
        constitutive : int = 0
        iRateSens : int = 1
        grainSize : int = 25
        nRSX : int = 20
        /crystalSym(CS)
        /crystalAxes(CS)
        /crystalAngles(CS)
}

class vpscSingleCrystal{
fromfile(fname)
tofile(fname)
}

class vpscPlasticityMode{
        modename : char
        systems : slipSystem
        iOpSysX : logical
        twinType : int
        twinShear : double
        nRSX : double
        voceParams : [1x4]double
        hpFactor : double
        latentHard : [1xParent.nModesActive]double
        iSecondTwin : double
        twThresh1 : double
        twThresh2 : double
        modeX : int
        /nsmx(systems) : int
}

class slipSystem{
+burgersVector : Miller
+normalVector : Miller
+CS : crystalSymmetry
}

vpscParameters --|> vpscParametersDefaults : Inherits
vpscSingleCrystal --|> vpscSingleCrystalDefaults : Inherits
vpscSingleCrystalDefaults --> "nModes" vpscPlasticityMode : Contains
vpscPlasticityMode --> "nSystems" slipSystem : Contains
vpscRun <-- "1" vpscParameters : Input
vpscRun <-- "nPhases" vpscSingleCrystal : Input
vpscRun <-- "1" vpscTexture : Input
vpscRun <-- "nDeformationProcess" vpscDeformation : Input
vpscRun <-- "1" vpscMorphology : Optional
vpscRun --> "1" vpscStressStrain : Output
vpscRun --> "nWrite" vpscTexture : Output
vpscRun --> "nWrite" vpscMorphology : Output
vpscJob <-- "1..many" vpscRun : Sequence
vpscSingleCrystal <-- "1" sx_file
vpscSingleCrystal --> "1" sx_file
vpscParameters <-- "1" vpsc7_in_file
vpscParameters --> "1" vpsc7_in_file
```
