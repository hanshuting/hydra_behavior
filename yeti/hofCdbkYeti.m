function [] = hofCdbkYeti(m,n)

% set parameters
fileInd = 1:13;
filepath = '/vega/brain/users/sh3276/results/features/';
timeStep = 5;

% initialization
rng(1000);
numCenters = 1000;
numBins = 8;
hofAll = {};

for i = fileInd
    
    movieParam = paramAll_yeti(i);
    fprintf('loading sample: %s\n', movieParam.fileName);
    load([filepath movieParam.fileName '_results_hof_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat']);

    % store results
    numSample = length(subHof);
    hofAll(end+1:end+numSample,:) = subHof;
     
end

% calculate codebook
fprintf('calculating codebook...\n');
hofCenters = gnCdbk(hofAll,numBins,numCenters);
hofCenters = hofCenters(sum(isnan(hofCenters),2)==0,:);

fprintf('saving results...\n');
save(['/vega/brain/users/sh3276/results/hof_cdbk_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'hofCenters','-v7.3');

fprintf('done\n');

end