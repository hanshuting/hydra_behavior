% script for generating embedding map and for embed new samples

addpath(genpath('/home/sh3276/work/code/bow_hydra/'));
%% initialize parameters
parameters.distType = 'chi';
parameters = setRunParameters(parameters);

%% subsample for embedding
% parameters
fileIndx = [1:5,7:11,13:28,30:31];
testIndx = [32,33];
%fileIndx = 401:413;
%testIndx = 414;
infostr = 'L_15_W_2_N_32_s_1_t_3_step_25';
datestr = '20160105';
filepath = ['/home/sh3276/work/results/dt_hists/min_var0.5/' infostr '_' datestr '/'];
savepath = 'E:\galois\results\embedding\';

% load data and subsample
percTrain = 0.9;
dataTrain = [];
dataTest = [];
numFiles = length(fileIndx);
dataAll = cell(numFiles,1);
acm = zeros(numFiles+1,1);
for i = 1:numFiles

    movieParam = paramAll_galois(fileIndx(i));
    fprintf('loading sample %s...\n',movieParam.fileName);
    
    load([filepath movieParam.fileName '_' infostr '_histHof.mat']);
    load([filepath movieParam.fileName '_' infostr '_histHog.mat']);
    load([filepath movieParam.fileName '_' infostr '_histMbhx.mat']);
    load([filepath movieParam.fileName '_' infostr '_histMbhy.mat']);
    
    numData = size(histHof,1);
    numTrain = round(percTrain*numData);
    indxTest = randperm(numData);
    indxTrain = indxTest(1:numTrain);
    indxTest = indxTest(numTrain+1:end);
    
    dataTrain(end+1:end+numTrain,:) = [histHof(indxTrain,:),histHog(indxTrain,:),...
        histMbhx(indxTrain,:),histMbhy(indxTrain,:)]/4;
    dataTest(end+1:end+numData-numTrain,:) = [histHof(indxTest,:),histHog(indxTest,:),...
        histMbhx(indxTest,:),histMbhy(indxTest,:)]/4;
    
    dataAll{i} = power_normalization([histHof,histHog,histMbhx,histMbhy]/4,0.5);
    
    acm(i+1) = acm(i)+size(histHof,1);
    
end

% power normalization
dataTrain = power_normalization(dataTrain,0.5);
dataTest = power_normalization(dataTest,0.5);

%% generate embedding map on training data

% distance matrix
fprintf('calculating distance...\n');
DTrain = chiSquare(dataTrain,dataTrain);
%DTrain = intersection(dataTrain,dataTrain);

% run t-sne
fprintf('embedding training data...\n');
[emDataTrain,betas,P,errors] = tsne_d(DTrain,parameters);

%% generate embedding map on each individual
emDataAll = cell(numFiles,1);
for i = 1:numFiles
    [emDataAll{i},~] = findEmbedding(dataAll{i},dataTrain,emDataTrain,parameters);
end

%% generate embedding map on other samples
% on test sample
fprintf('embedding test data...\n');
[emDataTest,~] = findEmbedding(dataTest,dataTrain,emDataTrain,parameters);

% on new sample
load('/home/sh3276/work/results/embedding/data.mat');
emDataNew = cell(length(testIndx),1);
for i = 1:length(testIndx)
    
    movieParam = paramAll_galois(testIndx(i));
    fprintf('embedding new data %s...\n',movieParam.fileName);
    
    load([filepath movieParam.fileName '_' infostr '_histHof.mat']);
    load([filepath movieParam.fileName '_' infostr '_histHog.mat']);
    load([filepath movieParam.fileName '_' infostr '_histMbhx.mat']);
    load([filepath movieParam.fileName '_' infostr '_histMbhy.mat']);
    dataNew = [histHof,histHog,histMbhx,histMbhy]/4;
    dataNew = power_normalization(dataNew,0.5);
    
    [emDataNew{i},~] = findEmbedding(dataNew,dataTrain,emDataTrain,parameters);
    
end

delete(gcp);

%% make density plot
maxVal = max(max(cell2mat(emDataAll)));
maxVal = round(maxVal * 1.1);

% these are parameters to adjust
sigma = maxVal/40;
numPoints = 501;
rangeVals = [-maxVal maxVal];

% generate plot with all data
[xx,densAll] = findPointDensity(cell2mat(emDataAll),sigma,numPoints,rangeVals);

% training data
[~,densTrain] = findPointDensity(emDataTrain,sigma,numPoints,rangeVals);

% test data
[~,densTest] = findPointDensity(emDataTest,sigma,numPoints,rangeVals);

