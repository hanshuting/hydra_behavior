

%% initialization and global parameters
%rng(1000);
setSeed(0);

time_step = 5;
numCenters = 1000;
ci = 95; % percentage of variance to keep in PCA

%% load samples

flow_all = {};
hof_all = {};
hog_all = {};

fileInd = [1,2,3,4,5,7,8,9,10,11,13];
movieParamMulti = paramMulti(fileInd);

for i = fileInd
    
    movieParam = movieParamMulti{i};
    load(['C:\Shuting\Data\yeti\results_11\' movieParam.filenameBasis...
        'results_time_step_5.mat']);
    numSample = length(flows);
    flow_all(end+1:end+numSample) = flows;
    hof_all(end+1:end+numSample) = msHofAll;
    hog_all(end+1:end+numSample) = msHogAll;
    
    display(fileInd);
    
end

clear bw bw_reg centroid flowCenters histFlow histHofCenters ...
    histHogCenters hofCenters hogCenters uu_reg vv_reg

%% or calculate samples

[bw,bg] = gnMask(movieParam,0);
[uu_reg,vv_reg,bw_reg,thetas,centroids,as] = registerAll(movieParam,...
    uu,vv,bw,bg,time_step);

% spatial patche indexing
[spInd,spCoord] = gnMaskSpatialIndx(m,n,as,bw_reg,time_step)

%% codebook generation and data representation
flowCenters = gnCdbk(flow_all,numCenters);
histFlow = assignMaskedCenters(flow_all,flowCenters,'exp');

hofCenters = gnCdbk(hof_all,numCenters);
histHofCenters = assignMaskedCenters(hof_all,hofCenters,'exp');

hogCenters = gnCdbk(hog_all,numCenters);
histHogCenters = assignMaskedCenters(hog_all,hogCenters,'exp');

mbhCenters = gnCdbk(mbh_all,numCenters);
histMbhCenters = assignMaskedCenters(mbh_all,mbhCenters,'exp');

%% or read in results

filepath = 'C:\Shuting\Data\yeti\results_11\';
histAll = [];
acm = zeros(length(fileInd)+1,1);

for i = 1:length(fileInd)
    %load([filepath movieParamMulti{i}.filenameBasis 'results_histFlow.mat']);
    load([filepath movieParamMulti{i}.filenameBasis 'results_histHof.mat']);
    load([filepath movieParamMulti{i}.filenameBasis 'results_histHog.mat']);
    load([filepath movieParamMulti{i}.filenameBasis 'results_histMbh.mat']);
    acm(i+1) = acm(i)+size(histHofCenters,1);
    histAll(end+1:end+size(histHofCenters,1),:) = ...
        [histHofCenters,histHogCenters,histMbhCenters]/3;
end
clear histHofCenters histHogCenters histMbhCenters


%% clustering methods

numCluster = 100;

%%%% distance matrix, similarity matrix %%%%
chi_square = @(P,Q) nansum((ones(size(Q,1),1)*P-Q).^2./...
    (2*(ones(size(Q,1),1)*P+Q)),2);

histAll = [sqrtHist(histFlowAll,3),histHofAll,histHogAll,histMbhAll]/4;
distHistAll = pdist2(histAll,histAll,@(P,Q) chi_square(P,Q));
simHistAll = 1-distHistAll/max(distHistAll(:));

%%%% plain k means %%%%
drHistAll = drHist(histAll,ci);
[indAll,ccenters] = kmeans(drHistAll,numCluster,'replicate',3,...
'emptyaction','drop');
% define "other" class
centdist = pdist2(ccenters,drHistAll);
thresh = prctile(min(centdist),95);
%[~,indAll] = min(centdist);
indAll(min(centdist)>thresh) = 0;
% visualization
plotComponent(drHistAll,indAll);
hold on; plot3(drHistAll(:,1),drHistAll(:,2),drHistAll(:,3),'linestyle',...
    ':','color','k');

%%%% AP clustering %%%%
indAll = apcluster(simHistAll,median(simHistAll));
%indAll = apcluster(simHistAll,min(simHistAll(:))-10*(max(simHistAll(:))-min(simHistAll(:))));
%indAll = apclusterK(simHistAll,numCluster);
% do another AP on the examplers
indnum = unique(indAll);
indAll2 = apcluster(simHistAll(indnum,indnum),median(simHistAll...
    (indnum,indnum)));
indnum2 = unique(indAll2);
exampler = indnum(indnum2);
% hierarchical labelset
indAll_hir = zeros(length(indAll),2);
for i = 1:length(indAll)
    indAll_hir(i,1) = find(indnum==indAll(i));
    indAll_hir(i,2) = find(indnum2==indAll2(indAll_hir(i,1)));
end
% define "other" class
expdist = pdist2(histAll(exampler,:),histAll,@(P,Q) chi_square(P,Q));
thresh = prctile(min(expdist),95);
indAll_hir(min(expdist)>thresh,2) = 0;
% visualize the clusters
tmp = unique(indAll_hir(indAll_hir(:,2)==1,1));
visualizeResultMulti(find(indAll_hir(:,1)==tmp(1)&indAll_hir(:,2)==1),...
    time_step,movieParamMulti,0);

