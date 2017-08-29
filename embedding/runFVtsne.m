function [] = runFVtsne(param,tsne_param)
% script for generating embedding map and for embed new samples

filepath = param.filepath;
infostr = param.infostr;
trainIndx = param.trainIndx;
testIndx = param.testIndx;
num_new = length(param.testIndx);

%% load data
data = load([filepath infostr '_drFVall.mat']);
acm = data.acm;
data = data.drFVall;

% load pca matrix
load([filepath infostr '_pcaCoeff.mat']);

%% subsample for embedding
% load data and subsample
percTrain = tsne_param.percTrain;
dataTrain = [];
dataTest = [];
numFiles = length(trainIndx);
dataAll = cell(numFiles,1);

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

% extract individual data
for ii = 1:length(acm)-1
    dataAll{ii} = data(acm(ii)+1:acm(ii+1),:);
end


%% generate embedding map on training data
% distance matrix
fprintf('calculating distance...\n');
DTrain = calcMatDist(dataTrain,tsne_param.distType);

% run t-sne
fprintf('embedding training data...\n');
[emDataTrain,betas,P,errors] = tsne_d_sparse(DTrain,tsne_param);

%% generate embedding map on each individual
fprintf('embedding all data...\n');
emDataAll = cell(numFiles,1);
for ii = 1:numFiles
    fprintf('processing file %u...\n',ii);
    [emDataAll{ii},~] = findEmbedding(dataAll{ii},dataTrain,emDataTrain,tsne_param);
end

%% generate embedding map on other samples
% on test sample
fprintf('embedding test data...\n');
[emDataTest,~] = findEmbedding(dataTest,dataTrain,emDataTrain,tsne_param);

% on new sample
emDataNew = cell(length(testIndx),1);
for ii = 1:length(testIndx)
    
    movieParam = paramAll_galois(testIndx(ii));
    fprintf('embedding new data %s...\n',movieParam.fileName);
    
    load([filepath movieParam.fileName '_' infostr '_FVall.mat']);
    dataNew = FVall;
    clear FVall
 
    % do pca
    muData = mean(dataNew,1);
    dataNew = bsxfun(@minus,dataNew,muData)*coeff;
    dataNew = dataNew(:,1:pcaDim);
    
    % normalize data
    %dataNew = dataNew-min(dataNew,[],2)*ones(1,size(dataNew,2));
    %dataNew = dataNew./(sum(dataNew,2)*ones(1,size(dataNew,2)));
    
    [emDataNew{ii},~] = findEmbedding(dataNew,dataTrain,emDataTrain,tsne_param);
    
end

%% make density plots
% center data
mu = mean(cell2mat(emDataAll),1);
emDataAllCent = cellfun(@(x) x-ones(size(x,1),1)*mu,emDataAll,'uniformoutput',false);
emDataNewCent = cellfun(@(x) x-ones(size(x,1),1)*mu,emDataNew,'uniformoutput',false);
emDataTrainCent = emDataTrain-ones(size(emDataTrain,1),1)*mu;
emDataTestCent = emDataTest-ones(size(emDataTest,1),1)*mu;

maxVal = max(max(cell2mat(emDataAllCent)));
maxVal = round(maxVal * 1.1);

% these are parameters to adjust
sigma = maxVal/40;
numPoints = 501;
rangeVals = [-maxVal maxVal];

% generate plot with data
[xx,densAll] = findPointDensity(cell2mat(emDataAllCent),sigma,numPoints,rangeVals);
[~,densTrain] = findPointDensity(emDataTrainCent,sigma,numPoints,rangeVals);
[~,densTest] = findPointDensity(emDataTestCent,sigma,numPoints,rangeVals);

% generate plot for individual samples
numFiles = size(emDataAllCent,1);
densIndiv = zeros(numPoints,numPoints,numFiles);
for ii = 1:numFiles
    [~,densIndiv(:,:,ii)] = findPointDensity(emDataAllCent{ii},sigma,numPoints,rangeVals);
end

% generate plot for new samples
densNew = zeros(numPoints,numPoints,length(emDataNewCent));
for ii = 1:length(emDataNewCent)
    [~,densNew(:,:,ii)] = findPointDensity(emDataNewCent{ii},sigma,numPoints,rangeVals);