% generate plot for individual samples
densIndiv = zeros(numPoints,numPoints,numFiles);
for i = 1:numFiles
    [~,densIndiv(:,:,i)] = findPointDensity(emDataAll{i},sigma,numPoints,rangeVals);
end

% generate plot for new samples
densNew = zeros(numPoints,numPoints,length(testIndx));
for i = 1:length(testIndx)
    [~,densNew(:,:,i)] = findPointDensity(emDataNew{i},sigma,numPoints,rangeVals);
end

% plot overall density
figure;set(gcf,'color','w')
maxDensity = max(densAll(:));
imagesc(xx,xx,densAll)
axis equal tight off xy
caxis([0 maxDensity*0.8])
colormap(jet);title('all embedding')
colorbar

% plot training density
figure;set(gcf,'color','w')
maxDensity = max(densTrain(:));
imagesc(xx,xx,densTrain)
axis equal tight off xy
caxis([0 maxDensity*0.8])
colormap(jet);title('training embedding')
colorbar

% plot test density
figure;set(gcf,'color','w')
maxDensity = max(densTest(:));
imagesc(xx,xx,densTest)
axis equal tight off xy
caxis([0 maxDensity*0.8])
colormap(jet);title('test embedding')
colorbar

% plot individual plot
figure;set(gcf,'color','w')
N = ceil(sqrt(numFiles));
M = ceil(numFiles/N);
maxDensity = max(densIndiv(:));
for i = 1:numFiles
    subplot(M,N,i)
    imagesc(xx,xx,densIndiv(:,:,i))
    axis equal tight off xy
    caxis([0 maxDensity*0.3])
    colormap(jet)
    title(['Data Set #' num2str(i)],'fontsize',12,'fontweight','bold');
end

% new samples
for i = 1:length(testIndx)
    figure;set(gcf,'color','w')
    imagesc(xx,xx,densNew(:,:,i))
    axis equal tight off xy
    caxis([0 maxDensity*0.3])
    colormap(jet);colorbar
    title(['New Data Set #' num2str(i)],'fontsize',12,'fontweight','bold');
end

%% segment density plot
im = mat2gray(imresize(densTrain,[max(xx)-min(xx),max(xx)-min(xx)]));
map_thresh = 0.4;

% smooth
fgauss = fspecial('gaussian',3,1);
im_inv = imcomplement(im);
im_inv_smoothed = imfilter(im_inv,fgauss);

% internal marker
local_max = round(FastPeakFind(im,0,fgauss));
int_marker = false(size(im));
int_marker(sub2ind(size(im),local_max(2:2:end),local_max(1:2:end))) = true;
int_marker = imdilate(int_marker,strel('disk',3));
intm_dist = imcomplement(bwdist(~int_marker));

% watershed
seg_im = watershed(intm_dist);
seg_im_trans = seg_im';

% % -------------------------------------------------------
% % smooth image, substract background
% fgauss = fspecial('gauss',3,1);
% im_smoothed = imfilter(im,fgauss);
% bkg = imopen(im,strel('disk',15));
% im_bkgs = im-bkg;
% 
% % threshold, binarize
% thresh = multithresh(im_bkgs,2);
% bw_im = im_bkgs>thresh(1);
% 
% % compute distance image
% bw_im = imcomplement(bw_im);
% bw_dist = bwdist(bw_im);
% bw_dist = imcomplement(bw_dist);
% figure;imagesc(bw_dist);colormap(gray);
% % watershed
% seg_im = watershed(bw_dist);

% zero-set boundaries
seg_bound = seg_im==0;
numClass = length(unique(seg_im(:)))-1;

% show overlayed result
figure;set(gcf,'color','w')
imagesc(xx,xx,im.*(~seg_bound));
caxis([0 max(im(:))*0.8]);colormap(jet);colorbar;
axis equal tight off xy
title('watershed segmentation');

% show segmentation only
figure;set(gcf,'color','w')
imagesc(xx,xx,(double(seg_im).*double(im>quantile(im(:),map_thresh)))==0);
colormap(gray);
axis equal tight off xy
title('watershed segmentation');
region_cent = regionprops(double(seg_im).*double(im>quantile(im(:),...
    map_thresh)),'Centroid');
for i = 1:length(region_cent)
    tmpCoord = [region_cent(i).Centroid(1),region_cent(i).Centroid(2)];
    tmpNum = seg_im(round(tmpCoord(2)),round(tmpCoord(1)));
    if tmpNum~=0
        h = text(tmpCoord(1)+xx(1)-1,tmpCoord(2)+xx(1)-1,num2str(tmpNum));
        set(h,'color','y','fontsize',10);
    end
