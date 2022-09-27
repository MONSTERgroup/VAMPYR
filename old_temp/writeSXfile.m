% script to write SX file
% VMM Feb 2022

pname = 'C:\Users\victoria.miller\Documents\GitHub\Random-VPSC-MTEX-code-snippets\Sample Files to Write';
fname_sx = [pname filesep 'zr76K.SX'];

infile = fopen(fname_sx,'w');

    if strcmpi(crySym,'HEXAGONAL')
        mfmt = '%i %i %i %i %i %i %i %i';
    else 
        mfmt = '%i %i %i %i %i %i';
    end

%% Header info

fprintf(infile, '*Material: %s\n',matName); %L1
fprintf(infile, '%s                                crysym\n',crySym); %L2
fprintf(infile, '%f  %f  %f     %f  %f  %f         cdim(i),cang(i)\n',crystalAxes,crystalAngle); % L3

% Elastic block
fprintf(infile, '%s\n','*Elastic stiffness of single crystal [MPa]'); %L4
fprintf(infile, '%f %f %f %f %f %f\n', C(1,:));
fprintf(infile, '%f %f %f %f %f %f\n', C(2,:));
fprintf(infile, '%f %f %f %f %f %f\n', C(3,:));
fprintf(infile, '%f %f %f %f %f %f\n', C(4,:));
fprintf(infile, '%f %f %f %f %f %f\n', C(5,:));
fprintf(infile, '%f %f %f %f %f %f\n', C(6,:)); %L10

fprintf(infile, '%s\n','*Thermal expansion coefficients of single crystal[K^(-1)]'); %L11
fprintf(infile, '%f %f %f %f %f %f\n', alpha); %L12

%% Slip and twin mode info

fprintf(infile, '%s\n','SLIP AND TWINNING MODES'); %L13
fprintf(infile, '%i                                nmodesx\n',nModesTotal);
fprintf(infile, '%i                                nmodes\n',nModesActive);
fprintf(infile, [repmat(['%i '],[1 nModesActive]) '                                mode(i)\n'],activeModes); 

for i = 1:nModesTotal
    
    fprintf(infile, '%s\n', modeLabels{i,1}) %L17
    fprintf(infile, '%i %i %i %i                       modex,nsmx,iopsysx,itwtypex\n', [modeX(i) nsmX(i) iOpSysX(i) iTwTypeX(i)]);
    
    % twin systems have an exptra parameter on a separate line
    if iTwTypeX(i) ~= 0
        fprintf(infile,'%f                 twshx\n',twinShear(i));
    end
    
    % loop over each distinct slip system in the family
    for j = 1:nsmX(i)
        fprintf(infile,[mfmt ' \n'],modePlaneDir(i,j,:));
    end
    
end

%% Constitutive block

fprintf(infile, '%s\n','CONSTITUTIVE LAW'); 
fprintf(infile, '%i           Voce = 0, MTS=1\n',constitutive);
fprintf(infile, '%i           iratesens (0:rate insensitive, 1:rate sensitive)\n',iRateSens);
fprintf(infile, '%i           grsze --> grain size only matters if HPfactor is nonzero\n',grainSize); 

% loop over active modes
for i = 1:nModesActive
    
    currentMode = activeModes(i);
    fprintf(infile, '%s----------------------------------------------------\n',modeLabels{i,1}); 
    fprintf(infile, '%i                                             nrsx\n',nRSX(i));
    fprintf(infile, '%f %f %f %f %f            tau0x,tau1x,thet0,thet1, hpfac\n',[voce(i,:) hpFactor(i)] );
    fprintf(infile, [repmat(['%f '],[1 nModesActive]) '       hlatex(1,im),im=1,nmodes\n'], latentHard(i,:));

    if iTwTypeX(currentMode) ~= 0 
        fprintf(infile, '%i %f %f               isectw,thres1,thres2\n', [iSecondTwin(currentMode) twThresh1(currentMode) twThresh2(currentMode)]);
    end
    
end

fclose(infile)