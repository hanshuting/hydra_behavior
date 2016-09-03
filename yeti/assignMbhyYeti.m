function [] = assignMbhyYeti(arrayID,m,n)

rng(1000);
fileInd = 1:13;
time_step = 5;
numBins = 8;
filepath = '/vega/brain/users/sh3276/results/';
savepath = '/vega/brain/users/sh3276/results/hists/';

i = fileInd(arrayID);    
movieParam = paramAllYeti(i);
fprintf('loading sample: %s\n', movieParam.fileName);
load([filepath 'features/' movieParam.fileName '_results_mbhy_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat']);
%load([filepath '/features/' movieParam.fileName '_results_mbh_step_' num2str(time_step) '.mat']);

fprintf('loading codebooke...\n');
load([filepath 'mbhy_cdbk_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat']);

fprintf('calculating histogram...\n');
histMbhy = assignMaskedCenters(msMbhyAll,mbhyCenters,numBins,'exp');

save([savepath movieParam.fileName '_results_histMbhy_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat'],'histMbhy','-v7.3');
    
end
