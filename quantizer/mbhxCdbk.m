function [] = mbhxCdbk(m,n)
% a master function for generating codebook for MBHx
% SYNOPSIS:
%     mbhxCdbk(m,n)
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
mbhx_all = {};

for i = fileInd
    
    movieParam = paramAll(i);
    fprintf('loading sample: %s\n', movieParam.fileName);
%     load([filepath movieParam.fileName '_results_mbhx_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat']);
    load([filepath movieParam.fileName '_5s_0.5_L_10_W_5_mbhx.mat']);
    subMbhx = mbhxAll(randperm(length(mbhxAll),round(length(mbhxAll)/10)),:);

    % store results
    numSample = length(subMbhx);
    mbhx_all(end+1:end+numSample,:) = subMbhx;
     
end

% calculate codebook
fprintf('calculating codebook...\n');
mbhxCenters = gnCdbk(mbhx_all,numBins,numCenters);
mbhxCenters = mbhxCenters(sum(isnan(mbhxCenters),2)==0,:);

fprintf('saving results...\n');
% save(['/vega/brain/users/sh3276/results/mbhx_cdbk_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'mbhxCenters','-v7.3');
save([savepath 'mbhx_cdbk.mat'],'mbhxCenters','-v7.3');

fprintf('done\n');

end