end

% 
im = densTrain;
map_thresh = 0.4;
im_mask = im>quantile(im(:),map_thresh);

%% plot overall, training, test density
cmax = max(densAll(:))*0.8;
figure;set(gcf,'color','w')
subplot(1,3,1)
plotTsneDens(xx,densAll,im_mask,cmax); title('all embedding'); colorbar('off')
subplot(1,3,2)
plotTsneDens(xx,densTrain,im_mask,cmax); title('training embedding'); colorbar('off')
subplot(1,3,3)
plotTsneDens(xx,densTest,im_mask,cmax); title('test embedding')

% plot individual plot
figure;set(gcf,'color','w')
N = ceil(sqrt(numFiles));
M = ceil(numFiles/N);
for ii = 1:numFiles
    subplot(M,N,ii)
    plotTsneDens(xx,densIndiv(:,:,ii),im_mask,20*cmax)
    title(['Data Set #' num2str(ii)],'fontsize',8); %,'fontweight','bold');
    if ii~=numFiles
        colorbar('off');
    end
end

% new samples
figure;set(gcf,'color','w')
for ii = 1:length(emDataNew)
    subplot(1,length(emDataNew),ii)
    plotTsneDens(xx,densNew(:,:,ii),im_mask,20*cmax)
    title(['New Data Set #' num2str(ii)],'fontsize',8); %,'fontweight','bold');
    if ii~=length(emDataNew)
        colorbar('off');
    end
end

%% segment density plots
% smooth
fgauss = fspecial('gaussian',3,1);

% internal marker
local_max = round(FastPeakFind(im,0,fgauss));
int_marker = false(size(im));
int_marker(sub2ind(size(im),local_max(2:2:end),local_max(1:2:end))) = true;
int_marker = imdilate(int_marker,strel('disk',3));
intm_dist = imcomplement(bwdist(~int_marker));

% watershed
seg_im = watershed(intm_dist);
seg_im_trans = seg_im';

% zero-set boundaries
seg_bound = seg_im==0;
numClass = length(unique(seg_im(:)))-1;

%% compare with annotation, make large clusters
% compare with manual annotation
movieParamMulti = paramMulti(param.dpath,param.trainIndx);
annoAll = annoMulti(movieParamMulti,param.annopath,tsne_param.annotype,param.timeStep);
numAnnoClass = max(annoAll);

% find the majority label in each region
vdata = emDataTrainCent;
vdata = round((vdata/maxVal*numPoints+numPoints)/2);
vdata(vdata<=0) = 1;
vdata(vdata>=numPoints) = numPoints;
segIndx = seg_im_trans(sub2ind(size(im),vdata(:,1),vdata(:,2)));
counts = zeros(numClass,numAnnoClass);
annoTrain = annoAll(indxTrain);
annoTest = annoAll(indxTest);
for ii = 1:numClass
    counts(ii,:) = histc(annoTrain(segIndx==ii),...
        1:numAnnoClass)';
end
counts = counts./(sum(counts,2)*ones(1,size(counts,2)));
[perc,seg_cat] = max(counts,[],2);

% make large region segmentation
useg = unique(seg_cat);
numRegions = length(useg);
reg_im = seg_im;
for ii = 1:numRegions
    crRegs = find(seg_cat==useg(ii));
    for j = 1:length(crRegs)
        reg_im(seg_im==crRegs(j)) = ii;
    end
end
region_im_trans = reg_im';

%% evaluate segmentated clusters with new samples
newRegCount = zeros(numRegions,numAnnoClass+1);
regIndxNew = cell(num_new,1);
annoNew = cell(num_new,1);
for qIndx = 1:length(testIndx);

    % data to analyze
    vdata = emDataNewCent{qIndx};
    vdata = round((vdata/maxVal*numPoints+numPoints)/2);
    vdata(vdata<=0) = 1;
    vdata(vdata>=numPoints) = numPoints;
    regIndxNew{qIndx} = region_im_trans(sub2ind(size(im),vdata(:,1),vdata(:,2)));

    % annotation
    annoNew{qIndx} = annoMulti(paramMulti(param.dpath,testIndx(qIndx)),...
        param.annopath,tsne_param.annotype,param.timeStep);
    for ii = 1:numRegions
        newRegCount(ii,:) = newRegCount(ii,:)+reshape(histc(annoNew{qIndx}(regIndxNew{qIndx}==ii),...
            0.5:1:numAnnoClass+0.5),1,numAnnoClass+1);
    end
    
