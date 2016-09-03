% script for analyzing embedding results

%% make density plot
% center data
mu = mean(cell2mat(emDataAll),1);
emDataAllCent = cellfun(@(x) x-ones(size(x,1),1)*mu,emDataAll,'uniformoutput',false);
emDataNewCent = cellfun(@(x) x-ones(size(x,1),1)*mu,emDataNew,'uniformoutput',false);
emDataTrainCent = emDataTrain-ones(size(emDataTrain,1),1)*mu;
emDataTestCent = emDataTest-ones(size(emDataTest,1),1)*mu;

maxVal = max(max(cell2mat(emDataAllCent)));
maxVal = round(maxVal * 1.1);

% these are parameters to adjust
sigma = maxVal/50;
numPoints = 501;
rangeVals = [-maxVal maxVal];

% generate plot with all data
[xx,densAll] = findPointDensity(cell2mat(emDataAllCent),sigma,numPoints,rangeVals);

% training data
[~,densTrain] = findPointDensity(emDataTrainCent,sigma,numPoints,rangeVals);

% test data
[~,densTest] = findPointDensity(emDataTestCent,sigma,numPoints,rangeVals);

% generate plot for individual samples
numFiles = size(emDataAllCent,1);
densIndiv = zeros(numPoints,numPoints,numFiles);
for i = 1:numFiles
    [~,densIndiv(:,:,i)] = findPointDensity(emDataAllCent{i},sigma,numPoints,rangeVals);
end

% generate plot for new samples
densNew = zeros(numPoints,numPoints,length(emDataNewCent));
for i = 1:length(emDataNewCent)
    [~,densNew(:,:,i)] = findPointDensity(emDataNewCent{i},sigma,numPoints,rangeVals);
end

% plot scatter
figure;set(gcf,'color','w')
emCoordAll = cell2mat(emDataAllCent);
gscatter(emCoordAll(:,1),emCoordAll(:,2),label);
axis equal tight
xlim([-maxVal maxVal])
ylim([-maxVal maxVal])

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
    pos = get(gca,'position');
    set(gca,'position',pos.*[1 1 1.2 1.2])
    axis equal tight off xy
    caxis([0 maxDensity*0.3])
    colormap(jet)
    title(['Data Set #' num2str(i)],'fontsize',8);%,'fontweight','bold');
end

% new samples
for i = 1:length(emDataNew)
    figure;set(gcf,'color','w')
    imagesc(xx,xx,densNew(:,:,i))
    axis equal tight off xy
    caxis([0 maxDensity*0.3])
    colormap(jet);colorbar
    title(['New Data Set #' num2str(i)],'fontsize',12,'fontweight','bold');
end

%% segment density plot
% im = mat2gray(imresize(densTrain,[max(xx)-min(xx),max(xx)-min(xx)]));
im = densTrain;
map_thresh = 0.5;

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
    if isnan(tmpCoord(1))
        continue;
    end
    tmpNum = seg_im(round(tmpCoord(2)),round(tmpCoord(1)));
    if tmpNum~=0
%         h = text(tmpCoord(1)+xx(1)-1,tmpCoord(2)+xx(1)-1,num2str(tmpNum));
        h = text(double(2*maxVal*(tmpCoord(1)-numPoints/2)/numPoints),...
            double(2*maxVal*(tmpCoord(2)-numPoints/2)/numPoints),num2str(tmpNum));
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
vdata = cell2mat(emDataAllCent);
vdata = round((vdata/maxVal*numPoints+numPoints)/2);
vdata(vdata<=0) = 1;
vdata(vdata>=numPoints) = numPoints;
segIndx = seg_im_trans(sub2ind(size(im),vdata(:,1),vdata(:,2)));

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
annoType = 8;
annoAll = annoMulti(movieParamMulti,annoPath,annoType,timeStep);
numAnnoClass = max(annoAll);
% annoTrain = labelTrain;
% annoTest = labelTest;
annoTrain = annoAll(indxTrain);
annoTest = annoAll(indxTest);

% find the majority label in each region
vdata = emDataTrainCent;
vdata = round((vdata/maxVal*numPoints+numPoints)/2);
vdata(vdata<=0) = 1;
vdata(vdata>=numPoints) = numPoints;
segIndx = seg_im_trans(sub2ind(size(im),vdata(:,1),vdata(:,2)));
counts = zeros(numClass,numAnnoClass);
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

% plot large region segmentation
figure;set(gcf,'color','w')
imagesc(double(reg_im).*double(im>quantile(im(:),map_thresh)));
colormap(jet);colorbar
axis equal tight off xy

% plot distribution for training regions
cc = jet(64);
% regIndx = region_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,...
%     round(vdata(:,2))-xx(1)+1));
regIndx = region_im_trans(sub2ind(size(im),vdata(:,1),vdata(:,2)));
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
vdata = emDataTestCent;
vdata = round((vdata/maxVal*numPoints+numPoints)/2);
vdata(vdata<=0) = 1;
vdata(vdata>=numPoints) = numPoints;
% regIndx = region_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,...
%     round(vdata(:,2))-xx(1)+1));
regIndx = region_im_trans(sub2ind(size(im),vdata(:,1),vdata(:,2)));
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


%% plot annotation density
numAnnoClass = max(annoAll);
densAnno = zeros(numPoints,numPoints,numAnnoClass);
emDataMat = emDataTrainCent;
for i = 1:numAnnoClass
    [~,densAnno(:,:,i)] = findPointDensity(emDataMat(annoTrain==i,:),sigma,...
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
    vdata = cell2mat(emDataNewCent(qIndx));
%     vdata(vdata>xx(1)+size(im,1)-1) = size(im,1)+xx(1)-1;
%     vdata(vdata<=xx(1)) = xx(1);
%     regIndx = region_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,...
%         round(vdata(:,2))-xx(1)+1));
    vdata = round((vdata/maxVal*numPoints+numPoints)/2);
    vdata(vdata<=0) = 1;
    vdata(vdata>=numPoints) = numPoints;
    regIndx = region_im_trans(sub2ind(size(im),vdata(:,1),vdata(:,2)));
    
    % annotation
    annoAll = annoMulti(paramMulti(testIndx(qIndx)),annoPath,annoType,timeStep);
    for i = 1:numRegions
        newRegCount(i,:) = newRegCount(i,:)+reshape(histc(annoAll(regIndx==i),...
            0.5:1:numAnnoClass+0.5),1,numAnnoClass+1);
    end

end
newRegCount = newRegCount(:,1:end-1);
newRegCount = newRegCount./(sum(newRegCount,2)*ones(1,size(newRegCount,2)));

% plot all samples distribution for large regions
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


% % visualize video samples
% qlabel = 1;
% figure;imagesc((reg_im==qlabel).*im);
% caxis([min(densAll(:)),max(densAll(:))]);colormap(jet);
% axis equal tight off xy
% % visualizeResultMulti_galois(find(segIndx==qlabel),timeStep,movieParamMulti,1,0,'');
% visualizeResultMulti(find(regIndx==qlabel),timeStep,movieParamMulti,1,1,num2str(qlabel));

%% save results
savepath = 'E:\galois\results\';
namestr = 'L_15_W_2_N_32_s_1_t_1_step_25_K_256_20160315_spseg3';
save([savepath namestr '_emspace.mat'],'region_im_trans','xx','parameters');