end

%% make representative videos for each cluster
% file parameters
timeStep = 25;
movieParamMulti = paramMulti(fileIndx);
% movieParamMulti = paramMulti_galois(testIndx(1));
for i = 1:length(fileIndx)
    movieParamMulti{i}.numImages = (acm(i+1)-acm(i))*timeStep;
end

% query data
vdata = cell2mat(emDataAll);
vdata(vdata>xx(1)+size(im,1)-1) = size(im,1)+xx(1)-1;
vdata(vdata<=xx(1)) = xx(1);
segIndx = seg_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,...
    round(vdata(:,2))-xx(1)+1));

% visualize
ifRandomize = 1;
ifSave = 0;
for i = 1:max(segIndx(:))
    visualizeResultMulti(find(segIndx==i),timeStep,movieParamMulti,...
        ifRandomize,ifSave,num2str(i));
end

%% compare with annotation, make large clusters
% compare with manual annotation
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
annoType = 5;
annoAll = annoMulti(movieParamMulti,annoPath,annoType,timeStep);
numAnnoClass = max(annoAll);
% keepIndx = annoAll~=0;
% annoAllNz = annoAll(keepIndx);

% alternative: annotation for segmented video
% annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
% segPath = 'C:\Shuting\Data\DT_results\register_param\video_seg_loc\seg_20160420\';
% annoType = 4;
% annoAll = [];
% for i = 1:length(fileIndx)
%     movieParam = paramAll(fileIndx(i));
%     annoSingle = annoSeg(movieParam,annoPath,annoType,segPath);
%     annoAll(end+1:end+length(annoSingle)) = annoSingle;
% end
% keepIndx = annoAll~=0;
% annoAllNz = annoAll(keepIndx);

% find the majority label in each region
% vdata = cell2mat(emDataAll);
vdata = emDataTrain;
% label = annoAll(intersect(indxTrain,find(keepIndx)));
vdata(vdata>xx(1)+size(im,1)-1) = size(im,1)+xx(1)-1;
vdata(vdata<=xx(1)) = xx(1);
segIndx = seg_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,...
    round(vdata(:,2))-xx(1)+1));
counts = zeros(numClass,numAnnoClass);
annoTrain = annoAll(indxTrain);
annoTest = annoAll(indxTest);
for i = 1:numClass
    counts(i,:) = histc(annoTrain(segIndx==i),...
        1:numAnnoClass)';
end
counts = counts./(sum(counts,2)*ones(1,size(counts,2)));
[perc,seg_cat] = max(counts,[],2);

% make large region segmentation
useg = unique(seg_cat);
numRegions = length(useg);
reg_im = seg_im;
for i = 1:numRegions
    crRegs = find(seg_cat==useg(i));
    for j = 1:length(crRegs)
        reg_im(seg_im==crRegs(j)) = i;
    end
end
region_im_trans = reg_im';

savepath = 'E:\galois\results\embedding\';
namestr = 'L_15_W_2_N_32_s_1_t_1_step_25_K_256_20160315_spseg3';
save([savepath infostr '_emspace.mat'],'region_im_trans','xx');

% plot large region segmentation
figure;set(gcf,'color','w')
imagesc(double(reg_im).*double(im>quantile(im(:),map_thresh)));
colormap(jet);colorbar
axis equal tight off xy

% plot distribution for training regions
cc = jet(64);
regIndx = region_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,...
    round(vdata(:,2))-xx(1)+1));
N = ceil(sqrt(numRegions));
M = ceil(numRegions/N);
figure;set(gcf,'color','w','position',[2032,809,990,117])
for i = 1:numRegions
    subplot(1,numRegions,i)
    histogram(annoTrain(regIndx==i),0.5:1:numAnnoClass+0.5,...
        'facecolor',cc(round(i/numRegions*64),:),'facealpha',1,...
        'Normalization','probability');
    title(['Class #' num2str(i)],'fontsize',12,'fontweight','bold');
    set(gca,'xtick',1:numAnnoClass);box off
    xlim([0 numAnnoClass+1]);ylim([0 1]);
end

% plot distribution for test regions
vdata = emDataTest;
vdata(vdata>xx(1)+size(im,1)-1) = size(im,1)+xx(1)-1;
vdata(vdata<=xx(1)) = xx(1);
regIndx = region_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,...
    round(vdata(:,2))-xx(1)+1));
