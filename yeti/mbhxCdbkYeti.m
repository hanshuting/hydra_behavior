function [] = mbhxCdbkYeti(m,n)

% set parameters
fileInd = 1:13;
filepath = '/vega/brain/users/sh3276/results/features/';
timeStep = 5;

% initialization
rng(1000);
numCenters = 1000;
mbhxAll = {};
numBins = 8;

for i = fileInd
    
    movieParam = paramAll_yeti(i);
    fprintf('loading sample: %s\n', movieParam.fileName);
    load([filepath movieParam.fileName '_results_mbhx_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat']);

    % store results
    numSample = length(subMbhx);
    mbhxAll(end+1:end+numSample,:) = subMbhx;
     
end

% calculate codebook
fprintf('calculating codebook...\n');
mbhxCenters = gnCdbk(mbhxAll,numBins,numCenters);
mbhxCenters = mbhxCenters(sum(isnan(mbhxCenters),2)==0,:);

fprintf('saving results...\n');
save(['/vega/brain/users/sh3276/results/mbhx_cdbk_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'mbhxCenters','-v7.3');

fprintf('done\n');

end