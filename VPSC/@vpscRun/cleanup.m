function cleanup(run)

d = dir(run.magic_vpsc_box_path);
d = d(3:end);

for ii = 1:length(d)
    if ~strcmp(d(ii).name,run.vpsc_executable_name)
        delete(fullfile(d(ii).folder,d(ii).name));
    end
end