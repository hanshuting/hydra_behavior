function [] = assignHof(arrayID,cdbk,m,n)

%rng(1000);
setSeed(1000);
fileInd = 1:13;
% timeStep = 5;
numBins = 8;
filepath = 'C:\Shuting\Data\DT_results\dt_results_assembled\';
savepath = 'C:\Shuting\Data\DT_results\hists_20151102\';

i = fileInd(arrayID);    
movieParam = paramAll(i);
fprintf('loading sample: %s\n', movieParam.fileName);
%load([filepath 'features\'  movieParam.fileName '_results_hof_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat']);
load([filepath movieParam.fileName '_5s_0.5_L_10_W_5_hof.mat']);

% fprintf('loading codebooke...\n');
% load([filepath 'hof_cdbk_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat']);

fprintf('calculating histogram...\n');
histHof = assignMaskedCenters(msHofAll,cdbk,numBins,'exp');

% save([savepath movieParam.fileName '_results_histHof_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'histHof','-v7.3');
save([savepath movieParam.fileName '_results_histHof.mat'],'histHof','-v7.3');

end
