% script to write vpsc7.in 
pname = 'C:\Users\victoria.miller\Documents\GitHub\Random-VPSC-MTEX-code-snippets\Sample Files to Write';
fname_in = [pname filesep 'vpsc7.in'];


%  
infile = fopen(fname_in,'w');
fprintf(infile,'%u                          number of elements (nelem)',nElement);%L1
fprintf(infile,'%u                          number of phases (nph)',nPhase); %L2
fprintf(infile,'',); %L3
%L4



