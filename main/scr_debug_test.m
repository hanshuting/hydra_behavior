
fileind = [1,4];
filepath = 'C:\Shuting\Data\yeti\features\spd\';
m = 3;
n = 2;
time_step = 5;
movieParamMulti = paramMulti(fileind);

%% load samples
hof_all = {};
hog_all = {};
mbh_all = {};
for i = 1:length(fileind)
    
    movieParam = movieParamMulti{i};
    load([filepath movieParam.fileName '_results_hof_m_' num2str(m) '_n_' ...
        num2str(n) '_step_' num2str(time_step) '.mat']);
    load([filepath movieParam.fileName '_results_hog_m_' num2str(m) '_n_' ...
        num2str(n) '_step_' num2str(time_step) '.mat']);
    load([filepath movieParam.fileName '_results_mbh_m_' num2str(m) '_n_' ...
        num2str(n) '_step_' num2str(time_step) '.mat']);
    
    numSample = length(msHofAll);
    hof_all(end+1:end+numSample,:) = msHofAll;
    hog_all(end+1:end+numSample,:) = msHogAll;
    mbh_all(end+1:end+numSample,:) = msMbhAll;
    
end

%% load annotations
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
annoRaw = annoMulti(movieParamMulti,annoPath,time_step,0);
annoAll = mergeAnno(annoRaw,1);

%% keep two action classes
keepind = annoAll==1|annoAll==6;
hof_all_subsample = hof_all(keepind,:);
hog_all_subsample = hog_all(keepind,:);
mbh_all_subsample = mbh_all(keepind,:);

%% generate codebook
setSeed(1000);
numCenters = 100;
hofCenters = gnCdbk(hof_all_subsample,numCenters);
hogCenters = gnCdbk(hog_all_subsample,numCenters);
mbhCenters = gnCdbk(mbh_all_subsample,numCenters);

hofCenters = hofCenters(sum(isnan(hofCenters),2)==0,:);
hogCenters = hogCenters(sum(isnan(hogCenters),2)==0,:);
mbhCenters = mbhCenters(sum(isnan(mbhCenters),2)==0,:);

%% assign histograms
histHof = assignMaskedCenters(hof_all_subsample,hofCenters,'euc');
histHog = assignMaskedCenters(hog_all_subsample,hogCenters,'euc');
histMbh = assignMaskedCenters(mbh_all_subsample,mbhCenters,'euc');

histAll = [histHof,histHog,histMbh]/3;
drHistAll = drHist(histAll,95);
%% svm
setSeed(0);
numCubes = size(histAll,1);
sample = histAll;
label = annoAll(keepind);
labelset = unique(label);
numClass = length(labelset);

% generate random sample set
indx = randperm(numCubes);
numTraining = round(0.9*numCubes);
numTest = numCubes-numTraining;
indxTraining = indx(1:numTraining)';
indxTest = indx(numTraining+1:end)';
figure;set(gcf,'color','w');
subplot(1,2,1);hist(label(indxTraining),[min(label):max(label)]+0.5);
title('training sample distribution');
xlabel('class');ylabel('number of samples');
subplot(1,2,2);hist(label(indxTest),[min(label):max(label)]+0.5);
title('testing sample distribution');
xlabel('class');ylabel('number of samples');

labelTraining = label(indxTraining);
labelTest = label(indxTest);

% one-vs-one svm model
%svm_param_grid(labelTraining,sample(indxTraining,:),'one-vs-one');
tic;
svmParam11 = '-t 2 -b 1 -q -c 1000 -g 1000';
w = zeros(numClass,1);
for i = 1:numClass
    w(i) = 1/sum(labelTraining==labelset(i));
    svmParam11 = [svmParam11 ' -w' num2str(labelset(i)) ' ' num2str(w(i))];
end
model11 = svmtrain(labelTraining,sample(indxTraining,:),svmParam11);
[predictedTraining,acrTrainingAll,scoresTraining] = svmpredict(labelTraining,...
    sample(indxTraining,:),model11,'-b 1');
[predictedTest,acrTestAll,scoresTest] = svmpredict(labelTest,...
    sample(indxTest,:),model11,'-b 1');
fprintf('Training accuracy: %6.2f%% \nTest accuracy: %6.2f%% \n',...
    acrTrainingAll(1),acrTestAll(1));
toc;