% script for generating embedding map and for embed new samples
addpath(genpath('/home/sh3276/software/MotionMapper/'));
addpath(genpath('/home/sh3276/work/code/bow_hydra/'));

%% initialize parameters
parameters.distType = 'euc';
parameters.closeMatPool = true;
parameters.perplexity = 16;
parameters.training_perplexity = 16;
parameters = setRunParameters(parameters);

% data parameters
%fileIndx = [1:5,7:11,13:24,26:28,30:32,35:56];
%testIndx = [25,33,34];
fileIndx = [1:5,7:11,13:28,30:32,35:54,56];
testIndx = [33,34,55];
infostr = 'L_15_W_2_N_32_s_1_t_1_step_25';
K = 256;
dopca = 1;
ci = 90;
datestr = '20160315_spseg3';
filepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr '_K_'...
    num2str(K) '_' datestr '/'];

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
    load([filepath infostr '_pcaCoeff.mat']);
    muData = mean(data,1);
    data = bsxfun(@minus,data,muData)*coeff;
    data = data(:,1:pcaDim);
end

% normalize data
%data = data-min(data,[],2)*ones(1,size(data,2));
%data = data./(sum(data,2)*ones(1,size(data,2)));

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
    case 'cos'
        DTrain = pdist2(dataTrain,dataTrain,'cosine');
    case 'corr'
        DTrain = pdist2(dataTrain,dataTrain,'correlation');
    otherwise
        error('invalid distance type');
end

% run t-sne
fprintf('embedding training data...\n');
[emDataTrain,betas,P,errors] = tsne_d_sparse(DTrain,parameters);

%% generate embedding map on each individual
fprintf('embedding all data...\n');
emDataAll = cell(numFiles,1);
for i = 1:numFiles
    fprintf('processing file %u...\n',i);
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
    
    load([filepath movieParam.fileName '_' infostr '_FVall.mat']);
    dataNew = FVall;
    clear FVall
 
    % do pca
    if dopca
        muData = mean(dataNew,1);
        dataNew = bsxfun(@minus,dataNew,muData)*coeff;
        dataNew = dataNew(:,1:pcaDim);
    end
    
    % normalize data
    %dataNew = dataNew-min(dataNew,[],2)*ones(1,size(dataNew,2));
    %dataNew = dataNew./(sum(dataNew,2)*ones(1,size(dataNew,2)));
    
    [emDataNew{i},~] = findEmbedding(dataNew,dataTrain,emDataTrain,parameters);
    
end


save(['/home/sh3276/work/results/embedding/' infostr '_K_' num2str(K) '_' datestr '_tsneAll.mat'],'-v7.3');
save(['/home/sh3276/work/results/embedding/' infostr '_K_' num2str(K) '_' datestr '_tsneTrain.mat'],'emDataTrain','dataTrain','-v7.3');

