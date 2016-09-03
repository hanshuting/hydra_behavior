function [] = runDescriptorsSpatialYeti(id)

fileind = 1:13;
movieParam = paramAllYeti(fileind(id));
filepath = '/vega/brain/users/sh3276/results/features/';
savepath = '/vega/brain/users/sh3276/results/features/';

timeStepSave = 5;
m = 3; % patches in y
n = 2; % patches in x

fprintf('processing sample: %s\n', movieParam.fileName);    

%% calculate descriptors in spatio-temporal patches
fprintf('loading parameters...\n');
load([savepath movieParam.fileName '_results_registration.mat']);
load([savepath movieParam.fileName '_results_subindx_m_1_n_1_step_' num2str(timeStepSave) '.mat']);

% HOF
fprintf('HOF...\n');
load([filepath movieParam.fileName '_results_hof_m_1_n_1_step_' num2str(timeStepSave) '.mat']);
[msHofAll,hofCoord] = gnSptpDescriptor(msHofAll,hofCoord,m,n,timeStepSave,hydraLength,movieParam);
subHof = msHofAll(indxSample,:);
save([savepath movieParam.fileName '_results_hof_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStepSave) '.mat'],'msHofAll','hofCoord','-v7.3');
save([savepath movieParam.fileName '_results_hof_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStepSave) '.mat'],'subHof','-v7.3');
clear msHofAll hofCoord subHof

% HOG
fprintf('HOG...\n');
load([filepath movieParam.fileName '_results_hog_m_1_n_1_step_' num2str(timeStepSave) '.mat']);
[msHogAll,hogCoord] = gnSptpDescriptor(msHogAll,hogCoord,m,n,timeStepSave,hydraLength,movieParam);
subHog = msHogAll(indxSample,:);
save([savepath movieParam.fileName '_results_hog_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStepSave) '.mat'],'msHogAll','hogCoord','-v7.3');
save([savepath movieParam.fileName '_results_hog_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStepSave) '.mat'],'subHog','-v7.3');
clear msHogAll hogCoord subHog

% MBHx
fprintf('MBHx...\n');
load([filepath movieParam.fileName '_results_mbhx_m_1_n_1_step_' num2str(timeStepSave) '.mat']);
[msMbhxAll,mbhxCoord] = gnSptpDescriptor(msMbhxAll,mbhxCoord,m,n,timeStepSave,hydraLength,movieParam);
subMbhx = msMbhxAll(indxSample,:);
save([savepath movieParam.fileName '_results_mbhx_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStepSave) '.mat'],'msMbhxAll','mbhxCoord','-v7.3');
save([savepath movieParam.fileName '_results_mbhx_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStepSave) '.mat'],'subMbhx','-v7.3');
clear msMbhxAll mbhxCoord subMbhx

% MBHy
fprintf('MBHy...\n');
load([filepath movieParam.fileName '_results_mbhy_m_1_n_1_step_' num2str(timeStepSave) '.mat']);
[msMbhyAll,mbhyCoord] = gnSptpDescriptor(msMbhyAll,mbhyCoord,m,n,timeStepSave,hydraLength,movieParam);
subMbhy = msMbhyAll(indxSample,:);
save([savepath movieParam.fileName '_results_mbhy_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStepSave) '.mat'],'msMbhyAll','mbhyCoord','-v7.3');
save([savepath movieParam.fileName '_results_mbhy_subsample_m_' num2str(m) '_n_' num2str(n) '_step_' num2str(timeStepSave) '.mat'],'subMbhy','-v7.3');

fprintf('done\n');

end
