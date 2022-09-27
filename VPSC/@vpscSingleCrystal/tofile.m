function tofile(sx, fname_sx)
%TOFILE Summary of this function goes here
%   Detailed explanation goes here

%% Open writable SX file
try
    infile = fopen(fname_sx, 'w');
    c = onCleanup(@()fclose(infile));
catch me
    throw(me);
end

%% Header info

fprintf(infile, '*Material: %s\n',sx.matName); %L1
fprintf(infile, '%s                                crysym\n',sx.crystalSym); %L2
fprintf(infile, '%g\t%g\t%f\t\t%g\t%g\t%g         cdim(i),cang(i)\n',sx.crystalAxes,sx.crystalAngles); % L3

% Elastic block
fprintf(infile, '%s\n','*Elastic stiffness of single crystal [MPa]'); %L4
v = Voigt(sx.C)./10^3;
fspec ='';
for ii = 1:6
    for jj = 1:6
        if v(ii,jj) ~= 0
            fspec = append(fspec,'%-ge3\t');
        end
        if v(ii,jj) == 0
            fspec = append(fspec,'%-g  \t\t');
        end
        if jj == 6
            fspec = append(fspec,'\n');
        end
    end
end
fprintf(infile, fspec, v);

fprintf(infile, '%s\n','*Thermal expansion coefficients of single crystal[K^(-1)]'); %L11
fspec = '';
for ii = 1:6
    if sx.alpha(ii) == 0
        fspec = append(fspec, '%g ');
    else
        fspec = append(fspec, '%ge-6 ');
    end
    if ii == 6
        fspec = append(fspec, '\n');
    end
end
fprintf(infile, fspec, sx.alpha./(10^(-6))); %L12

%% Slip and twin mode info

fprintf(infile, '%s\n','SLIP AND TWINNING MODES'); %L13
fprintf(infile, '%i                                nmodesx\n',sx.nModesTotal);
fprintf(infile, '%i                                nmodes\n',sx.nModesActive);
fprintf(infile, [repmat(['%i '],[1 sx.nModesActive]) '                                mode(i)\n'],sx.activeModes); 

for i = 1:sx.nModesTotal
    
    fprintf(infile, '%s\n', sx.Modes{i}.modename); %L17
    fprintf(infile, '%i %i %i %i                       modex,nsmx,iopsysx,itwtypex\n', [i sx.Modes{i}.nsmx sx.Modes{i}.iOpSysX sx.Modes{i}.twinType]);
    
    % twin systems have an exptra parameter on a separate line
    if sx.Modes{i}.twinType ~= 0
        fprintf(infile,'%f                 twshx\n',sx.Modes{i}.twinShear);
    end
    
    % loop over each distinct slip system in the family
    for j = 1:sx.Modes{i}.nsmx
        nstr = sprintf(repmat('%i ',[1 length(sx.Modes{i}.systems(j).n.coordinates)]),int16(sx.Modes{i}.systems(j).n.coordinates));
        bstr = sprintf(repmat('%i ',[1 length(sx.Modes{i}.systems(j).b.coordinates)]),int16(sx.Modes{i}.systems(j).b.coordinates));
        fprintf(infile,[nstr '  ' bstr '\n']);
    end
    
end

%% Constitutive block

fprintf(infile, '%s\n','CONSTITUTIVE LAW'); 
fprintf(infile, '%i           Voce = 0, MTS=1\n',sx.constitutive);
fprintf(infile, '%i           iratesens (0:rate insensitive, 1:rate sensitive)\n',sx.iRateSens);
fprintf(infile, '%i           grsze --> grain size only matters if HPfactor is nonzero\n',sx.grainSize); 

% loop over active modes
for i = 1:sx.nModesActive
    
    cmode = sx.activeModes(i);
    fprintf(infile, '%s----------------------------------------------------\n',sx.Modes{cmode}.modename); 
    fprintf(infile, '%i                                             nrsx\n',sx.Modes{cmode}.nRSX);
    fprintf(infile, '%#g %#g %#g %#g %#g            tau0x,tau1x,thet0,thet1, hpfac\n',[sx.Modes{cmode}.voceParams sx.Modes{cmode}.hpFactor] );
    fprintf(infile, [repmat(['%#g '],[1 sx.nModesActive]) '       hlatex(1,im),im=1,nmodes\n'], sx.Modes{cmode}.latentHard(:));

    if sx.Modes{cmode}.twinType ~= 0 
        fprintf(infile, '%i %#g %#g               isectw,thres1,thres2\n', [sx.Modes{cmode}.iSecondTwin sx.Modes{cmode}.twThresh1 sx.Modes{cmode}.twThresh2]);
    end
    
end

end

