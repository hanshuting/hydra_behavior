
% set parameters
rng(1000)
%fileind = [1:5,7:11,13:28,30:32];
fileind = [1:5,7:11,13:24,26:28,30:32];
%fileind = 301:322;
time_step = 25;
annoType = 5;
L = 15;
W = 2;
N = 32;
s = 2;
t = 3;
datestr = '20160112_registered';
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(time_step)];
filepath = ['/home/sh3276/work/results/dt_analysis/min_var0.5/' infostr '_' datestr '/'];
filename = [infostr '_drHist'];
annoPath = '/home/sh3276/work/data/annotations/';

% load data
load([filepath filename '.mat']);

% dimensionality reduction
%histAll = [histHofAll,histHogAll,histMbhxAll,histMbhyAll]/4;
%drHistAll = drHist(histAll,70);

% distance matrix
%distHistAll = pdist2(drHistAll,drHistAll);
%save(['/home/sh3276/work/results/bow_hydra/' filename '_drHist.mat'],'drHistAll','distHistAll','-v7.3');

% substitute all NaN with 0
drHistAll(isnan(drHistAll)) = 0;

% modify number of images in parameter struct
movieParamMulti = paramMulti_galois(fileind);
for i = 1:length(fileind)
    movieParamMulti{i}.numImages = (acm(i+1)-acm(i))*time_step;
end

% load annotations
annoRaw = annoMulti(movieParamMulti,annoPath,time_step,0);
annoAll = mergeAnno(annoRaw,annoType);

% exclude 0 class
keepind = annoAll~=0;
numCubes = sum(keepind);
sample = drHistAll(keepind,:);
label = annoAll(keepind);
labelset = unique(label);

% generate training and testing samples
numClass = length(labelset);
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
% figure;hist(label(indxTest),1:8)

% save to files
%gnLibsvmFile(label,sample,[filepath filename '_annoType' num2str(annoType) '_all.txt']);
gnLibsvmFile(label(indxTraining),sample(indxTraining,:),[filepath filename '_annoType' num2str(annoType) '_training.txt']);
gnLibsvmFile(label(indxTest),sample(indxTest,:),[filepath filename '_annoType' num2str(annoType) '_test.txt']);
save([filepath filename '_annoType' num2str(annoType) '_svm_data.mat'],'label','sample','indxTraining','indxTest');

svmParam = [];
w = zeros(numClass,1);
for i = 1:numClass
    w(i) = numTraining/sum(label(indxTraining)==labelset(i));
    svmParam = [svmParam ' -w' num2str(labelset(i)) ' ' num2str(w(i))];
end
fprintf('%s\n',svmParam);
