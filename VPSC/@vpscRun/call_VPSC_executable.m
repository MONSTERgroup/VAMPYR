function call_VPSC_executable(run)
%CALL_VPSC_EXECUTABLE Summary of this function goes here
%   Detailed explanation goes here

returnTo = cd(run.magic_vpsc_box_path);

run.timestamp = datetime(now,'ConvertFrom','datenum');
[status, results] = system(run.vpsc_executable_name,'-echo');

if status~=0
    status
    fclose all
    error('VPSC failed to run successfully')
end

for ii = 1:run.n_phases
    run.texture_out{ii} = vpscTexture;
    run.slip_activity{ii} = vpscSlipActivity(ii,run.single_crystal{ii}.nModesActive);
    run.texture_out{ii}.fromfile(sprintf('TEX_PH%d.OUT',ii));
    run.slip_activity{ii}.fromfile(sprintf('ACT_PH%d.OUT',ii));
    if exist(sprintf('MOR_PH%d.OUT',ii),"file")
        run.morphology_out{ii} = vpscMorphology;
        run.morphology_out{ii}.fromfile(sprintf('MOR_PH%d.OUT',ii))
    end
end
if run.parameters.iSave > 0
    run.postmort_out = vpscPostmort;
    run.postmort_out.fromfile('POSTMORT.OUT');
end
run.stress_strain = vpscStressStrain;
run.stress_strain.fromfile('STR_STR.OUT');

cd(returnTo);



end

