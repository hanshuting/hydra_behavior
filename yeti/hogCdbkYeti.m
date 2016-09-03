function [] = hogCdbkYeti(m,n)

% set parameters
fileInd = 1:13;
filepath = '/vega/brain/users/sh3276/results/features/';
timeStep = 5;

% initialization
rng(1000);
numCenters = 1000;
hog_all = {};
numBins = 8;

for i = fileInd
    
    movieParam = paramAll_yeti(i);
    fprintf('loading sample: %s\n', movieParam.fileName);
    load([filepath movieParam.fileName '_results_hog_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat']);

    % store results
    numSample = length(subHog);
    hog_all(end+1:end+numSample,:) = subHog;
     
end

% calculate codebook
fprintf('calculating codebook...\n');
hogCenters = gnCdbk(hog_all,numBins,numCenters);
hogCenters = hogCenters(sum(isnan(hogCenters),2)==0,:);

fprintf('saving results...\n');
save(['/vega/brain/users/sh3276/results/hog_cdbk_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'hogCenters','-v7.3');

fprintf('done\n');

end