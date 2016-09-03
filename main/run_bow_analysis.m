% new version of all scripts for light field videos

%% model parameters
% set random generator
rng(1000);

% set parameters
fileIndx = 1;
m = 3; % number of spatial patches in x
n = 2; % number of spatial patches in y
timeStep = 5;
cubeStep = 5;
numBins = 8;
ci = 95; % percentage of variance to keep in PCA

% chi-square kernel of computing histogram distances
chi_square = @(P,Q) nansum((ones(size(Q,1),1)*P-Q).^2./(2*(ones(size(Q,1),1)*P+Q)),2);

% read movie info
movieParam = paramAll(fileIndx);

%% calculate features
% segmentation and registration
[bw,bg] = gnMask(movieParam,0);
[uuReg,vvReg,bwReg,hydraOri,hydraCent,hydraLength] = registerAll(movieParam,...
    uu,vv,bw,bg,timeStep);

% descriptors
[msHofAll,hofCoord] = temporalMaskedHof(uuReg,vvReg,cubeStep,timeStep,numBins,bwReg);
[msHogAll,hogCoord] = temporalMaskedHog(movieParam,hydraOri,hydraCent,cubeStep,timeStep,numBins,bwReg);
[msMbhxAll,msMbhyAll,mbhxCoord,mbhyCoord] = temporalMaskedMbh(uuReg,vvReg,cubeStep,timeStep,numBins,bwReg);

% spatiotemporal descriptors
[msHofAll,hofCoord] = gnSptpDescriptor(msHofAll,hofCoord,m,n,hydraLength,movieParam);
[msHogAll,hogCoord] = gnSptpDescriptor(msHogAll,hogCoord,m,n,hydraLength,movieParam);
[msMbhxAll,mbhxCoord] = gnSptpDescriptor(msMbhxAll,mbhxCoord,m,n,hydraLength,movieParam);
[msMbhyAll,mbhyCoord] = gnSptpDescriptor(msMbhyAll,mbhyCoord,m,n,hydraLength,movieParam);

%% generate codebooks
numCenters = 1000;

hofCenters = gnCdbk(msHofAll,numCenters);
hogCenters = gnCdbk(msHogAll,numCenters);
mbhxCenters = gnCdbk(msMbhxAll,numCenters);
mbhyCenters = gnCdbk(msMbhyAll,numCenters);

%% histogram representations
histHofAll = assignMaskedCenters(msHofAll,hofCenters,'exp');
histHogAll = assignMaskedCenters(msHogAll,hogCenters,'exp');
histMbhxAll = assignMaskedCenters(msMbhxAll,mbhxCenters,'exp');
histMbhyAll = assignMaskedCenters(msMbhyAll,mbhyCenters,'exp');

%% dimensionality reduction
% put together features
histAll = [histHofAll,histHogAll,histMbhxAll,histMbhyAll]/4;

% distance matrix and similarity matrix
distHistAll = pdist2(histAll,histAll,@(P,Q) chi_square(P,Q));
simHistAll = 1-distHistAll/max(distHistAll(:));

%%%% PCA %%%%
[drHistAll,coeff] = drHist(histAll,ci);
pcaDim = size(drHistAll,2);

%%%% MDS %%%%
[mdsHistAll,emdsHist] = cmdscale(distHistAll);
cum = cumsum(emdsHist);
cum = cum/cum(end)*100;
mdsHistAll = mdsHistAll(:,1:find(cum>ci,1));

%% clustering methods
numCluster = 10;

%%%% plain k means %%%%
indAll = kmeans(drHistAll,numCluster,'replicate',3,'emptyaction','drop');
% visualize
figure;set(gcf,'color','w');
scatter3(drHistAll(:,1),drHistAll(:,2),drHistAll(:,3),[],indAll)
xlabel('PC 1');ylabel('PC 2');zlabel('PC 3');

%%%% AP clustering %%%%
indAll = apcluster(simHistAll,median(simHistAll));
%indAll = apcluster(simHistAll,min(simHistAll(:))-10*(max(simHistAll(:))-min(simHistAll(:))));

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
figure;dscatter(emHist(:,1),emHist(:,2));

%% analyze clusters
% load annotations
fileind = [1:11,13:32];
timeStep = 25;
annoType = 4;
movieParamMulti = paramMulti(fileind);
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
annoRaw = annoMulti(movieParamMulti,annoPath,timeStep,0);
annoAll = mergeAnno(annoRaw,annoType);
keepind = annoAll~=0;

% generate annotation string
annostr = cell(length(unique(annoAll(keepind))),1);
for i = 1:size(annostr,1)
    annostr{i} = annoInfo(annoType,i);
end

% evaluate clusters
[acr,prc] = evaluateClusters(indAllAP(keepind),annoAll(keepind));

% visualize
figure;set(gcf,'color','w');
bar(acr);
xlabel('cluster class');
ylabel('percentage');
title('annotation component in clusters');
legend(annostr)
colormap(jet)

