% set random generator
rng(1000);

% set parameters
movieParam = paramAll_yeti(1);

% set parameters
grid_step = 5; % spatial step of extracting flows
time_step = 25;
cube_step = 2; % binning size for HOF
num_bins_hof = 9; % number of bins for HOF
numCenters = 200;
ci = 95; % percentage of variance to keep in PCA

load('/vega/brain/users/sh3276/results/flows/20150218_light_1_5hz_resized_flows_assembled_step_1.mat');
fprintf('flow data loaded\n');


bw = gnMask(movieParam);
msHofAll = temporalMaskedHof(uu_all,vv_all,cube_step,time_step,num_bins_hof,bw);

save(['/vega/brain/users/sh3276/results/' movieParam.fileName 'mask_hof.mat'],'bw','msHofAll','-v7.3');