addpath('/u/10/s/sh3276/code/affinity_propagation/');

fileInd = 1:13;
filepath = '/vega/brain/users/sh3276/results/hists/';

m = 3;
n = 2;
time_step = 5;

histFlowAll = [];
histHofAll = [];
histHogAll = [];
histMbhAll = [];

for i = fileInd
    
    movieParam = paramAll_yeti(i);
    
    load([filepath movieParam.fileName 'results_histFlow_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat']);
    histFlowAll(end+1:end+size(histFlow,1),:) = histFlow;
    
    load([filepath movieParam.fileName 'results_histHof_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat']);
    histHofAll(end+1:end+size(histHof,1),:) = histHof;
    
    load([filepath movieParam.fileName 'results_histHog_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat']);
    histHogAll(end+1:end+size(histHog,1),:) = histHog;
    
    load([filepath movieParam.fileName 'results_histMbh_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat']);
    histMbhAll(end+1:end+size(histMbh,1),:) = histMbh;
    
end

clear histFlow histHof histHog histMbh

chi_square = @(P,Q) nansum((ones(size(Q,1),1)*P-Q).^2./(2*(ones(size(Q,1),1)*P+Q)),2);
histAll = sqrtHist([histFlowAll,histHofAll,histHogAll,histMbhAll]/4,3);
clear histFlowAll histHofAll histHogAll histMbhAll
distHistAll = pdist2(histAll,histAll,@(P,Q) chi_square(P,Q));
simHistAll = 1-distHistAll/max(distHistAll(:));

% kmeans
numCluster = 30;
drHistAll = drHist(histAll,95);
indAllKmeans = kmeans(drHistAll,numCluster,'replicate',3);,

% AP clustering
indAllAP = apcluster(simHistAll,median(simHistAll));
%indnum = unique(indAll);
%indAll2 = apcluster(simHistAll(indnum,indnum),median(simHistAll(indnum,indnum)));
%indnum2 = unique(indAll2);
%exampler = indnum(indnum2);
% hierarchical labelset
%indAll_hir = zeros(length(indAll),2);
%for i = 1:length(indAll)
%    indAll_hir(i,1) = find(indnum==indAll(i));
%    indAll_hir(i,2) = find(indnum2==indAll2(indAll_hir(i,1)));
%end
% define "other" class
%expdist = pdist2(histAll(exampler,:),histAll,@(P,Q) chi_square(P,Q));
%thresh = prctile(min(expdist),95);
%indAll_hir(min(expdist)>thresh,2) = 0;

save('/vega/brain/users/sh3276/results/cluster_indx.mat');