N = ceil(sqrt(numRegions));
M = ceil(numRegions/N);
figure;set(gcf,'color','w','position',[2032,809,990,117])
for i = 1:numRegions
    subplot(1,numRegions,i)
    histogram(annoTest(regIndx==i),0.5:1:numAnnoClass+0.5,...
        'facecolor',cc(round(i/numRegions*64),:),'facealpha',1,...
        'Normalization','probability');
    title(['Class #' num2str(i)],'fontsize',12,'fontweight','bold');
    set(gca,'xtick',1:numAnnoClass);box off
    xlim([0 numAnnoClass+1]);ylim([0 1]);
end

% plot overlay region segmentation
figure;set(gcf,'color','w')
imagesc(double(reg_im).*double(im>quantile(im(:),0.5)));
colormap(jet);
axis equal tight off xy
tmp = emDataNew{1};
hold on;scatter(tmp(:,1)-xx(1)+1,tmp(:,2)-xx(1)+1,20,'k','filled')

% plot overlay region with path
figure;set(gcf,'color','w')
imagesc(double(reg_im).*double(im>quantile(im(:),0.5)));
colormap(jet);
axis equal tight off xy
tmp = emDataNew{1};
hold on;
plot(tmp(:,1)-xx(1)+1,tmp(:,2)-xx(1)+1,'k*',tmp(:,1)-xx(1)+1,...
    tmp(:,2)-xx(1)+1,'k--')

% plot distribution for small regions
N = ceil(sqrt(numClass));
M = ceil(numClass/N);
figure;set(gcf,'color','w')
for i = 1:numClass
    subplot(M,N,i)
    histogram(annoAllNz(segIndx(keepIndx(indxTrain))==i),...
        0.5:1:numAnnoClass+0.5,'Normalization','probability');
    title(['Class #' num2str(i)],'fontsize',12,'fontweight','bold');
    set(gca,'xtick',1:numAnnoClass);xlim([0 numAnnoClass+1])
end

%% analyze annotation in cluster centers only
N = ceil(sqrt(numRegions));
M = ceil(numRegions/N);
h1 = figure;
h2 = figure;
for i = 1:numRegions
    crReg = (reg_im==i).*im;
    figure(h1);subplot(M,N,i);
    imagesc(crReg);colormap(jet);axis equal tight off xy
    crIndx = find(crReg(crReg>multithresh(crReg(crReg~=0))));
    figure(h2);subplot(M,N,i)
    histogram(annoAllNz(crIndx),0.5:1:numAnnoClass+0.5,...
        'Normalization','probability');
    title(['Class #' num2str(i)],'fontsize',12,'fontweight','bold');
    set(gca,'xtick',1:numAnnoClass);xlim([0 numAnnoClass+1])
end

% or shrink each region before comparing with annotations
N = ceil(sqrt(numRegions));
M = ceil(numRegions/N);
h1 = figure;
h2 = figure;
for i = 1:numRegions
    crReg = (reg_im==i).*im;
    crReg = imerode(crReg,strel('disk',3));
    figure(h1);subplot(M,N,i);
    imagesc(crReg);colormap(jet);axis equal tight off xy
    crIndx = find(crReg(crReg>multithresh(crReg(crReg~=0))));
    figure(h2);subplot(M,N,i)
    histogram(annoAllNz(crIndx),0.5:1:numAnnoClass+0.5,...
        'Normalization','probability');
    title(['Class #' num2str(i)],'fontsize',12,'fontweight','bold');
    set(gca,'xtick',1:numAnnoClass);xlim([0 numAnnoClass+1])
end

%% plot annotation density
densAnno = zeros(numPoints,numPoints,numAnnoClass);
emDataMat = emDataTrain;
for i = 1:numAnnoClass
    [~,densAnno(:,:,i)] = findPointDensity(emDataMat(label==i,:),sigma,...
        numPoints,rangeVals);
end

% plot
figure;set(gcf,'color','w')
N = ceil(sqrt(numAnnoClass));
M = ceil(numAnnoClass/N);
maxDensityAnno = max(densAnno(:));
for i = 1:numAnnoClass
    subplot(M,N,i)
    imagesc(xx,xx,densAnno(:,:,i))
    axis equal tight off xy
    caxis([0 maxDensityAnno*0.8])
    colormap(jet)
    title([num2str(i) '. ' annoInfo(annoType,i)],'fontsize',12,'fontweight','bold');
end

