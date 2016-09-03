function [] = flow_cdbk_galois(fileind)

% initialization
rng(1000);
numCenters = 1000;
flow_all = {};

% set parameters
video_size = 5; % in seconds
trackThresh = 0.5;
trackLength = 10;
sampleStride = 5;

filepath = '/home/sh3276/work/results/dt_results_assembled/';
infostr = ['_' num2str(video_size)...
        's_' num2str(trackThresh) '_L_' num2str(trackLength) '_W_' num2str(sampleStride)];

for i = 1:length(fileind)
    
    movieParam = paramAllDT_galois(fileind(i));
    time_step = movieParam.fr*video_size;
    
    fprintf('loading sample %s...\n',movieParam.fileName);
    load([filepath movieParam.fileName infostr '_flows.mat']);
    
    % store results
    numSample = length(flowAll);
    flow_all(end+1:end+numSample) = flowAll;
   
end

% calculate codebook
fprintf('calculating codebook...\n');
flowCenters = gnCdbk(flow_all,numCenters);
flowCenters = flowCenters(sum(isnan(flowCenters),2)==0,:);

fprintf('saving results...\n');
save(['/home/sh3276/work/results/dt_cdbk/flow_cdbk_step_' num2str(time_step) '.mat'],'flowCenters','-v7.3');

fprintf('done\n');
    
end