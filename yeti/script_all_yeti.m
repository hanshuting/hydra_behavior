% set random generator
rng(1000);

% add path
addpath('/u/10/s/sh3276/code/gist_descriptor/');

% set parameters
movieParam = paramAll_yeti(1);

%% load file

% load flow file
%load('/vega/brain/users/sh3276/results/flows/20150218_light_1_5hz_resized_flows_assembled_step_1.mat');
%load('/vega/brain/users/sh3276/results/flows/20150218_light_2_5hz_resized_flows_assembled_step_1.mat');
%load('/vega/brain/users/sh3276/results/flows/20150311_EC_light_flows_assembled_step_1.mat');
load(['/vega/brain/users/sh3276/results/flows/' movieParam.fileName '_flows_assembled_step_1.mat']);
fprintf('flow data loaded\n');

%% set parameters
time_step = 5;
cube_step = 2; % binning size for HOF
num_bins_hof = 9; % number of bins for HOF
num_bins_hog = 9;
numCenters = 1000;
ci = 95; % percentage of variance to keep in PCA

% chi-square kernel of computing histogram distances
chi_square = @(P,Q) nansum((ones(size(Q,1),1)*P-Q).^2./(2*(ones(size(Q,1),1)*P+Q)),2);

% number of time windows
numCubes = round((movieParam.numImages-1)/time_step);

%% mask calculation
bw = gnMask(movieParam);
fprintf('mask calculation done\n');

[uu_reg,vv_reg,bw_reg,theta,centroid]=registerAll(movieParam,uu_all,vv_all,bw,time_step);
fprintf('registration done\n');

flows=getOpticalFlow(uu_reg,vv_reg,time_step,bw_reg);
flowCenters = gnCdbk(flows,numCenters);
histFlow = assignMaskedCenters(flows,flowCenters,'exp');
fprintf('flow representation done\n');

msHofAll = temporalMaskedHof(single(uu_reg),single(vv_reg),cube_step,time_step,num_bins_hof,bw_reg);
hofCenters = gnCdbk(msHofAll,numCenters);
histHofCenters = assignMaskedCenters(msHofAll,hofCenters,'exp');
fprintf('HOF calculation done\n');

msHogAll = registerMaskedHog(movieParam,cube_step,time_step,num_bins_hog,bw_reg,theta,centroid);
hogCenters = gnCdbk(msHogAll,numCenters);
histHogCenters = assignMaskedCenters(msHogAll,hogCenters,'exp');
fprintf('HOG calculation done\n');

%% save file
save(['/vega/brain/users/sh3276/results/' movieParam.fileName '_results_time_step_' num2str(time_step) '.mat'],'-v7.3');
fprintf('saving results done\n');
