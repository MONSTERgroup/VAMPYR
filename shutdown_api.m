function shutdown_api()
%shutdown_API sets up path for VPSC-MTEX API
%   sets up path for VPSC-MTEX API, will be deleted and added to MTEX startup in final
%   version.

rmpath(genpath('VPSC'));

end