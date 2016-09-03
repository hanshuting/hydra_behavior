fileind = 301:322;
filepath = 'C:\Shuting\Data\yeti\hists\hists_m_2_n_2_step_5_redlight_20151129\';

time_step = 5;
m = 2;
n = 2;
histHofAll = [];
histHogAll = [];
histMbhxAll = [];
histMbhyAll = [];
acm = zeros(length(fileind)+1,1);

for i = 1:length(fileind)
    
    movieParam = paramAll(fileind(i));
    fprintf('processing sample %s...\n',movieParam.fileName);
    
    load([filepath movieParam.fileName '_results_histHof_m_' num2str(m) '_n_' ...
        num2str(n) '_step_' num2str(time_step) '.mat']);
    histHofAll(end+1:end+size(histHof,1),:) = histHof;
    
    load([filepath movieParam.fileName '_results_histHog_m_' num2str(m) '_n_' ...
        num2str(n) '_step_' num2str(time_step) '.mat']);
    histHogAll(end+1:end+size(histHog,1),:) = histHog;
    
    load([filepath movieParam.fileName '_results_histMbhx_m_' num2str(m) '_n_' ...
        num2str(n) '_step_' num2str(time_step) '.mat']);
    histMbhxAll(end+1:end+size(histMbhx,1),:) = histMbhx;
    
    load([filepath movieParam.fileName '_results_histMbhy_m_' num2str(m) '_n_' ...
        num2str(n) '_step_' num2str(time_step) '.mat']);
    histMbhyAll(end+1:end+size(histMbhy,1),:) = histMbhy;

    acm(i+1) = size(histHofAll,1);
    
end

clear histHof histHog histMbhx histMbhy

save([filepath 'all_results.mat'],'histHofAll','histHogAll','histMbhxAll','histMbhyAll','acm','-v7.3');