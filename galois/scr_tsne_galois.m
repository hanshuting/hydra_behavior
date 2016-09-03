% script for generating embedding map and for embed new samples
addpath(genpath('/home/sh3276/software/MotionMapper/'));
addpath(genpath('/home/sh3276/work/code/bow_hydra/'));

%% initialize parameters
parameters.distType = 'chi';
parameters = setRunParameters(parameters);

%% subsample for embedding
% parameters
%fileIndx = [1:5,7:11,13:24,26:28,30:32];
%testIndx = [25,33,34];
fileIndx = 202:253;
%fileIndx = 401:413;
%testIndx = 414;
infostr = 'L_15_W_5_N_32_s_2_t_3_step_100';
datestr = '20160128_g6s';
filepath = ['/home/sh3276/work/results/dt_hists/min_var0.5/' infostr '_' datestr '/'];

% load data and subsample
percTrain = 0.8;
dataTrain = [];
dataTest = [];
numFiles = length(fileIndx);
dataAll = cell(numFiles,1);
acm = zeros(numFiles+1,1);
for i = 1:numFiles

    movieParam = paramAll_galois(fileIndx(i));
    fprintf('loading sample %s...\n',movieParam.fileName);
    
    load([filepath movieParam.fileName '_' infostr '_histHof.mat']);
    load([filepath movieParam.fileName '_' infostr '_histHog.mat']);
    load([filepath movieParam.fileName '_' infostr '_histMbhx.mat']);
    load([filepath movieParam.fileName '_' infostr '_histMbhy.mat']);
    
    numData = size(histHof,1);
    numTrain = round(percTrain*numData);
    indxTest = randperm(numData);
    indxTrain = indxTest(1:numTrain);
    indxTest = indxTest(numTrain+1:end);
    
    dataTrain(end+1:end+numTrain,:) = [histHof(indxTrain,:),histHog(indxTrain,:),histMbhx(indxTrain,:),histMbhy(indxTrain,:)]/4;
    dataTest(end+1:end+numData-numTrain,:) = [histHof(indxTest,:),histHog(indxTest,:),histMbhx(indxTest,:),histMbhy(indxTest,:)]/4;
    
    dataAll{i} = [histHof,histHog,histMbhx,histMbhy]/4;   

    % normalization?
%     dataTrain = normalize_data(power_normalization(dataTrain,0.5));
%     dataTest = normalize_data(power_normalization(dataTest,0.5));
%     dataAll{i} = normalize_data(power_normalization(dataAll{i},0.5));
 
    acm(i+1) = acm(i)+size(histHof,1);

end

%% generate embedding map on training data

% distance matrix
fprintf('calculating distance...\n');
switch parameters.distType
    case 'chi'
        DTrain = chiSquare(dataTrain,dataTrain);
    case 'euc'
        DTrain = pdist2(dataTrain,dataTrain);
    case 'int'
        DTrain = 1-intersection(dataTrain,dataTrain);
    otherwise
        error('invalid distance type');
end

% run t-sne
fprintf('embedding training data...\n');
[emDataTrain,betas,P,errors] = tsne_d(DTrain,parameters);

%% generate embedding map on each individual
emDataAll = cell(numFiles,1);
for i = 1:numFiles
    fprintf('processing sample %u...\n',i);
    [emDataAll{i},~] = findEmbedding(dataAll{i},dataTrain,emDataTrain,parameters);
end

%% generate embedding map on other samples
% on test sample
fprintf('embedding test data...\n');
[emDataTest,~] = findEmbedding(dataTest,dataTrain,emDataTrain,parameters);

% on new sample
emDataNew = cell(length(testIndx),1);
for i = 1:length(testIndx)
    
    movieParam = paramAll_galois(testIndx(i));
    fprintf('embedding new data %s...\n',movieParam.fileName);
    
    load([filepath movieParam.fileName '_' infostr '_histHof.mat']);
    load([filepath movieParam.fileName '_' infostr '_histHog.mat']);
    load([filepath movieParam.fileName '_' infostr '_histMbhx.mat']);
    load([filepath movieParam.fileName '_' infostr '_histMbhy.mat']);
    dataNew = [histHof,histHog,histMbhx,histMbhy]/4;
%     dataNew = power_normalization(dataNew,0.5);
    
    [emDataNew{i},~] = findEmbedding(dataNew,dataTrain,emDataTrain,parameters);
    
end

save(['/home/sh3276/work/results/embedding/' infostr '_' datestr '_tsneAll.mat'],'-v7.3');
save(['/home/sh3276/work/results/embedding/' infostr '_' datestr '_tsneTrain.mat'],'emDataTrain','dataTrain','-v7.3');

% close parallel pool
delete(gcp)
