%% flow + kmeans clustering

% set parameters
movieParam = paramAll;
hydraParam=estimateHydraParam(movieParam);

% first step: extract all trajectories, cluster them, and get centers
%a = movieParam.imageSize(1);
%b = movieParam.imageSize(2);
m = 1;
n = 1;
tw = 30;
numCluster1 = 100;

[trackVelBatch,~]=extractTrackBatchNor(m,n,tw,movieParam,hydraParam);
[flowsAll,flowsIndx] = getFlows(trackVelBatch);

% do pca before clustering
ci = 95;
[drFlowsAll,coeffFlowsAll] = drHist(flowsAll,numCluster1,ci,0);

%[rawInd,rawCenters] = kmeans(flowsAll,numCluster1,'replicate',3);
[rawInd,rawCenters] = kmeans(drFlowsAll,numCluster1,'replicate',3);
numCubes = size(trackVelBatch,1);

% clustering result for unchopped data
%numCluster2 = 3;
histAll = getCenterHist(flowsAll,flowsIndx,rawInd,rawCenters,m,n,'kcb_exp');
%[indAll,centersAll] = kmeans(histAll,numCluster2,'replicate',5);
%distAll = plotDistMat(histAll,indAll);

% second step: chop images and cluster trajectories in each patch according
% to the centers generated from the first tep, then cluster them
m = 2; %round(movieParam.imageSize(2)/(hydraParam.width/2));
n = 4; %round(movieParam.imageSize(1)/(hydraParam.length/4));
[trackVelBatchChopped,trackLocBatchChopped]=extractTrackBatchNor(m,n,tw,movieParam,hydraParam);
[flowsChopped,flowsChoppedInd] = getFlows(trackVelBatchChopped);
%[rawIndChopped,rawCentersChopped] = kmeans(flowsChopped(:,3:end),numCluster1,...
%    'MaxIter',1,'Start',rawCenters);
rawIndChopped = findClusterID(flowsAll,flowsChopped,rawInd);
histChopped=getCenterHist(flowsChopped,flowsChoppedInd,rawIndChopped,rawCenters,m,n,'kcb_exp');
%[indChopped,centersChopped] = kmeans(histChopped,numCluster2,'replicate',5);

% visualize distance matrix
%distChopped = plotDistMat(histChopped,indChopped);

% visualize result
%playVideo(find(indChopped==1),movieParam,tw,0);
%makeClusterVideo(indChopped,movieParam,tw,0);


%% pca on the feature clusters

ci = 95;

% first try the unchopped data
[drHistAll,coeffAll] = drHist(histAll,numCluster1,ci,0);
pcaDim = size(drHistAll,2);

% cluster the transformed data
%[drIndAll,drCentersAll] = kmeans(drHistAll,numCluster2,'replicate',3);
%drDistAll = plotEucMat(drHistAll,drIndAll);

% get the dimensionality-reduced histogram distribution on chopped data
%[drHistChopped,coeffChopped] = drHist(histChopped,numCluster1,ci,0);
%pcaDim = size(drHistChopped,2);
%muChopped = mean(histChopped,1);

% cluster on the low dimension data
%[drIndChopped,drCentersChopped] = kmeans(drHistChopped,numCluster2,'replicate',5);
%drDistChopped = plotEucMat(drHistChopped,drIndChopped);

%% alternative method: add coordinate information in the flows

% set parameters
movieParam = paramAll;
hydraParam=estimateHydraParam(movieParam);
m = 2;
n = 3;
tw = 5;
step = 4;
numCluster1 = 200;
ci=95;

% extract velocity and location information from raw tracking
tracksAll=processTracks(movieParam,hydraParam,m,n,step);
[trackVelBatch,trackLocBatch] = extractTrackBatchStep(tracksAll,m,n,tw);
numCubes = size(trackVelBatch,1);
[velAll,velInd] = getFlows(trackVelBatch,0);
[locAll,locInd] = getFlows(trackLocBatch,0);
%[angAll,weiAll,angInd] = getFlowAngle(trackVelBatch);
keepInd = (sum(velAll==0,2)==0&sum(isnan(velAll),2)==0);
velAll = velAll(keepInd,:);
velInd = velInd(keepInd,:);
locAll = locAll(keepInd,:);
%locInd = locInd(keepInd,:);
%angAll = angAll(keepInd,:);
%weiAll = weiAll(keepInd,:);
%angInd = angInd(keepInd,:);
%flowsAll = [velAll,locAll];

