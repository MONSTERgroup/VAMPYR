function tofile(param,fname_in)
%TOFILE Summary of this function goes here
%   Detailed explanation goes here

%% Header info   
infile = fopen(fname_in,'w');
c = onCleanup(@()fclose(infile));

pos = 25;

fprintf(infile, fsc({'%u',param.nElement},{'number of elements (nelem)\n'},pos));%L1
fprintf(infile, fsc({'%u',param.nPhase},{'number of phases (nph)\n'},pos));%L2
fmt = [varLengthStrFormat(param.nPhase) '\n'];                     
fprintf(infile, fsc({fmt, param.phaseFrac},{'relative vol. fract. of phases (wph(i))\n'},pos)); %L3

%% Phase info 

for i = 1:param.nPhase
    
    fprintf(infile, '%s\n', ['*INFORMATION ABOUT PHASE #' num2str(i)]);%L4
    fprintf(infile, fsc({'%u %u %u',[param.gShapeControl(i) param.fragmentation(i) param.critAspectRatio(i)]},{'grain shape contrl, fragmentn, crit aspect ratio\n'},pos)); %L5 
    fprintf(infile, fsc({'%g %g %g',[param.ellipsoidAspect(i,1) param.ellipsoidAspect(i,2) param.ellipsoidAspect(i,3)]},{'initial ellipsoid ratios (dummy if ishape=4\n'},pos)); %L6
    fprintf(infile, fsc({'%g %g %g',[param.ellipsoidAxesAngles(i,1) param.ellipsoidAxesAngles(i,2) param.ellipsoidAxesAngles(i,3)]},{'init Eul ang ellips axes (dummy if ishape=3,4)\n'},pos)); %L7
    fprintf(infile, '* name and path of texture file (filetext)\n'); %L8
    fprintf(infile, '%s\n', param.fnameTEX{i}); %L9
    fprintf(infile, '* name and path of single crystal file (filecrys)\n'); %L10
    fprintf(infile, '%s\n', param.fnameSX{i}); %L11
    fprintf(infile, '* name and path of grain shape file (dummy if ishape=0) (fileaxes)\n'); %L12
    fprintf(infile, '%s\n', param.fnameMORPH{i}); %L13

end

%% Convergence params

fprintf(infile,'%s\n','*PRECISION SETTINGS FOR CONVERGENCE PROCEDURES'); %L14
fprintf(infile, fsc({'%g %g %g %g',[param.errStress param.errStrRateD param.errModuli param.errSecondOrder]},{'errs,errd,errm,errso\n'}, pos)); %L15
fprintf(infile, fsc({'%u %u %u',[param.itMaxTot param.itMaxExternal param.itMaxInternalSO]},{'itmax:   max # of iter, external, internal and SO loops\n'},pos)); %L16
fprintf(infile, fsc({'%u %u %u %u',[param.irsvar param.jrsini param.jrsfin param.jrstep]},{'irsvar & jrsini,jrsfin,jrstep (dummy if irsvar=0)\n'}, pos));
fprintf(infile, fsc({'%u',param.iBCinv},{'ibcinv (0: don''t use <Bc>**-1, 1: use <Bc>**-1 in SC eq)\n'}, pos));


%% I/O settings

fprintf(infile,'%s\n', '*INPUT/OUTPUT SETTINGS FOR THE RUN (default is zero)');
fprintf(infile, fsc({'%u',param.iRecover},{'irecover:read grain states from POSTMORT.IN (1) or not (0)?\n'}, pos));
fprintf(infile, fsc({'%u',param.iSave},{'isave:   write grain states in POSTMORT.OUT at step ''isave''?\n'}, pos));
fprintf(infile, fsc({'%u',param.iCubeComp},{'icubcomp:calculate fcc rolling components?\n'}, pos));
fprintf(infile, fsc({'%u',param.nWrite},{'nwrite (frequency of texture downloads)\n'}, pos));

%% Modeling conditions

fprintf(infile,'%s\n', '*MODELING CONDITIONS FOR THE RUN');
fprintf(infile, fsc({'%u',param.interactionType},{'interaction (0:FC,1:affine,2:secant,3:neff=10,4:tangent,5:SO)\n'}, pos));
fprintf(infile, fsc({'%u %u %u',[param.iUpdateOri param.iUpdateMorph param.iUpdateHardening]},{'iupdate: update orient, grain shape, hardening\n'}, pos));
fprintf(infile, fsc({'%u',param.nNeighbor},{'nneigh (0 for no neighbors, 1 for pairs, etc.)\n'}, pos));
fprintf(infile, fsc({'%u',param.iFluctuation},{'iflu (0: don''t calc, 1: calc fluctuations)\n'}, pos));

%% Processes

fprintf(infile,'%s\n', '*NUMBER OF PROCESSES (Lij const; Lij variable; PCYS ;LANKFORD; rigid rotatn)');
fprintf(infile, '%u\n', param.nProcess);
fprintf(infile,'%s\n', '*IVGVAR AND PATH\NAME OF FILE FOR EACH PROCESS (dummy if ivgvar=2,3)');

for i = 1:param.nProcess
    
    if param.processType(i,1) == 0 || param.processType(i,1) == 1 || param.processType(i,1) == 4
        txt = num2str(param.processType(i,1));
        fprintf(infile, '%s\n',txt);
        fprintf(infile, '%s\n', param.processDetail{i,1});
    elseif param.processType(i,1) == 2
        fprintf(infile, fsc({'%u',param.defProcess{i,1}},{'ivgvar=2 will calculate PCYS at the end\n'},pos));
        fprintf(infile, fsc({'%u %u',[param.pcysSection(1) param.pcysSection(2)]},{'--> section of stress space\n'},pos));
    elseif param.processType(i,1) == 3
        fprintf(infile, fsc({'%u',param.defProcess{i,1}},{'ivgvar=3 will calculate Lankford coefficients at the end\n'},pos));
        fprintf(infile, '%u\n', param.lankfordInc);
    end
    
end

end