end
newRegCount = newRegCount(:,1:end-1);
newRegCount = newRegCount./(sum(newRegCount,2)*ones(1,size(newRegCount,2)));

%% plot density and segmentation
figure;set(gcf,'color','w')
gscatter(emDataTrain(:,1),emDataTrain(:,2),annoTrain);
xlim([xx(1) xx(end)]);ylim([xx(1) xx(end)])
axis equal tight

figure;set(gcf,'color','w')
subplot(2,2,1)
title('tSNE density')
plotTsneDens(xx,im,im_mask,cmax)
subplot(2,2,2)
plotTsneDens(xx,im.*(~seg_bound),im_mask,cmax)
title('watershed segmentation');
subplot(2,2,3)
plotRegionLabel(xx,seg_im,im_mask)
title('watershed segmentation')
subplot(2,2,4)
plotTsneDens(xx,double(reg_im).*(~seg_bound),im_mask,numRegions)
title('merged regions')

%% plot merged region validation
figure;set(gcf,'color','w','position',[2032,809,990,117])

% training data
vdata = emDataTrainCent;
vdata = round((vdata/maxVal*numPoints+numPoints)/2);
vdata(vdata<=0) = 1;
vdata(vdata>=numPoints) = numPoints;
regIndx = region_im_trans(sub2ind(size(im),vdata(:,1),vdata(:,2)));
plotTrueLabelValidation(regIndx,annoTrain,numRegions,numAnnoClass,3,1)

% test data
vdata = emDataTestCent;
vdata = round((vdata/maxVal*numPoints+numPoints)/2);
vdata(vdata<=0) = 1;
vdata(vdata>=numPoints) = numPoints;
regIndx = region_im_trans(sub2ind(size(im),vdata(:,1),vdata(:,2)));
plotTrueLabelValidation(regIndx,annoTest,numRegions,numAnnoClass,3,2)

% new data
plotTrueLabelValidation(cell2mat(regIndxNew),cell2mat(annoNew),...
    numRegions,numAnnoClass,3,3);
% for ii = 1:num_new
%     plotTrueLabelValidation(regIndxNew{ii},annoNew{ii},numRegions,numAnnoClass,num_new+2,2+ii)
% end

%% plot annotation density
densAnno = zeros(numPoints,numPoints,numAnnoClass);
emDataMat = emDataTrainCent;
for ii = 1:numAnnoClass
    [~,densAnno(:,:,ii)] = findPointDensity(emDataMat(annoTrain==ii,:),sigma,...
        numPoints,rangeVals);
end

% plot
figure;set(gcf,'color','w')
N = ceil(sqrt(numAnnoClass));
M = ceil(numAnnoClass/N);
for ii = 1:numAnnoClass
    subplot(M,N,ii)
    plotTsneDens(densAnno(:,:,ii),im_mask,cmax);
    title([num2str(ii) '. ' annoInfo(annoType,ii)],'fontsize',12,'fontweight','bold');
end

%% visualize video samples
qlabel = 1;
figure;imagesc((reg_im==qlabel).*im);
caxis([min(densAll(:)),max(densAll(:))]);colormap(jet);
axis equal tight off xy
% visualizeResultMulti_galois(find(segIndx==qlabel),timeStep,movieParamMulti,1,0,'');
visualizeResultMulti(find(regIndx==qlabel),timeStep,movieParamMulti,1,1,num2str(qlabel));

%% save results
save([param.tsnepath param.infostr '_K_' num2str(param.K) '_' param.datastr...
    '_emspace.mat'],'region_im_trans','xx','tsne_param','maxVal','mu','numPoints');
save([param.tsnepath param.infostr '_K_' num2str(param.K) '_' param.datastr...
    '_tsneTrain.mat'],'emDataTrain','dataTrain','-v7.3');

save([param.tsnepath param.infostr '_K_' num2str(param.K) '_' param.datastr...
    '_workspace.mat'],'-v7.3');

end

