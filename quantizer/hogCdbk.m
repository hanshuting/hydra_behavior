function [] = hogCdbk(m,n)
% a master function for generating codebook for HOG
% SYNOPSIS:
%     hoGCdbk(m,n)
% INPUT:
%     m: number of spatial patches in x
%     n: number of spatial patches in y
% 
% Shuting Han, 2015

% set parameters
fileInd = 1:13;
filepath = 'C:\Shuting\Data\DT_results\dt_results_assembled\';
savepath = 'C:\Shuting\Data\DT_results\cdbk_20151102\';
timeStep = 25;

% initialization
setSeed(1000);
numCenters = 1000;
numBins = 9;
hog_all = {};

for i = fileInd
    
    movieParam = paramAll(i);
    fprintf('loading sample: %s\n', movieParam.fileName);
%     load([filepath movieParam.fileName '_results_hog_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat']);
    load([filepath movieParam.fileName '_5s_0.5_L_10_W_5_hog.mat']);
    subHog = hogAll(randperm(length(hogAll),round(length(hogAll)/10)),:);

    % store results
    numSample = length(subHog);
    hog_all(end+1:end+numSample,:) = subHog;
     
end

% calculate codebook
fprintf('calculating codebook...\n');
hogCenters = gnCdbk(hog_all,numBins,numCenters);
hogCenters = hogCenters(sum(isnan(hogCenters),2)==0,:);

fprintf('saving results...\n');
% save(['/vega/brain/users/sh3276/results/hog_cdbk_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'hogCenters','-v7.3');
save([savepath 'hog_cdbk.mat'],'hogCenters','-v7.3');

fprintf('done\n');

end