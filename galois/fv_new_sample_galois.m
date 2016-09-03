
% set parameters
rng(1000)
fileind = [33,34];
time_step = 25;
annoType = 3;
L = 15;
W = 2;
N = 32;
s = 1;
t = 3;
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(time_step)];
%filepath = ['/home/sh3276/work/results/dt_analysis/min_var0.5/' infostr '_20151210/'];
%filename = [infostr '_drHist'];
filepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/FV_' infostr '_20151210/'];
filename = [infostr '_drFVall'];
annoPath = '/home/sh3276/work/data/annotations/';

% load data
load([filepath filename '.mat']);

% load annotations
annoRaw = annoMulti(movieParamMulti,annoPath,time_step,0);
annoAll = mergeAnno(annoRaw,annoType);

% exclude 0 class
keepind = annoAll~=0;
numCubes = sum(keepind);
sample = drFVall(keepind,:);
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
gnLibsvmFile(label,sample,[filepath filename '_annoType' num2str(annoType) '_all.txt']);
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
