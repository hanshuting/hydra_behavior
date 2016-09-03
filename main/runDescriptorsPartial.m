function [] = runDescriptorsPartial(arrayID)

fileind = 1:13;
filepath = 'C:\Shuting\Data\yeti\features\';
savepath = 'C:\Shuting\Data\yeti\features\';

movieParam = paramAll(fileind(arrayID));
timeStepSave = 25;
cubeStep = 5;
numBins = 8;
   
load([savepath movieParam.fileName '_results_registration.mat']);
load([savepath movieParam.fileName '_results_subindx_m_1_n_1_step_' ...
    num2str(timeStepSave) '.mat']);

%% calculate descriptors
% HOF
fprintf('calculating HOF...\n');
[msHofAll,hofCoord] = temporalMaskedHof(uuReg,vvReg,cubeStep,timeStepSave,numBins,bwReg);
numSample = length(msHofAll);
indxSample = randperm(numSample);
indxSample = indxSample(1:round(0.1*numSample));
% save indx
save([savepath movieParam.fileName '_results_subindx_m_1_n_1_step_' ...
    num2str(timeStepSave) '.mat'],'indxSample','-v7.3');
subHof = msHofAll(indxSample);
fprintf('saving HOF...\n');
save([savepath movieParam.fileName '_results_hof_m_1_n_1_step_' num2str(timeStepSave) '.mat'],'msHofAll','hofCoord','-v7.3');
save([savepath movieParam.fileName '_results_hof_subsample_m_1_n_1_step_' num2str(timeStepSave) '.mat'],'subHof','-v7.3');
clear msHofAll subHof

% HOG
fprintf('calculating HOG...\n');
[msHogAll,hogCoord] = temporalMaskedHog(movieParam,hydraOri,hydraCent,cubeStep,timeStepSave,numBins,bwReg);
subHog = msHogAll(indxSample);
fprintf('saving HOG...\n');
save([savepath movieParam.fileName '_results_hog_m_1_n_1_step_' num2str(timeStepSave) '.mat'],'msHogAll','hogCoord','-v7.3');
save([savepath movieParam.fileName '_results_hog_subsample_m_1_n_1_step_' num2str(timeStepSave) '.mat'],'subHog','-v7.3');
clear msHogAll subHog

% MBH
fprintf('calculating MBH...\n');
[msMbhxAll,msMbhyAll,mbhxCoord,mbhyCoord] = temporalMaskedMbh(uuReg,vvReg,cubeStep,timeStepSave,numBins,bwReg);
subMbhx = msMbhxAll(indxSample);
subMbhy = msMbhyAll(indxSample);
fprintf('saving MBH...\n');
save([savepath movieParam.fileName '_results_mbhx_m_1_n_1_step_' num2str(timeStepSave) '.mat'],'msMbhxAll','mbhxCoord','-v7.3');
save([savepath movieParam.fileName '_results_mbhx_subsample_m_1_n_1_step_' num2str(timeStepSave) '.mat'],'subMbhx','-v7.3');
save([savepath movieParam.fileName '_results_mbhy_m_1_n_1_step_' num2str(timeStepSave) '.mat'],'msMbhyAll','mbhyCoord','-v7.3');
save([savepath movieParam.fileName '_results_mbhy_subsample_m_1_n_1_step_' num2str(timeStepSave) '.mat'],'subMbhy','-v7.3');

fprintf('done\n');


end
