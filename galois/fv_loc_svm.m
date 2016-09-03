
% set parameters
rng(1000)
fileind = [1:5,7:11,13:24,26:28,30:32,35:56];
%fileind = [1:5,7:11,13:28,30:32,35:54,56];
annoType = 5;
L = 15;
W = 2;
N = 32;
s = 1;
t = 1;
K = 256;
ci = 90;
datastr = '20160404_spseg3';
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t)];
filepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr '_K_' num2str(K) '_' datastr '/'];
filename = [infostr '_drFVall']; % change here
annoPath = '/home/sh3276/work/data/annotations/';
segPath = '/home/sh3276/work/results/register_param/seg_20160331/';

% load data
load([filepath filename '.mat']);
sample = drFVall; % change here
% -- use partial FVs -- %
%load([filepath infostr '_hofFV.mat']);
%load([filepath infostr '_mbhxFV.mat']);
%load([filepath infostr '_mbhyFV.mat']);
%sample = [hofFV,mbhxFV,mbhyFV]/3;
%[sample,coeff] = drHist(sample,ci);
%pcaDim = size(sample,2);
%save([filepath infostr '_pcaCoeff.mat'],'coeff','pcaDim','-v7.3');

% load annotations
annoAll = [];
for i = 1:length(fileind)
    annoSingle = annoSeg(movieParam,annoPath,annoType,segPath);
    annoAll(end+1:end+length(annoSingle)) = annoSingle;
end

% exclude 0 class
keepind = annoAll~=0;
numCubes = sum(keepind);
sample = sample(keepind,:);
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
