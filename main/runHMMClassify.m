% This script trains GMM HMM classifiers given true labels and histogram
% representations

%% initialize
setSeed(0);

%% load annotations
fileInd = [1:11,13];
movieParamMulti = paramMulti(fileInd);

time_step = 25;
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
annoRaw = annoMulti(movieParamMulti,annoPath,time_step,0);
annoAll = mergeAnno(annoRaw,1);

%% read in samples
filepath = 'C:\Shuting\Data\yeti\hists\hists_m_3_n_2_step_25_20151105\';
dataAll = [];
acm = zeros(length(fileInd)+1,1);
for i = 1:length(fileInd)
    load([filepath movieParamMulti{i}.fileName '_results_histHof_m_3_n_2_step_25.mat']);
    load([filepath movieParamMulti{i}.fileName '_results_histHog_m_3_n_2_step_25.mat']);
    load([filepath movieParamMulti{i}.fileName '_results_histMbhy_m_3_n_2_step_25.mat']);
    load([filepath movieParamMulti{i}.fileName '_results_histMbhx_m_3_n_2_step_25.mat']);
    acm(i+1) = acm(i)+floor(movieParamMulti{i}.numImages/time_step);
    dataAll(end+1:end+size(histHof,1),:) = ...
        [histHof,histHog,histMbhx,histMbhy]/4;
end
clear histHofCenters histHogCenters histMbhCenters

% do pca on data and normalization, each column is a sample
ci = 95;
drData = drHist(dataAll,ci);
drData = standardize(drData');
%clear dataAll

%% alternatively, use sample and label from svm
load('C:\Shuting\Data\yeti\hists\hists_m_3_n_2_step_25_20151105\all_hists_20151105.mat');

drData = standardize(drHistAll');

%% generate training and test samples and labels
size_window = 5;
dataTrain = {};
labelTrain = [];

% process data from each animal separately
for i = 1:length(fileInd)
    crNum = floor((acm(i+1)-acm(i))/size_window);
    crLabel = reshape(annoAll(acm(i)+1:acm(i)+crNum*size_window),size_window,[])';
    crData = mat2cell(drData(:,acm(i)+1:acm(i)+crNum*size_window),...
        size(drData,1),ones(crNum,1)*size_window);
    crData = crData';
    % exclude time window with label 0
    keepInd = ~any(crLabel'==0)';
    crLabel = crLabel(keepInd,:);
    % define behavior by the mode of labels
    crLabel = mode(crLabel,2);
    labelTrain(end+1:end+sum(keepInd)) = crLabel;
    dataTrain(end+1:end+sum(keepInd)) = crData(keepInd);
end

% randomly take out test samples
nlabelset = length(unique(labelTrain));
numSamples = length(dataTrain);
numTrain = round(0.9*numSamples);
indx = randperm(numSamples);
indxTrain = indx(1:numTrain);
indxTest = indx(numTrain+1:end);

% transpose for hmm
dataTrain = dataTrain';
labelTrain = labelTrain';

dataTest = dataTrain(indxTest);
labelTest = labelTrain(indxTest);
dataTrain = dataTrain(indxTrain);
labelTrain = labelTrain(indxTrain);

%% GMM HMM
% model parameters
nstates = 3;
setSeed(0);

% initial guess of parameters
% pi0 = zeros(nstates,1);
% pi0(1) = 1;
% transmat0 = normalize(diag(ones(nstates,1))+diag(ones(nstates-1,1),1),2);

% random initialization
pi0 = normalise(rand(nstates,1));
transmat0 = mkStochastic(rand(nstates,nstates));

% fit model
fitArgs = {'pi0',pi0,'trans0',transmat0,'maxIter',3,'verbose',true};
fitFn   = @(X)hmmFit(X,nstates,'gauss',fitArgs{:});
model = generativeClassifierFit(fitFn,dataTrain,labelTrain);

% predict
logprobFn = @hmmLogprob;
[labelPredictedTest,post] = generativeClassifierPredict(logprobFn,...
    model,dataTest);
acrTest = sum(labelPredictedTest~=labelTest)/length(labelTest);
fprintf('Test accuracy: %6.2f%% \n',acrTest*100);



