% script to write vpsc7.in 
pname = 'C:\Users\victoria.miller\Documents\GitHub\Random-VPSC-MTEX-code-snippets\Sample Files to Write';
fname_in = [pname filesep 'vpsc7.in'];


%% Header info   
infile = fopen(fname_in,'w');
fprintf(infile,'%u                          number of elements (nelem)\n',nElement);%L1
fprintf(infile,'%u                          number of phases (nph)\n',nPhase); %L2
fprintf(infile,'%s', [num2str(phaseFrac, '%.2f') '                   relative vol. fract. of phases (wph(i))\n']); %L3

%% Phase info 

for i = 1:nPhase
    
    fprintf(infile,'%s', ['*INFORMATION ABOUT PHASE #' num2str(i) '\n']);%L4
    fprintf(infile,'%.1f %.1f ',); %L5 


end

