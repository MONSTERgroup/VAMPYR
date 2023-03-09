function write_inputs_to_magic_vpsc_box(run)
%WRITE_INPUTS_TO_MAGIC_VPSC_BOX Summary of this function goes here
%   Detailed explanation goes here

%disp(fullfile(run.magic_vpsc_box_path, 'vpsc7.in'));
run.parameters.tofile(fullfile(run.magic_vpsc_box_path, 'vpsc7.in'));

for ii = 1:run.n_phases
    run.single_crystal{ii}.tofile(fullfile(run.magic_vpsc_box_path, run.parameters.fnameSX{ii}));
    run.texture_in{ii}.tofile(fullfile(run.magic_vpsc_box_path, run.parameters.fnameTEX{ii}));
    if ismember(run.parameters.gShapeControl, [3, 4])
        run.morphology_in{ii}.tofile(fullfile(run.magic_vpsc_box_path, run.parameters.fnameMORPH{ii}));
    end
end

if run.parameters.iRecover
        run.postmort_in.tofile(fullfile(run.magic_vpsc_box_path, "POSTMORT.IN"));
end

for ii = 1:run.n_processes
    run.processes{ii}.tofile(fullfile(run.magic_vpsc_box_path, run.parameters.processDetail{ii}));
end

end

