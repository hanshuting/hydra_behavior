function [] = adjustRegistrationParam(fileIndx,timeStep)
% generate registration parameter
% SYNOPSIS:
%     adjustRegistrationParam(fileIndx,timeStep)
% INPUT:
%     fileIndx: see fileinfo.m
%     timeStep: size of time windows
% 
% Shuting Han, 2015

% in case of overwrite
timeStepSave = timeStep;

% parameters
% filepath = 'C:\Shuting\Data\yeti\features\register_param\';
% savepath = 'C:\Shuting\Data\DT_results\register_param\';
filepath = 'E:\Data\register_param\g6s\';
savepath = 'E:\Data\register_param\tw_results\';
movieParam = paramAll(fileIndx);

% load registration data
% load([filepath movieParam.fileName '_results_registration.mat']);
load([filepath movieParam.fileName '_register_param.mat']);
numCubeFinal = floor(length(hydraOri)/timeStepSave);

% store previous parameters
hydraOriPrev = hydraOri;
hydraCentPrev = hydraCent;
hydraLengthPrev = hydraLength;

% initialize
hydraOri = zeros(numCubeFinal,1);
hydraCent = zeros(numCubeFinal,2);
hydraLength = zeros(numCubeFinal,1);

% merge time windows
for i = 1:numCubeFinal
    
    cr_theta = hydraOriPrev((i-1)*timeStepSave+1:i*timeStepSave);
    if abs(max(cr_theta)-min(cr_theta))>150
        cr1 = sum(cr_theta>max(cr_theta)-30);
        cr2 = sum(cr_theta<min(cr_theta)+30);
        if cr1>cr2
            cr_theta = mean(cr_theta(cr_theta>max(cr_theta)-30));
        else
            cr_theta = mean(cr_theta(cr_theta<min(cr_theta)+30));
        end
    else
        cr_theta = trimmean(cr_theta,30);
    end
    hydraOri(i) = cr_theta;
    
    hydraCent(i,:) = trimmean(hydraCentPrev((i-1)*timeStepSave+1:i*timeStepSave,:),30,1);
    hydraLength(i) = trimmean(hydraLengthPrev((i-1)*timeStepSave+1:i*timeStepSave),30);
    
end

save([savepath movieParam.fileName '_results_params_step_' num2str(timeStepSave)...
    '.mat'],'bwReg','hydraOri','hydraCent','hydraLength','-v7.3');

end