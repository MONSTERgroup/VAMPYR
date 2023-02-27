function store_run_data(run)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if ~exist(run.output_path,"dir")
    mkdir(run.output_path);
end

d = dir(run.magic_vpsc_box_path);
d = d(3:end);

for ii = 1:length(d)
    if ~strcmp(d(ii).name,run.vpsc_executable_name)
        movefile(fullfile(d(ii).folder,d(ii).name),fullfile(run.output_path,d(ii).name));
    end
end

save(fullfile(run.output_path,'vpsc_run.mat'), 'run','-mat');

end