% do pca here?
%[drVelAll,coeffVelAll] = drHist(velAll,numCluster1,ci,0);
%[drLocAll,coeffLocAll] = drHist(locAll,numCluster1,ci,0);
%[drAngAll,coeffAngAll] = drHist(angAll,numCluster1,ci,0);
%drFlowsAll = [drVelAll,drLocAll];

% do pca before clustering
%[drFlowsAll,coeffFlowsAll] = drHist(flowsAll,numCluster1,ci,0);

% do clustering to generate codebook centers
%[rawIndAll,rawCentersAll] = kmeans(flowsAll,numCluster1,'replicate',3);
[rawVelInd,rawVelCenters] = kmeans(velAll,numCluster1,'replicate',3);
[rawLocInd,rawLocCenters] = kmeans(locAll,numCluster1,'replicate',3);
[rawAngInd,rawAngCenters] = kmeans(angAll,numCluster1,'replicate',3);

% assign flows to codebook centers and calculate histogram features
%histAll = getCenterHist(flowsAll,velInd,rawIndAll,rawCentersAll,m,n,'kcb_exp');
histVelAll = getCenterHist(velAll,velInd,rawVelInd,rawVelCenters,m,n,'kcb_exp');
histLocAll = getCenterHist(locAll,locInd,rawLocInd,rawLocCenters,m,n,'kcb_exp');
%hofAll = hof(angAll,weiAll,angInd,16,m,n,0);
histAngAll = getCenterHist(angAll,angInd,rawAngInd,rawAngCenters,m,n,'kcb_exp');
histAll = [histVelAll,histLocAll,histAngAll];

% or do pca on the histograms
[drHistAll,coeffHistAll] = drHist(histVelAll,numCluster1,ci,0);
pcaDim = size(drHistAll,2);

%% or calculate a smooth field and extract flows frome here

scale = hydraParam.length/200; % normalizing parameter
r = round(hydraParam.length/100); % grid length in the field

tracksRaw = dlmread(movieParam.filenameTracks,'\t',1,3);
tracksAll = cell(movieParam.numImages,1);

for i = 1:movieParam.numImages
    ind = (tracksRaw(:,7)==i-1); % because in the csv file frame starts from 0
    infomat = zeros(sum(ind),3);
    infomat(:,1) = tracksRaw(ind,1); % track ID
    coordCurrent = tracksRaw(ind,3:4);
    % rotate to calibrated coordinate system (animal axis aligned) and
    % centralize the centroid
    coordNew = (coordCurrent-ones(sum(ind),1)*hydraParam.centroid)*...
        hydraParam.rotmat;
    % normalize by half length of the hydra, and scale up by 100
    coordNew = coordNew./scale;
    infomat(:,2:3) = coordNew; % (x,y) location
    tracksAll{i} = infomat;
    clear infomat
    clear ind
end

[xx,yy] = meshgrid(-movieParam.imageSize(1)/(2*scale):r:movieParam.imageSize(1)/...
    (2*scale),-movieParam.imageSize(2)/(2*scale):r:movieParam.imageSize(2)/(2*scale));

[uu,vv] = calculateField(tracksAll,xx,yy,r);

fgauss = fspecial('gaussian',[3,3]);
fgauss=fgauss./sum(fgauss(:));
smuu=imfilter(uu,fgauss);
smvv=imfilter(vv,fgauss);

[velAll,angAll,weiAll,indAll] = flowfromfield(smuu,smvv,xx,yy,tw,m,n);
locAll = repmat([xx(:),yy(:)],floor(size(uu,1)/tw),tw);
keepInd = (sum(velAll==0,2)==0&sum(isnan(velAll),2)==0);
velAll = velAll(keepInd,:);
indAll = indAll(keepInd,:);
locAll = locAll(keepInd,:);

velAll = velAll/max(abs(min(velAll(:))),abs(max(velAll(:))));

%% take random samples for svm training
% take 90% as training sample
indx = randperm(numCubes);
numTraining = round(0.9*numCubes);
indxTraining = indx(1:numTraining)';
indxTest = indx(numTraining+1:end)';