%% evaluate segmentated clusters with new samples
newRegCount = zeros(numRegions,numAnnoClass+1);
for qIndx = 1:length(testIndx);

    % data to analyze
    vdata = cell2mat(emDataNew(qIndx));
    vdata(vdata>xx(1)+size(im,1)-1) = size(im,1)+xx(1)-1;
    vdata(vdata<=xx(1)) = xx(1);
    % segIndx = seg_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,...
    %     round(vdata(:,2))-xx(1)+1));
    regIndx = region_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,...
        round(vdata(:,2))-xx(1)+1));

    % annotation
    annoAll = annoMulti(paramMulti(testIndx(qIndx)),annoPath,annoType,timeStep);
    for i = 1:numRegions
        newRegCount(i,:) = newRegCount(i,:)+reshape(histc(annoAll(regIndx==i),...
            0.5:1:numAnnoClass+0.5),1,numAnnoClass+1);
    end

end
newRegCount = newRegCount(:,1:end-1);
newRegCount = newRegCount./(sum(newRegCount,2)*ones(1,size(newRegCount,2)));

% plot distribution for large regions
numRegions = length(unique(reg_im))-1;
N = ceil(sqrt(numRegions));
M = ceil(numRegions/N);
figure;set(gcf,'color','w','position',[2032,809,990,117])
for i = 1:numRegions
    subplot(1,numRegions,i)
    bar(1:numAnnoClass,newRegCount(i,:),1,'edgecolor','k',...
        'facecolor',cc(round(i/numRegions*64),:));
    title(['Class #' num2str(i)],'fontsize',12,'fontweight','bold');
    set(gca,'xtick',1:numAnnoClass);box off
    xlim([0 numAnnoClass+1]);ylim([0 1]);
end

% % plot overall class distribution
% figure;set(gcf,'color','w');
% axislim = max(double(regIndx));
% histogram(regIndx,0.5:1:axislim+0.5,'Normalization','probability');
% xlabel('Class');ylabel('percentage');box off
% set(gca,'xtick',1:axislim);xlim([0 axislim+1]);
% 
% % visualize video samples
% qlabel = 1;
% figure;imagesc((reg_im==qlabel).*im);
% caxis([min(densAll(:)),max(densAll(:))]);colormap(jet);
% axis equal tight off xy
% % visualizeResultMulti_galois(find(segIndx==qlabel),timeStep,movieParamMulti,1,0,'');
% visualizeResultMulti(find(regIndx==qlabel),timeStep,movieParamMulti,1,1,num2str(qlabel));


%% evaluate segmentated clusters - with action segmentation
% query index
for qIndx = 1:length(testIndx);

% data to analyze
vdata = cell2mat(emDataNew(qIndx));
vdata(vdata>xx(1)+size(im,1)-1) = size(im,1)+xx(1)-1;
vdata(vdata<=xx(1)) = xx(1);
segIndx = seg_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,...
    round(vdata(:,2))-xx(1)+1));
regIndx = region_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,...
    round(vdata(:,2))-xx(1)+1));

% annotation
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
segPath = 'C:\Shuting\Data\DT_results\register_param\video_seg_loc\seg_20160413\';
annoType = 6;
movieParam = paramAll(testIndx(qIndx));
annoSingle = annoSeg(movieParam,annoPath,annoType,segPath);
keepIndx = annoSingle~=0;
annoSingleNz = annoSingle(keepIndx);

% plot distribution for large regions
numRegions = length(unique(reg_im))-1;
N = ceil(sqrt(numRegions));
M = ceil(numRegions/N);
figure;set(gcf,'color','w')
for i = 1:numRegions
    subplot(M,N,i)
    histogram(annoSingleNz(regIndx(keepIndx)==i),0.5:1:max(annoSingle)+0.5,...
        'Normalization','probability');
    title(['Class #' num2str(i)],'fontsize',12,'fontweight','bold');
    set(gca,'xtick',1:max(annoSingle));xlim([0 max(annoSingle)+1]);ylim([0 1]);
end

% % plot overall class distribution
% figure;set(gcf,'color','w');
% axislim = max(double(regIndx));
% histogram(regIndx,0.5:1:axislim+0.5,'Normalization','probability');
% xlabel('Class');ylabel('percentage');box off
% set(gca,'xtick',1:axislim);xlim([0 axislim+1]);

% visualize video samples
% qlabel = 1;
% figure;imagesc((reg_im==qlabel).*im);
% caxis([min(densAll(:)),max(densAll(:))]);colormap(jet);
% axis equal tight off xy
% 

% load([segPath movieParam.fileName '_seg_loc.mat']);
% qlabel = 9; % region to visualize
% clusterIndx = find(regIndx==qlabel);
% for j = 1:length(clusterIndx)
%     playVideo(locs(clusterIndx(j)):locs(clusterIndx(j)+1)-1,movieParam,1,0.01,0);
% end
% visualizeResultMulti(find(regIndx==qlabel),timeStep,movieParamMulti,1,1,num2str(qlabel));

end
