function tofile(param,fname_in)
%TOFILE Summary of this function goes here
%   Detailed explanation goes here

%% Header info   
infile = fopen(fname_in,'w');
c = onCleanup(@()fclose(infile));

pos = 25;

fprintf(infile, fsc({'%u',param.iregime},{'(iregime ; -1=EL , 1=VP)\n'},pos));%L1
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
    fprintf(infile, '* name and path of diffraction file (dummy if idiff=0)\n'); %L14
    fprintf(infile, '%u\n', param.idiff(i)); %L15
    fprintf(infile, '%s\n', param.fnameDIFF{i}); %L16

end

%% Convergence params

fprintf(infile,'%s\n','*PRECISION SETTINGS FOR CONVERGENCE PROCEDURES'); %L17
fprintf(infile, fsc({'%g %g %g %g',[param.errStress param.errStrRateD param.errModuli param.errSecondOrder]},{'errs,errd,errm,errso\n'}, pos)); %L18
fprintf(infile, fsc({'%u %u %u',[param.itMaxTot param.itMaxExternal param.itMaxInternalSO]},{'itmax:   max # of iter, external, internal and SO loops\n'},pos)); %L19
fprintf(infile, fsc({'%u %u %u %u',[param.irsvar param.jrsini param.jrsfin param.jrstep]},{'irsvar & jrsini,jrsfin,jrstep (dummy if irsvar=0)\n'}, pos)); %L20
%fprintf(infile, fsc({'%u',param.iBCinv},{'ibcinv (0: don''t use <Bc>**-1, 1: use <Bc>**-1 in SC eq)\n'}, pos));


%% I/O settings

fprintf(infile,'%s\n', '*INPUT/OUTPUT SETTINGS FOR THE RUN (default is zero)'); %L21
fprintf(infile, fsc({'%u',param.iRecover},{'irecover:read grain states from POSTMORT.IN (1) or not (0)?\n'}, pos)); %L22
fprintf(infile, fsc({'%u',param.iSave},{'isave:   write grain states in POSTMORT.OUT at step ''isave''?\n'}, pos)); %L23
fprintf(infile, fsc({'%u',param.iCubeComp},{'icubcomp:calculate fcc rolling components?\n'}, pos)); %L24
fprintf(infile, fsc({'%u',param.nWrite},{'nwrite (frequency of texture downloads)\n'}, pos)); %L25

%% Modeling conditions

fprintf(infile,'%s\n', '*MODELING CONDITIONS FOR THE RUN'); %L26
if length(param.interactionType)<2
    fprintf(infile, fsc({'%u',param.interactionType},{'interaction (0:FC,1:afinpe,2:secant,3:neff=xx,4:tangent,5:SO),neff\n'}, pos)); %L27
else
    fprintf(infile, fsc({'%u %g',param.interactionType},{'interaction (0:FC,1:afinpe,2:secant,3:neff=xx,4:tangent,5:SO),neff\n'}, pos)); %L27
end
fprintf(infile, fsc({'%u %u %u',[param.iUpdateOri param.iUpdateMorph param.iUpdateHardening]},{'iupdate: update orient, grain shape, hardening\n'}, pos)); %L28
fprintf(infile, fsc({'%u',param.nNeighbor},{'nneigh (0 for no neighbors, 1 for pairs, etc.)\n'}, pos)); %L29
fprintf(infile, fsc({'%u',param.iFluctuation},{'iflu (0: don''t calc, 1: calc fluctuations)\n'}, pos)); %L30

%% Processes

fprintf(infile,'%s\n', '*NUMBER OF PROCESSES (Lij const; Lij variable; PCYS ;LANKFORD; rigid rotatn)');
fprintf(infile, '%u\n', param.nProcess);
fprintf(infile,'%s\n', '*IVGVAR AND PATH\NAME OF FILE FOR EACH PROCESS');

for i = 1:param.nProcess
    
    if param.processType(i,1) == 0 || param.processType(i,1) == 1 || param.processType(i,1) == 4
        txt = num2str(param.processType(i,1));
        fprintf(infile, '%s\n',txt);
        try
            fprintf(infile, '%s\n', param.processDetail{1,i});
        catch
            fprintf(infile, '%s\n', param.processDetail{i,1});
        end
    elseif param.processType(1,i) == 2
        fprintf(infile, fsc({'%u',param.defProcess{i,1}},{'ivgvar=2 will calculate PCYS at the end\n'},pos));
        fprintf(infile, fsc({'%u %u',[param.pcysSection(1) param.pcysSection(2)]},{'--> section of stress space\n'},pos));
    elseif param.processType(1,i) == 3
        fprintf(infile, fsc({'%u',param.defProcess{i,1}},{'ivgvar=3 will calculate Lankford coefficients at the end\n'},pos));
        fprintf(infile, '%u\n', param.lankfordInc);
    end
    
end

end

