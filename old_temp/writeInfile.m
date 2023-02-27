% script to write vpsc7.in 
pname = 'C:\Users\victoria.miller\Documents\GitHub\Random-VPSC-MTEX-code-snippets\Sample Files to Write';
fname_in = [pname filesep 'vpsc7.in'];

%% Header info   
infile = fopen(fname_in,'w');
c = onCleanup(@()fclose(infile));
fprintf(infile,'%u                          number of elements (nelem)\n',nElement);%L1
fprintf(infile,'%u                          number of phases (nph)\n',nPhase); %L2
    fmt = [varLengthStrFormat(nPhase) '\n'];                     
fprintf(infile, fmt, phaseFrac,'              relative vol. fract. of phases (wph(i))'); %L3

%% Phase info 

for i = 1:nPhase
    
    fprintf(infile,'%s\n', ['*INFORMATION ABOUT PHASE #' num2str(i)]);%L4
    fprintf(infile,'%u %u %u                  grain shape contrl, fragmentn, crit aspect ratio\n',[gShapeControl(i) iFragment(i) critAspect(i)]); %L5 
    fprintf(infile, '%f %f %f                  initial ellipsoid ratios (dummy if ishape=4\n', [axesRatio(i,1) axesRatio(i,2) axesRatio(i,3)]); %L6
    fprintf(infile, '%f %f %f                  init Eul ang ellips axes (dummy if ishape=3,4)\n', [axesEuler(i,1) axesEuler(i,2) axesEuler(i,3)]); %L7
    fprintf(infile, '* name and path of texture file (filetext)\n'); %L8
    fprintf(infile, '%s\n', fnameTEX{i}); %L9
    fprintf(infile, '* name and path of single crystal file (filecrys)\n'); %L10
    fprintf(infile, '%s\n', fnameSX{i}); %L11
    fprintf(infile,'* name and path of grain shape file (dummy if ishape=0) (fileaxes)\n'); %L12
    fprintf(infile, '%s\n', fnameMORPH{i}); %L13

end

%% Convergence params

fprintf(infile,'%s\n','*PRECISION SETTINGS FOR CONVERGENCE PROCEDURES'); %L14
fprintf(infile, '%f %f %f %f      errs,errd,errm,errso\n', [errStress errStrainRateD errModuli errSecondOrder]); %L15
fprintf(infile, '%u %u %u      itmax:   max # of iter, external, internal and SO loops\n', [itMaxTot itMaxExternal itMaxInternalSO]); %L16
fprintf(infile, '%u %u %u %u           irsvar & jrsini,jrsfin,jrstep (dummy if irsvar=0)\n', [irsvar jrsini jrsfin jrstep] );
fprintf(infile, '%u              ibcinv (0: don''t use <Bc>**-1, 1: use <Bc>**-1 in SC eq)\n', iBCinv );


%% I/O settings

fprintf(infile,'%s\n', '*INPUT/OUTPUT SETTINGS FOR THE RUN (default is zero)');
fprintf(infile, '%u               irecover:read grain states from POSTMORT.IN (1) or not (0)?\n', iRecover);
fprintf(infile, '%u               isave:   write grain states in POSTMORT.OUT at step ''isave''?\n', iSave);
fprintf(infile, '%u               icubcomp:calculate fcc rolling components?\n', iCubeComp);
fprintf(infile, '%u               nwrite (frequency of texture downloads)\n', nWrite);


%% Modeling conditions

fprintf(infile,'%s\n', '*MODELING CONDITIONS FOR THE RUN');
fprintf(infile, '%u              interaction (0:FC,1:affine,2:secant,3:neff=10,4:tangent,5:SO)\n', iHardLaw);
fprintf(infile, '%u  %u  %u        iupdate: update orient, grain shape, hardening\n',[updateOri updateShape updateHard] );
fprintf(infile, '%u              nneigh (0 for no neighbors, 1 for pairs, etc.)\n', nNeigh);
fprintf(infile, '%u              iflu (0: don''t calc, 1: calc fluctuations)\n', iFluct);

%% Processes

fprintf(infile,'%s\n', '*NUMBER OF PROCESSES (Lij const; Lij variable; PCYS ;LANKFORD; rigid rotatn)');
fprintf(infile, '%u\n', nProcess);
fprintf(infile,'%s\n', '*IVGVAR AND PATH\NAME OF FILE FOR EACH PROCESS (dummy if ivgvar=2,3)');

for i = 1:nProcess
    
    if defProcess{i,1} == 0 || defProcess{i,1} == 1 || defProcess{i,1} == 4
        txt = [num2str(defProcess{i,1}) '             ' char(defProcess{i,2})];
        fprintf(infile, '%s\n',txt);
        fprintf(infile, '%s\n', defProcess{i,3});
    elseif defProcess{i,1} == 2
        fprintf(infile, '%u       ivgvar=2 will calculate PCYS at the end\n',defProcess{i,1});
        fprintf(infile, '%u %u    --> section of stress space\n', [pcysSection(1) pcysSection(2)]);
    elseif defProcess{i,1} == 3
        fprintf(infile, '%u       ivgvar=3 will calculate Lankford coefficients at the end\n',defProcess{i,1});
        fprintf(infile, '%u\n', lankfordInc);
    end
    
end

fclose(infile);
