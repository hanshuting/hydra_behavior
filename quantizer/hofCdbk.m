function [] = hofCdbk(m,n)
% a master function for generating codebook for HOF
% SYNOPSIS:
%     hofCdbk(m,n)
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
numBins = 8;
hofAll = {};

for i = fileInd
    
    movieParam = paramAll(i);
    fprintf('loading sample: %s\n', movieParam.fileName);
%     load([filepath movieParam.fileName '_results_hof_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat']);
    load([filepath movieParam.fileName '_5s_0.5_L_10_W_5_hof.mat']);
    subHof = hofAll(randperm(length(hofAll),round(length(hofAll)/10)),:);

    % store results
    numSample = length(subHof);
    hofAll(end+1:end+numSample,:) = subHof;
     
end

% calculate codebook
fprintf('calculating codebook...\n');
hofCenters = gnCdbk(hofAll,numBins,numCenters);
hofCenters = hofCenters(sum(isnan(hofCenters),2)==0,:);

fprintf('saving results...\n');
% save(['/vega/brain/users/sh3276/results/hof_cdbk_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'hofCenters','-v7.3');
save([savepath 'hof_cdbk.mat'],'hofCenters','-v7.3');

fprintf('done\n');

end