% initialization
rng(1000);

% set parameters

fileInd = [1,2,3,4,5,7,8];

grid_step = 5; % spatial step of extracting flows
time_step = 10;
cube_step = 10; % binning size for HOF
num_bins_hof = 9; % number of bins for HOF
num_bins_hog = 9;
numCenters = 1000;

%% combine all samples

flow_all = {};
hof_all = {};
hog_all = {};
mbh_all = {};

for i = fileInd
    
    movieParam = paramAll_yeti(i);
    
    fprintf('processing sample: %s\n', movieParam.fileName);
    
    %load(['/vega/brain/users/sh3276/results/' movieParam.filenameBasis
    %'results_time_step_5.mat']);
    
    % load flow data
    load(['/vega/brain/users/sh3276/results/' movieParam.fileName 'flows_assembled_step_1.mat']);
    fprintf('flow data loaded\n');
    
    % calculate results
    bw = gnMask(movieParam);
    fprintf('mask calculation done\n');
    [uu_reg,vv_reg,bw_reg,theta,centroid] = registerAll(movieParam,uu_all,vv_all,bw,time_step);
    fprintf('registration done\n');
    flows = getOpticalFlow(uu_reg,vv_reg,time_step,bw_reg);
    fprintf('flow representation done\n');
    msHofAll = temporalMaskedHof(single(uu_reg),single(vv_reg),cube_step,time_step,num_bins_hof,bw_reg);
    fprintf('HOF calculation done\n');
    msHogAll = registerMaskedHog(movieParam,cube_step,time_step,num_bins_hog,bw_reg,theta,centroid);
    fprintf('HOG calculation done\n');
    msMbhAll = temporalMaskedMbh(uu_reg,vv_reg,cube_step,time_step,num_bins_hof,bw_reg);
    fprintf('MBH calculation done\n');
    
    % store results
    numSample = length(flows);
    flow_all(end+1:end+numSample) = flows;
    hof_all(end+1:end+numSample) = msHofAll;
    hog_all(end+1:end+numSample) = msHogAll;
    mbh_all(end+1:end+numSample) = msMbhAll;
    
    clear bw bw_reg centroid flowCenters flows histFlow histHofCenters histHogCenters ...
    hofCenters hogCenters msHofAll msHogAll uu_reg vv_reg
    
end


%% codebook generation and data representation
flowCenters = gnCdbk(flow_all,numCenters);
histFlow = assignMaskedCenters(flow_all,flowCenters,'exp');

hofCenters = gnCdbk(hof_all,numCenters);
histHofCenters = assignMaskedCenters(hof_all,hofCenters,'exp');

hogCenters = gnCdbk(hog_all,numCenters);
histHogCenters = assignMaskedCenters(hog_all,hogCenters,'exp');

mbhCenters = gnCdbk(mbh_all,numCenters);
histMbhCenters = assignMaskedCenters(mbh_all,mbhCenters,'exp');

%% save results
save('/vega/brain/users/sh3276/results/all_sample_results.mat','-v7.3');