function [] = flow_cdbk_yeti(m,n)

% set parameters
fileInd = 1:13;
filepath = '/vega/brain/users/sh3276/results/features/';
time_step = 5;

% initialization
rng(1000);
numCenters = 1000;
flow_all = {};

for i = fileInd
    
    movieParam = paramAll_yeti(i);
    fprintf('loading sample: %s\n', movieParam.fileName);
    load([filepath movieParam.fileName '_results_flows_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat']);

    % store results
    numSample = length(subFlows);
    flow_all(end+1:end+numSample,:) = subFlows;  
     
end

% rescale flows
flow_rescaled = cell(size(flow_all));
for i=1:size(flow_all,1)
    for j=1:size(flow_all,2)
        flow_rescaled{i,j}=flow_all{i,j}/1000;
    end
end

% calculate codebook
fprintf('calculating codebook...\n');
flowCenters = gnCdbk(flow_rescaled,numCenters);
flowCenters = flowCenters(sum(isnan(flowCenters),2)==0,:);

fprintf('saving results...\n');
save(['/vega/brain/users/sh3276/results/flow_cdbk_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat'],'flowCenters','-v7.3');

fprintf('done\n');

end