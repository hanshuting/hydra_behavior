function [] = runDescriptors(id)

fileind = 1:34;
movieParam = paramAll(fileind(id));
filepath = 'C:\Shuting\Data\yeti\flows\flows_int16_1000\';
savepath = 'C:\Shuting\Data\yeti\features\';

timeStep = 5;
cubeStep = 5;
numBins = 8;
    
fprintf('processing sample: %s\n', movieParam.fileName);    

load([filepath movieParam.fileName '_flows_assembled_int16.mat']);
fprintf('flow data loaded\n');

%% registration
fprintf('registration...\n');
[bw,bg] = gnMask(movieParam,0);
[uuReg,vvReg,bwReg,hydraOri,hydraCent,hydraLength] = registerAll(movieParam,...
    uu_all,vv_all,bw,bg,timeStep);
% save registration parameteres
save([savepath movieParam.fileName '_results_registration.mat'],'timeStep',...
    'numBins','cubeStep','uuReg','vvReg','bwReg','hydraOri','hydraCent',...
    'hydraLength','-v7.3');
clear uu_all vv_all bw

%% calculate descriptors
% HOF
fprintf('calculating HOF...\n');
[msHofAll,hofCoord] = temporalMaskedHof(uuReg,vvReg,cubeStep,timeStep,numBins,bwReg);
numSample = length(msHofAll);
indxSample = randperm(numSample);
indxSample = indxSample(1:round(0.1*numSample));
% save indx
save([savepath movieParam.fileName '_results_subindx_m_1_n_1_step_' ...
    num2str(timeStep) '.mat'],'indxSample','-v7.3');
subHof = msHofAll(indxSample);
fprintf('saving HOF...\n');
save([savepath movieParam.fileName '_results_hof_m_1_n_1_step_' num2str(timeStep) '.mat'],'msHofAll','hofCoord','-v7.3');
save([savepath movieParam.fileName '_results_hof_subsample_m_1_n_1_step_' num2str(timeStep) '.mat'],'subHof','-v7.3');
clear msHofAll subHof

% HOG
fprintf('calculating HOG...\n');
[msHogAll,hogCoord] = temporalMaskedHog(movieParam,hydraOri,hydraCent,cubeStep,timeStep,numBins,bwReg);
subHog = msHogAll(indxSample);
fprintf('saving HOG...\n');
save([savepath movieParam.fileName '_results_hog_m_1_n_1_step_' num2str(timeStep) '.mat'],'msHogAll','hogCoord','-v7.3');
save([savepath movieParam.fileName '_results_hog_subsample_m_1_n_1_step_' num2str(timeStep) '.mat'],'subHog','-v7.3');
clear msHogAll subHog

% MBH
fprintf('calculating MBH...\n');
[msMbhxAll,msMbhyAll,mbhxCoord,mbhyCoord] = temporalMaskedMbh(uuReg,vvReg,cubeStep,timeStep,numBins,bwReg);
subMbhx = msMbhxAll(indxSample);
subMbhy = msMbhyAll(indxSample);
fprintf('saving MBH...\n');
save([savepath movieParam.fileName '_results_mbhx_m_1_n_1_step_' num2str(timeStep) '.mat'],'msMbhxAll','mbhxCoord','-v7.3');
save([savepath movieParam.fileName '_results_mbhx_subsample_m_1_n_1_step_' num2str(timeStep) '.mat'],'subMbhx','-v7.3');
save([savepath movieParam.fileName '_results_mbhy_m_1_n_1_step_' num2str(timeStep) '.mat'],'msMbhyAll','mbhyCoord','-v7.3');
save([savepath movieParam.fileName '_results_mbhy_subsample_m_1_n_1_step_' num2str(timeStep) '.mat'],'subMbhy','-v7.3');
% clear msMbhxAll msMbhyAll subMbhx

fprintf('done\n');


end
