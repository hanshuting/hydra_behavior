
% This script trains a HMM model given the observation histograms and
% labels

setSeed(0);

%% load annotations
fileInd = [1,2,3,4,5,7,8,9,10,11,13];
movieParamMulti = paramMulti(fileInd);

numSample = length(fileInd);
time_step = 5;
annoRaw = annoMulti(movieParamMulti,time_step,0);
annoAll = mergeAnno(annoRaw,1);

%% read in samples
filepath = 'C:\Shuting\Data\yeti\results_11\';
dataAll = [];
acm = zeros(numSample+1,1);
for i = 1:numSample
    %load([filepath movieParamMulti{i}.filenameBasis 'results_histFlow.mat']);
    load([filepath movieParamMulti{i}.fileName '_results_histHof_step_5.mat']);
    load([filepath movieParamMulti{i}.fileName '_results_histHog_step_5.mat']);
    load([filepath movieParamMulti{i}.fileName '_results_histMbh_step_5.mat']);
    acm(i+1) = acm(i)+floor(movieParamMulti{i}.numImages/time_step);
    dataAll(end+1:end+size(histHofCenters,1),:) = ...
        [histHofCenters,histHogCenters,histMbhCenters]/3;
end
clear histHofCenters histHogCenters histMbhCenters

% do pca on data and normalization, each column is a sample
ci = 95;
drData = drHist(dataAll,ci);
drData = standardize(drData');
dataAll = dataAll';
%clear dataAll

%% get training and test data and labels
dataTrain = cell(numSample,1);
labelTrain = cell(numSample,1);
dataTest = cell(numSample,1);
labelTest = cell(numSample,1);

% process data from each animal separately
for i = 1:numSample
    crLabel = annoAll(acm(i)+1:acm(i+1))';
    crData = drData(:,acm(i)+1:acm(i+1));
    % exclude time window with label 0
    keepInd = crLabel~=0;
    crLabel = crLabel(:,keepInd);
    crData = crData(:,keepInd);
    % take the last 10% data as test samples
    numTrain = round(0.9*(acm(i+1)-acm(i)));
    labelTrain{i} = crLabel(1:numTrain);
    dataTrain{i} = crData(:,1:numTrain);
    labelTest{i} = crLabel(numTrain+1:end);
    dataTest{i} = crData(:,numTrain+1:end);
end

%% train hmm model
model = hmmFitFullyObs(labelTrain,dataTrain,'gauss');

figure;set(gcf,'color','w');
subplot(1,2,1);imagesc(model.A);title('transition matrix');colorbar;
subplot(1,2,2);imagesc(model.emission.mu);title('emission matrix');colorbar;

%% test model performance
acrTest = zeros(numSample,1);
predictedPath = cell(numSample,1);
for i = 1:numSample
    predictedPath{i} = hmmMap(model,dataTest{i});
    acrTest(i) = sum(predictedPath{i}==labelTest{i})/length(labelTest{i});
end
fprintf('mean accuracy: %6.2f%% \n',mean(acrTest)*100);
