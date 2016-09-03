function [] = adjustRegistrationParamCont(fileIndx,tw)
% generate registration parameter (continuous version)
% SYNOPSIS:
%     adjustRegistrationParam(fileIndx,timeStep)
% INPUT:
%     fileIndx: see fileinfo.m
%     tw: size of smoothing time windows
% 
% Shuting Han, 2015

% parameters
filepath = 'C:\Shuting\Data\yeti\features\register_param\';
savepath = 'C:\Shuting\Data\DT_results\register_param\';
movieParam = paramAll(fileIndx);

% load registration data
load([filepath movieParam.fileName '_results_registration.mat']);
numCubeFinal = length(hydraOri)-tw;

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
    hydraOri(i) = mean(hydraOriPrev(i:i+tw));
    hydraCent(i,:) = mean(hydraCentPrev(i:i+tw,:),1);
    hydraLength(i) = mean(hydraLengthPrev(i:i+tw));
end

save([savepath movieParam.fileName '_results_params_step_1.mat'],'bwReg',...
   'hydraOri','hydraCent','hydraLength','-v7.3');

end