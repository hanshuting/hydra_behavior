function [] = assignMbhy(arrayID,m,n)

rng(1000);
fileInd = 1:13;
timeStep = 5;
numBins = 8;
filepath = 'C:\Shuting\Data\DT_results\dt_results_assembled\';
savepath = 'C:\Shuting\Data\DT_results\hists_20151102\';

i = fileInd(arrayID);    
movieParam = paramAll_yeti(i);
fprintf('loading sample: %s\n', movieParam.fileName);
load([filepath 'features/' movieParam.fileName '_results_mbhy_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat']);
%load([filepath '/features/' movieParam.fileName '_results_mbh_step_' num2str(time_step) '.mat']);

fprintf('loading codebooke...\n');
load([filepath 'mbhy_cdbk_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat']);

fprintf('calculating histogram...\n');
histMbhy = assignMaskedCenters(msMbhyAll,mbhyCenters,numBins,'exp');

save([savepath movieParam.fileName '_results_histMbhy_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'histMbhy','-v7.3');
    
end
