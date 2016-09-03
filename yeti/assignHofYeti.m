function [] = assignHofYeti(arrayID,m,n)

rng(1000);
fileInd = 1:13;
time_step = 5;
numBins = 8;
filepath = '/vega/brain/users/sh3276/results/';
savepath = '/vega/brain/users/sh3276/results/hists/';

i = fileInd(arrayID);    
movieParam = paramAllYeti(i);
fprintf('loading sample: %s\n', movieParam.fileName);
load([filepath 'features/'  movieParam.fileName '_results_hof_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat']);
%load([filepath '/features/' movieParam.fileName '_results_hof_step_' num2str(time_step) '.mat']);

fprintf('loading codebooke...\n');
load([filepath 'hof_cdbk_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat']);

fprintf('calculating histogram...\n');
histHof = assignMaskedCenters(msHofAll,hofCenters,numBins,'exp');

save([savepath movieParam.fileName '_results_histHof_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat'],'histHof','-v7.3');
    
end
