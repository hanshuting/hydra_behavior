function [] = sptpDescriptors(id)
% calculate spatiotemporal descriptors

fileind = 1:13;
movieParam = paramAll(fileind(id));
filepath = 'C:\Shuting\Data\yeti\features\features_whole_normalized\';
savepath = 'C:\Shuting\Data\yeti\features\spd\';

time_step = 25;
m = 3; % patches in y
n = 2; % patches in x

fprintf('processing sample: %s\n', movieParam.fileName);    

%% load descriptors
fprintf('loading data...\n');
load([savepath movieParam.fileName '_results_registration.mat']);
load([savepath movieParam.fileName '_results_subindx_m_1_n_1_step_' num2str(timeStep) '.mat']);
load([filepath movieParam.fileName '_results_hof_m_1_n_1_step_' num2str(time_step) '.mat']);
load([filepath movieParam.fileName '_results_hog_m_1_n_1_step_' num2str(time_step) '.mat']);
load([filepath movieParam.fileName '_results_mbh_m_1_n_1_step_' num2str(time_step) '.mat']);

%% assign descriptors to spatial patches
fprintf('assigning descriptors...\n');
[msHofAll,hofCoord] = gnSptpDescriptor(msHofAll,hofCoord,m,n,hydraLength,movieParam);
[msHogAll,hogCoord] = gnSptpDescriptor(msHogAll,hogCoord,m,n,hydraLength,movieParam);
[msMbhxAll,mbhxCoord] = gnSptpDescriptor(msMbhxAll,mbhxCoord,m,n,hydraLength,movieParam);
[msMbhyAll,mbhyCoord] = gnSptpDescriptor(msMbhyAll,mbhyCoord,m,n,hydraLength,movieParam);

%% save result
fprintf('saving results...\n');

subHof = msHofAll(indxSample);
subHog = msHogAll(indxSample);
subMbh = msMbhAll(indxSample);

save([savepath movieParam.fileName '_results_params_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat'],'bw_reg','as','indxSample','-v7.3');

save([savepath movieParam.fileName '_results_hof_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat'],'msHofAll','hofCoord','-v7.3');
save([savepath movieParam.fileName '_results_hog_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat'],'msHogAll','hogCoord','-v7.3');
save([savepath movieParam.fileName '_results_mbhx_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat'],'msMbhxAll','mbhxCoord','-v7.3');
save([savepath movieParam.fileName '_results_mbhy_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat'],'msMbhyAll','mbhyCoord','-v7.3');

save([savepath movieParam.fileName '_results_hof_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat'],'subHof','-v7.3');
save([savepath movieParam.fileName '_results_hog_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat'],'subHog','-v7.3');
save([savepath movieParam.fileName '_results_mbhx_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat'],'subMbhx','-v7.3');
save([savepath movieParam.fileName '_results_mbhy_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(time_step) '.mat'],'subMbhy','-v7.3');

fprintf('done\n');

end