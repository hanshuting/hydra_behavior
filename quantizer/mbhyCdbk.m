function [] = mbhyCdbk(m,n)
% a master function for generating codebook for MBHy
% SYNOPSIS:
%     mbhyCdbk(m,n)
% INPUT:
%     m: number of spatial patches in x
%     n: number of spatial patches in y
% 
% Shuting Han, 2015

fileInd = 1:13;
filepath = 'C:\Shuting\Data\DT_results\dt_results_assembled\';
savepath = 'C:\Shuting\Data\DT_results\cdbk_20151102\';
timeStep = 25;

% initialization
setSeed(1000);
numCenters = 1000;
numBins = 8;
mbhy_all = {};

for i = fileInd
    
    movieParam = paramAll(i);
    fprintf('loading sample: %s\n', movieParam.fileName);
%     load([filepath movieParam.fileName '_results_mbhy_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat']);
    load([filepath movieParam.fileName '_5s_0.5_L_10_W_5_mbhy.mat']);
    subMbhy = mbhyAll(randperm(length(mbhyAll),round(length(mbhyAll)/10)),:);

    % store results
    numSample = length(subMbhy);
    mbhyAll(end+1:end+numSample,:) = subMbhy;
     
end

% calculate codebook
fprintf('calculating codebook...\n');
mbhyCenters = gnCdbk(mbhyAll,numBins,numCenters);
mbhyCenters = mbhyCenters(sum(isnan(mbhyCenters),2)==0,:);

fprintf('saving results...\n');
% save(['/vega/brain/users/sh3276/results/mbhy_cdbk_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'mbhyCenters','-v7.3');
save([savepath 'mbhy_cdbk.mat'],'mbhyCenters','-v7.3');

fprintf('done\n');

end