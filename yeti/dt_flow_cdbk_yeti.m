function [] = dt_flow_cdbk_yeti(video_size,trackLength,trackThresh,sampleStride)

% set parameters
fileInd = 1;

% initialization
rng(1000);
numCenters = 1000;
flow_all = {};

for i = fileInd
    
    movieParam = paramAllDT_yeti(i);
    fprintf('loading sample: %s\n', movieParam.fileName);
    
    savename = ['/vega/brain/users/sh3276/results/DT/' ...
        movieParam.fileName '_' num2str(video_size) 's_' num2str(trackThresh)...
        '_L_' num2str(trackLength) '_W_' num2str(sampleStride) '_'];
    
    load([savename 'flows.mat']);
    fprintf('file %u is loaded\n',i);

    % store results
    numSample = length(flowAll);
    flow_all(end+1:end+numSample) = flowAll;
    fprintf('file %u is done\n',i);    
     
end

flow_all = flow_all';
flowCenters = gnCdbk(flow_all,numCenters);
histFlow = assignMaskedCenters(flowAll,flowCenters,'exp');

save([savename 'flow_cdbk.mat'],'flowCenters','-v7.3');
save([savename 'histFlow.mat'],'histFlow','-v7.3');

end