% check the sample distribution
figure;
subplot(5,2,1);hist(anno_1_1_cubes(indxTraining),5);subplot(5,2,2);hist(anno_1_1_cubes(indxTest),5);
subplot(5,2,3);hist(anno_1_2_cubes(indxTraining),5);subplot(5,2,4);hist(anno_1_2_cubes(indxTest),5);
subplot(5,2,5);hist(anno_1_3_cubes(indxTraining),5);subplot(5,2,6);hist(anno_1_3_cubes(indxTest),5);
subplot(5,2,7);hist(anno_1_4_cubes(indxTraining),5);subplot(5,2,8);hist(anno_1_4_cubes(indxTest),5);
subplot(5,2,9);hist(anno_1_6_cubes(indxTraining),5);subplot(5,2,10);hist(anno_1_6_cubes(indxTest),5);
%figure;subplot(1,2,1);hist(anno_5_2_cubes(indxTraining),5);subplot(1,2,2);hist(anno_5_2_cubes(indxTest),5);

labels = anno_1_6_cubes; % change annotation version here
numClass = max(labels);
sample = drHistVelAll;

%% one-vs-rest svm training
% initialize
model = cell(numClass,1);
predictedLabel = cell(numClass,1);
accuracyTest = zeros(numClass,3);
accuracyTraining = zeros(numClass,3);
probEstimateTest = cell(numClass,1);
probEstimateTraining = cell(numClass,1);
crossVal = zeros(numClass,1);

% train classifier and cross validation
for i = 1:numClass
    c0 = 1/sum(labels(indxTraining)~=i);
    c1 = 1/sum(labels(indxTraining)==i);
    svmParam = ['-t 2 -b 1 -q -g 100 -c 100 -w0 ' num2str(c0) ' -w1 ' num2str(c1)];
    model{i} = svmtrain(double(labels(indxTraining)==i),sample(indxTraining,:), svmParam);
    crossVal(i) = svmtrain(double(labels(indxTraining)==i),sample(indxTraining,:), [svmParam ' -v ' num2str(numClass)]);
    [~,accuracyTraining(i,:),probEstimateTraining{i}] = svmpredict(double(labels(indxTraining)==i),sample(indxTraining,:),model{i},'-b 1');
    [predictedLabel{i},accuracyTest(i,:),probEstimateTest{i}] = svmpredict(double(labels(indxTest)==i),sample(indxTest,:),model{i},'-b 1');
end

% combine all classes and classify
probsTest = zeros(length(indxTest),numClass);
for i = 1:numClass
    tmp = probEstimateTest{i};
    probsTest(:,i) = tmp(:,1);
end
scoresTestFinal = max(probsTest,[],2);
labelsTestFinal = zeros(length(indxTest),1);
for i = 1:length(indxTest)
    labelsTestFinal(i) = find(probsTest(i,:)==max(probsTest(i,:)));
end

% overall accuracy
accuracyTestAll = sum(labelsTestFinal==labels(indxTest))/length(indxTest)

% plot ROC curve
ROCcurve(scoresTestFinal,labelsTestFinal==labels(indxTest),1);

%% one-vs-one svm training
% do grid search on svm parameters (g and c)
[crossVal,cgs]=svm_grids(sample,labels,indxTraining);
display(cgs(crossVal==max(crossVal),:));

% calcualte parameters
svmParam = '-t 2 -b 1 -q -g 10 -c 100';
w = zeros(numClass,1);
for i = 1:numClass
    w(i) = 1/sum(labels(indxTraining==i));
    svmParam = [svmParam ' -w' num2str(i) ' ' num2str(w(i))];
end

% train model
models = svmtrain(labels(indxTraining),sample(indxTraining,:),svmParam);

% cross validation
%crossVal = svmtrain(labels(indxTraining),sample(indxTraining,:),[svmParam ' -v ' num2str(numClass)]);

% make predictions
[predictedLabel,~,probEstimate]=svmpredict(ones(size(indxTest)),sample(indxTest,:),models,'-b 1 -q');

% calculate overall accuracy
acrAll = sum(predictedLabel==labels(indxTest))/length(indxTest);
display(acrAll);

%% now test on a new dataset
% old version of new test data
movieParam2 = paramAll;
hydraParam2=estimateHydraParam(movieParam2);
m = 1;
n = 1;
[trackVelBatch2,trackLocBatch2]=extractTrackBatchNor(m,n,tw,movieParam2,hydraParam2);