%%%% use AP to initialize the k medoids %%%%
%indAll = kmeans(drHistAll,numCluster,'start',drHistAll(unique(indAll),:),'replicate',3,'emptyaction','drop');

%%%% MDS %%%%
[mdsHist,emdsHist] = cmdscale(distHistAll);
% clustering on MDS data
cum = 0;
for i = 1:size(mdsHist,2)
   cum = cum+emdsHist(i);
   if cum/sum(emdsHist(1:size(mdsHist,2)))>ci/100
       thresh = i;
       break;
   end
end
indAll = kmeans(mdsHist(:,1:thresh),numCluster,'replicate',3);
% visualization
plotComponent(mdsHist,indAll);
hold on;plot3(mdsHist(:,1),mdsHist(:,2),mdsHist(:,3),'linestyle',':','color','k');

%%%% k-means+LDA %%%%
[indAll,histTrans] = rclda(drHistAll,numCluster,ci);
plotComponent(histTrans,indAll);
hold on;plot3(histTrans(:,1),histTrans(:,2),histTrans(:,3),'linestyle',':','color','k');
    
%%%% factor analysis %%%%
% get full rank matrix from the data matrix
tol = 1e-4;
[Q,R,E] = qr(histAll);
diagr = abs(diag(R));
rk = find(diagr >= tol*diagr(1), 1, 'last');
histAllFR = histAll*E(:,1:rk); % full rank matrix
% covariance matrix
histCov = cov(histAllFR');
histCov = histCov+diag(1e-5*ones(1,size(histCov,1))); % avoid ill-conditioned covariance matrix
histFactors = factoran(histCov,3,'xtype','covariance');
% k means on factors
indAll = kmeans(histFactors,numCluster,'replicate',3);
% visualization
plotComponent(histFactors,indAll);
hold on;plot3(histFactors(:,1),histFactors(:,2),histFactors(:,3),'linestyle',':','color','k');

% t-SNE
emHist = tsne(histAll,[]);
% visualization
figure;gscatter(emHist(:,1),emHist(:,2),indAll)

%% generate sample for SVM

setSeed(0);

% exclude "other" class in training
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
annoRaw = annoMulti(movieParamMulti,annoPath,time_step,0);
annoAll = mergeAnno(annoRaw,1);

% exclude 0 class
keepind = annoAll~=0;
numCubes = sum(keepind);
sample = drHistAll(keepind,:);
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

%% one-vs-rest svm training
svm_param_grid(labelTraining,sample(indxTraining,:),'one-vs-rest');
svmParam1r = '-t 2 -b 1 -q -c 10 -g 10';
model1r = ovrtrain(labelTraining,sample(indxTraining,:),svmParam1r);
[predictedTraining,acrTrainingAll,scoresTraining] = ovrpredict(labelTraining,...
    sample(indxTraining,:),model1r,'-b 1');
[predictedTest,acrTestAll,scoresTest] = ovrpredict(labelTest,...
    sample(indxTest,:),model1r,'-b 1');
fprintf('Training accuracy: %6.2f%% \nTest accuracy: %6.2f%%\n',...
    acrTrainingAll*100,acrTestAll*100);

%% one-vs-one svm training
%svm_param_grid(labelTraining,sample(indxTraining,:),'one-vs-one');
tic;
svmParam11 = '-t 2 -b 1 -q -c 100 -g 10000';
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
%% accurarcy per class
acrTraining = zeros(numClass,1);
acrTest = zeros(numClass,1);
for i = 1:numClass
    acrTraining(i) = (sum(predictedTraining==labelset(i)&...
        labelTraining==labelset(i))...
        +sum(predictedTraining~=labelset(i)&labelTraining~=labelset(i)))/...
        numTraining;
    acrTest(i) = (sum(predictedTest==labelset(i)&labelTest==labelset(i))...
        +sum(predictedTest~=labelset(i)&labelTest~=labelset(i)))/numTest;
end

%% confusion matrix
[precisionTraining,recallTraining,cmatTraining] = precisionrecall(predictedTraining,labelTraining);
prtable = table(precisionTraining,recallTraining,'rownames',num2cell(num2str(labelset)));
display(prtable);
[precisionTest,recallTest,cmatTest] = precisionrecall(predictedTest,labelTest);
prtable = table(precisionTest,recallTest,'rownames',num2cell(num2str(labelset)));
display(prtable);
figure;
subplot(1,2,1);imagesc(cmatTraining);set(gcf,'color','w');title('Training');colorbar;
subplot(1,2,2);imagesc(cmatTest);set(gcf,'color','w');title('Test');colorbar;
colormap hot

%% ROC curve - bugs
faRate = zeros(length(labelTest),numClass);
hitRate = zeros(length(labelTest),numClass);
AUC = zeros(numClass,1);
for i = 1:numClass
    [faRate(:,i),hitRate(:,i),~,AUC(i)] = perfcurve(labelTest,scoresTest(:,i),i);
end
% plot ROC curve
cc = hsv(numClass);
figure;
set(gcf,'color','w');
hold on;
for i = 1:numClass
    plot(faRate(:,i), hitRate(:,i), '-','color',cc(i,:));
end
e = 0.05; axis([0-e 1+e 0-e 1+e])
xlabel('false alarm rate')
ylabel('hit rate')
grid on
legend('1','2','3','4','5','6','7');