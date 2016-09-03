function [] = mbhyCdbkYeti(m,n)

% set parameters
fileInd = 1:13;
filepath = '/vega/brain/users/sh3276/results/features/';
timeStep = 5;

% initialization
rng(1000);
numCenters = 1000;
mbhyAll = {};
numBins = 8;

for i = fileInd
    
    movieParam = paramAll_yeti(i);
    fprintf('loading sample: %s\n', movieParam.fileName);
    load([filepath movieParam.fileName '_results_mbhy_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat']);

    % store results
    numSample = length(subMbhy);
    mbhyAll(end+1:end+numSample,:) = subMbhy;
     
end

% calculate codebook
fprintf('calculating codebook...\n');
mbhyCenters = gnCdbk(mbhyAll,numBins,numCenters);
mbhyCenters = mbhyCenters(sum(isnan(mbhyCenters),2)==0,:);

fprintf('saving results...\n');
save(['/vega/brain/users/sh3276/results/mbhy_cdbk_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'mbhyCenters','-v7.3');

fprintf('done\n');

end