figure;set(gcf,'color','w');
bar(prc);
xlabel('annotation class');
ylabel('percentage');
title('cluster component in annotations');
legend('show')
colormap(jet)

%% annotation class distribution
movieParamMulti = paramMulti(fileind);
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
annoRaw = annoMulti(movieParamMulti,annoPath,timeStep,0);
annoAll = mergeAnno(annoRaw,6);

ulabels = unique(annoAll);
annoCounts = histc(annoAll,ulabels);
xticklabels = cell(length(ulabels)+1,1);
xticklabels(2:end-1) = mat2cell(num2str(ulabels(2:end)),ones(length(ulabels)-1,1));

figure;set(gcf,'color','w');
bar(annoCounts(2:end));
xlim([0 length(ulabels)]);
set(gca,'xtick',0:length(ulabels),'xticklabel',xticklabels);
xlabel('annotation class');
ylabel('counts');
box off;

%% generate training and testing samples for SVM
% initialize
setSeed(0);

% movie parameters
movieParamMulti = paramMulti(fileind);

% exclude "other" class in training
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
annoRaw = annoMulti(movieParamMulti,annoPath,timeStep,0);
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
labelTraining = label(indxTraining);
labelTest = label(indxTest);

% plot class distribution
figure;set(gcf,'color','w');
subplot(1,2,1);hist(label(indxTraining),[min(label):max(label)]+0.5);
title('training sample distribution');
xlabel('class');ylabel('number of samples');
subplot(1,2,2);hist(label(indxTest),[min(label):max(label)]+0.5);
title('testing sample distribution');
xlabel('class');ylabel('number of samples');

%% one-vs-rest svm model
% generate weights for unbalanced class
weightParam = [];
for i = 1:numClass
    w = numTraining/sum(labelTraining==i);
    weightParam = [weightParam ' -w' num2str(i) ' ' num2str(w)];
end

% parameter selection
[bestc,bestg] = svmParamGrid(labelTraining,sample(indxTraining,:),...
    'one-vs-rest',weightParam);
svmParam1r = ['-t 2 -b 1 -q ' weightParam ' -c ' num2str(bestc) ...
    ' -g ' num2str(bestg)];

% training
model1r = ovrtrain(labelTraining,sample(indxTraining,:),svmParam1r);

% test
[predictedTest,acrTest,scoreTest] = ovrpredict(labelTest,...
    sample(indxTest,:),model1r,'-b 1');
fprintf('Test accuracy: %6.2f%%\n',acrTest*100);

%% one-vs-one svm training
% parameter selection
[bestc,bestg] = svmParamGrid(labelTraining,sample(indxTraining,:),...
    'one-vs-one',weightParam);
svmParam11 = ['-t 2 -b 1 -q ' weightParam ' -c ' num2str(bestc) ...
    ' -g ' num2str(bestg)];

% training
model11 = svmtrain(labelTraining,sample(indxTraining,:),svmParam11);

% test
[predictedTest,acrTest,scoreTest] = svmpredict(labelTest,...
    sample(indxTest,:),model11,'-b 1');
fprintf('Test accuracy: %6.2f%% \n',acrTest(1));

% save result
save('C:\Shuting\Data\yeti\svm_20151029.mat','svmParam11','svmParam1r',...
    'model11','model1r','sample','label','indxTraining','indxTest','-v7.3');

%% ROC curve
faRate = cell(numClass,1);
hitRate = cell(numClass,1);
AUC = zeros(numClass,1);
for i = 1:numClass
    [faRate{i},hitRate{i},~,AUC(i)] = perfcurve(labelTest,scoreTest(:,i),i);
end
% plot ROC curve
cc = hsv(numClass);
figure;
set(gcf,'color','w');
hold on;
for i = 1:numClass
    plot(faRate{i}, hitRate{i}, '-','color',cc(i,:));
end
e = 0.05; axis([0-e 1+e 0-e 1+e])
xlabel('false alarm rate')
ylabel('hit rate')
grid on
legend('1','2','3','4','5','6','7','8');


%% test on new dataset
% assume we have loaded a new dataset with variable "histAll"
fileind = 301:322;
timeStep = 5;
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
savepath = 'C:\Shuting\Data\yeti\classification\dataset_m_2_n_2_step_5_20151115\';

% do PCA first
muHist = mean(histAll,1);
drHistAll = bsxfun(@minus,histAll,muHist)*coeff;
drHistAll = drHistAll(:,1:pcaDim);

% load annotation
annoType = 5;
movieParamAll = paramMulti(fileind);
annoRaw = annoMulti(movieParamAll,annoPath,timeStep,0);
annoAll = mergeAnno(annoRaw,annoType);
keepind = annoAll~=0;
numCubes = sum(keepind);
sample = drHistAll(keepind,:);
label = annoAll(keepind);
save([savepath movieParam.fileName '_svm_data.mat'],'sample','label','-v7.3');

% generate libsvm format data
gnLibsvmFile(label,sample,[savepath movieParam.fileName '_test.txt']);

