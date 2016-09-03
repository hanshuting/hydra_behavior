function [] = runDescriptorsSpatial(id)

fileind = 1:13;
movieParam = paramAll(fileind(id));
filepath = 'C:\Shuting\Data\yeti\features\';
savepath = 'C:\Shuting\Data\yeti\features\';

timeStep = 25;
m = 3; % patches in y
n = 2; % patches in x

fprintf('processing sample: %s\n', movieParam.fileName);    

%% calculate descriptors in spatio-temporal patches
fprintf('loading parameters...\n');
load([savepath movieParam.fileName '_results_registration.mat']);
load([savepath movieParam.fileName '_results_subindx_m_1_n_1_step_' num2str(timeStep) '.mat']);

% HOF
fprintf('HOF...\n');
load([filepath movieParam.fileName '_results_hof_m_1_n_1_step_' num2str(timeStep) '.mat']);
[msHofAll,hofCoord] = gnSptpDescriptor(msHofAll,hofCoord,m,n,timeStep,hydraLength,movieParam);
subHof = msHofAll(indxSample,:);
save([savepath movieParam.fileName '_results_hof_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'msHofAll','hofCoord','-v7.3');
save([savepath movieParam.fileName '_results_hof_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'subHof','-v7.3');
clear msHofAll hofCoord subHof

% HOG
fprintf('HOG...\n');
load([filepath movieParam.fileName '_results_hog_m_1_n_1_step_' num2str(timeStep) '.mat']);
[msHogAll,hogCoord] = gnSptpDescriptor(msHogAll,hogCoord,m,n,timeStep,hydraLength,movieParam);
subHog = msHogAll(indxSample,:);
save([savepath movieParam.fileName '_results_hog_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'msHogAll','hogCoord','-v7.3');
save([savepath movieParam.fileName '_results_hog_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'subHog','-v7.3');
clear msHogAll hogCoord subHog

% MBHx
fprintf('MBHx...\n');
load([filepath movieParam.fileName '_results_mbhx_m_1_n_1_step_' num2str(timeStep) '.mat']);
[msMbhxAll,mbhxCoord] = gnSptpDescriptor(msMbhxAll,mbhxCoord,m,n,timeStep,hydraLength,movieParam);
subMbhx = msMbhxAll(indxSample,:);
save([savepath movieParam.fileName '_results_mbhx_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'msMbhxAll','mbhxCoord','-v7.3');
save([savepath movieParam.fileName '_results_mbhx_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'subMbhx','-v7.3');
clear msMbhxAll mbhxCoord subMbhx

% MBHy
fprintf('MBHy...\n');
load([filepath movieParam.fileName '_results_mbhy_m_1_n_1_step_' num2str(timeStep) '.mat']);
[msMbhyAll,mbhyCoord] = gnSptpDescriptor(msMbhyAll,mbhyCoord,m,n,timeStep,hydraLength,movieParam);
subMbhy = msMbhyAll(indxSample,:);
save([savepath movieParam.fileName '_results_mbhy_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'msMbhyAll','mbhyCoord','-v7.3');
save([savepath movieParam.fileName '_results_mbhy_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStep) '.mat'],'subMbhy','-v7.3');

fprintf('done\n');

end
