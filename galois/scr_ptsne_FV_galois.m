% script for generating embedding map and for embed new samples
addpath(genpath('/home/sh3276/software/MotionMapper/'));
addpath(genpath('/home/sh3276/work/code/bow_hydra/'));

%% initialize parameters
perplexity = 30;
layers = [500 500 2000 2];

% data parameters
%fileIndx = [1:5,7:11,13:24,26:28,30:32,35:56];
%testIndx = [25,33,34];
fileIndx = [1:5,7:11,13:28,30:32,35:54,56];
testIndx = [33,34,55];
infostr = 'L_15_W_2_N_32_s_1_t_1_step_25';
K = 256;
dopca = 1;
annoType = 5;
timeStep = 25;
ci = 90;
datestr = '20160315_spseg3';
filepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr '_K_'...
    num2str(K) '_' datestr '/'];
annoPath = '/home/sh3276/work/data/annotations/';

%% load data
% percTrain = 0.9;
% dataTrain = [];
% dataTest = [];
% numFiles = length(fileIndx);
% dataAll = cell(numFiles,1);
% acm = zeros(numFiles+1,1);
% for i = 1:numFiles
% 
%     movieParam = paramAll_galois(fileIndx(i));
%     fprintf('loading sample %s...\n',movieParam.fileName);
%     
%     load([filepath movieParam.fileName '_' infostr '_trajFV.mat']);
%     load([filepath movieParam.fileName '_' infostr '_hofFV.mat']);
%     load([filepath movieParam.fileName '_' infostr '_mbhxFV.mat']);
%     load([filepath movieParam.fileName '_' infostr '_mbhyFV.mat']);
%     data = [trajFV,hofFV,mbhxFV,mbhyFV]/4;
%     
%     numData = size(hofFV,1);
%     numTrain = round(percTrain*numData);
%     indxTest = randperm(numData);
%     indxTrain = indxTest(1:numTrain);
%     indxTest = indxTest(numTrain+1:end);
%     
%     dataTrain(end+1:end+numTrain,:) = data(indxTrain,:);
%     dataTest(end+1:end+numData-numTrain,:) = data(indxTest,:);
%     
%     dataAll{i} = power_normalization([histHof,histHog,histMbhx,histMbhy]/4,0.5);
%     
%     acm(i+1) = acm(i)+size(histHof,1);
%     
% end

fprintf('loading data...\n');
load([filepath infostr '_hofFV.mat']);
load([filepath infostr '_hogFV.mat']);
load([filepath infostr '_mbhxFV.mat']);
load([filepath infostr '_mbhyFV.mat']);
load([filepath infostr '_drFVall.mat']);
data = [hofFV,hogFV,mbhxFV,mbhyFV]/4;
%data = hofFV;

% if dopca
%     load([filepath infostr '_pcaCoeff.mat']);
%     muData = mean(data,1);
%     data = bsxfun(@minus,data,muData)*coeff;
%     data = data(:,1:pcaDim);
% end
% 
% numData = size(data,1);
% numTrain = round(percTrain*numData);
% indxTest = randperm(numData);
% indxTrain = indxTest(1:numTrain);
% indxTest = indxTest(numTrain+1:end);
% 
% dataTrain = data(indxTrain,:);
% dataTest = data(indxTest,:);

%% subsample for embedding
% load data and subsample
percTrain = 0.8;
dataTrain = [];
dataTest = [];
numFiles = length(fileIndx);
dataAll = cell(numFiles,1);

% pca?
if dopca
    fprintf('pca...\n');
    load([filepath infostr '_pcaCoeff.mat']);
    muData = mean(data,1);
    data = bsxfun(@minus,data,muData)*coeff;
    data = data(:,1:pcaDim);
end

% take out training and testing dataset
numData = size(data,1);
numTrain = round(percTrain*numData);
indxTest = randperm(numData);
indxTrain = indxTest(1:numTrain);
indxTest = indxTest(numTrain+1:end);
    
dataTrain(end+1:end+numTrain,:) = data(indxTrain,:);
dataTest(end+1:end+numData-numTrain,:) = data(indxTest,:);

for i = 1:length(acm)-1
    dataAll{i} = data(acm(i)+1:acm(i+1),:);
end

movieParamAll = paramMulti_galois(fileIndx);
label = annoMulti(movieParamAll,annoPath,annoType,timeStep);
labelTrain = label(indxTrain);
labelTest = label(indxTest);

%% embedding
% train network
fprintf('training network...\n');
[network,err] = train_par_tsne(dataTrain,labelTrain,dataTest,labelTest,layers,'CD1');

% embed training data
fprintf('embedding training data...\n');
emDataTrain = run_data_through_network(network,dataTrain);

% embed test data
fprintf('embedding test data...\n');
emDataTest = run_data_through_network(network,dataTest);

% embed individual data
emDataAll = cell(numFiles,1);
for i = 1:numFiles
    fprintf('processing file %u...\n',i);
    emDataAll{i} = run_data_through_network(network,dataAll{i});
end

% embed new sample
emDataNew = cell(length(testIndx),1);
for i = 1:length(testIndx)
    
    movieParam = paramAll_galois(testIndx(i));
    fprintf('embedding new data %s...\n',movieParam.fileName);
    
    load([filepath movieParam.fileName '_' infostr '_FVall.mat']);
    dataNew = FVall;
    clear FVall
 
    % do pca
    if dopca
        muData = mean(dataNew,1);
        dataNew = bsxfun(@minus,dataNew,muData)*coeff;
        dataNew = dataNew(:,1:pcaDim);
    end

    emDataNew{i} = run_data_through_network(network,dataNew);
    
end


save(['/home/sh3276/work/results/embedding/' infostr '_K_' num2str(K) '_' datestr '_ptsne.mat'],'-v7.3');