%m = 4;
%n = 8;
[trackVelBatchChopped2,trackLocBatchChopped2]=extractTrackBatchNor(m,n,tw,movieParam2,hydraParam2);
flowsChopped2 = getFlows(trackVelBatchChopped2);

% method 1: redo clustering on raw flows
%[rawInd2,rawCenters2] = kmeans(flowsAll2(:,3:end),numCluster1,'replicate',3);
%rawIndChopped2 = findClusterID(flowsAll2,flowsChopped2,rawInd2);
%histChopped2=getCenterHist(flowsChopped2,rawIndChopped2,rawCenters2,'kcb_exp');

% method 2: use previous cluster centers
[rawIndChopped2,~] = kmeans(flowsChopped2(:,3:end),numCluster1,...
    'MaxIter',1,'Start',rawCenters);
histChopped2=getCenterHist(flowsChopped2,rawIndChopped2,rawCenters,m,n,'kcb_exp'); % rawIndChopped2 is only used with hard kernel
muChopped2 = mean(histChopped2,1);

% transform the new data to low dimensional space using previous parameters
histChoppedCentered2 = bsxfun(@minus,histChopped2,muChopped2);
drHistChopped2 = histChoppedCentered2*coeffChopped;
drHistChopped2 = drHistChopped2(:,1:pcaDim);

%% alternative pre-processing

movieParam2 = paramAll;
hydraParam2=estimateHydraParam(movieParam2);

% extract velocity and location information from raw tracking
tracksAll2=processTracks(movieParam,hydraParam,m,n,step);
[trackVelBatch2,trackLocBatch2] = extractTrackBatchStep(tracksAll2,m,n,tw);
[velAll2,velInd2] = getFlows(trackVelBatch2,0);
[locAll2,locInd2] = getFlows(trackLocBatch2,0);
%[angAll2,weiAll2,angInd2] = getFlowAngle(trackVelBatch2);
keepInd2 = (sum(velAll2==0,2)==0&sum(isnan(velAll2),2)==0);
velAll2 = velAll2(keepInd2,:);
velInd2 = velInd2(keepInd2,:);
locAll2 = locAll2(keepInd2,:);
locInd2 = locInd2(keepInd2,:);
%angAll2 = angAll2(keepInd2,:);
%weiAll2 = weiAll2(keepInd2,:);
%angInd2 = angInd2(keepInd2,:);

% assign flows to codebook centers and calculate histogram features
histVelAll2 = getCenterHist(velAll2,velInd2,rawVelInd,rawVelCenters,m,n,'kcb_exp');
%histLocAll2 = getCenterHist(locAll2,locInd2,rawLocInd,rawLocCenters,m,n,'kcb_exp');
%hofAll2 = hof(angAll2,weiAll2,angInd2,16,m,n,0);
%histAngAll2 = getCenterHist(angAll2,angInd2,rawAngInd,rawAngCenters,m,n,'kcb_exp');
%histAll2 = [histVelAll2,histLocAll2,histAngAll2];
muAll2 = mean(histVelAll2,1);

% pca
pcaDim = size(drHistVelAll,2);
histAllCentered2 = bsxfun(@minus,histVelAll2,muAll2);
drHistVelAll2 = histAllCentered2*coeffVelAll;
drHistVelAll2 = drHistVelAll2(:,1:pcaDim);

%% svm classificaton

sample = drHistVelAll2;
numSamples = size(sample,1);
predictedLabelNew = cell(numClass,1);
accuracyNew = cell(numClass,1);
probEstimatesNew = cell(numClass,1);
for i = 1:numClass
    [predictedLabelNew{i},accuracyNew{i},probEstimatesNew{i}] = ...
        svmpredict([1:numSamples]',sample,model{i},'-b 1');
end

% take the highest probability as final label
labelsFinal = zeros(numSamples,1);
probsAll = zeros(numSamples,numClass);
for i = 1:numClass
    tmp=probEstimatesNew{i};
    probsAll(:,i) = tmp(:,1);
end
scoresFinal = max(probsAll,[],2);
for i = 1:numSamples
    labelsFinal(i) = find(probsAll(i,:)==max(probsAll(i,:)));
end

accuracyNewAll = sum(labelsFinal==anno_1_6_cubes)/length(labelsFinal)