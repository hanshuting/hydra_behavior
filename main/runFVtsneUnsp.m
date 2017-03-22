function [] = runFVtsneUnsp(param,tsne_param)
% run tsne embedding on FVs in an unsupervised way (no true label, no
% training/test sets, just embed all data)

filepath = param.fvpath;
infostr = param.infostr;
fileIndx = param.fileIndx;
numFiles = length(fileIndx);
keepDim = tsne_param.keepDim;

%% load data
dataAll = cell(numFiles,1);
for ii = 1:numFiles
    load([filepath fileinfo(fileIndx(ii)) '_' infostr '_drFVall.mat']);
    dataAll{ii} = drFVall(:,1:keepDim);
end

data = cell2mat(dataAll);

%% generate embedding map on training data
% distance matrix
fprintf('calculating distance...\n');
D = calcMatDist(data,tsne_param.distType);

% run t-sne
fprintf('embedding training data...\n');
[emData,betas,P,errors] = tsne_d_sparse(D,tsne_param);

%% generate embedding map on each individual
fprintf('embedding all data...\n');
emDataAll = cell(numFiles,1);
for ii = 1:numFiles
    fprintf('processing file %u...\n',ii);
    [emDataAll{ii},~] = findEmbedding(dataAll{ii},data,emData,tsne_param);
end

%% make density plots
% center data
mu = mean(cell2mat(emDataAll),1);
emDataAllCent = cellfun(@(x) x-ones(size(x,1),1)*mu,emDataAll,'uniformoutput',false);

maxVal = max(max(cell2mat(emDataAllCent)));
maxVal = round(maxVal * 1.1);

% these are parameters to adjust
sigma = maxVal/60; % default 40
numPoints = 501;
rangeVals = [-maxVal maxVal];

% generate plot with data
[xx,densAll] = findPointDensity(cell2mat(emDataAllCent),sigma,numPoints,rangeVals);

% generate plot for individual samples
numFiles = size(emDataAllCent,1);
densIndiv = zeros(numPoints,numPoints,numFiles);
for ii = 1:numFiles
    [~,densIndiv(:,:,ii)] = findPointDensity(emDataAllCent{ii},sigma,numPoints,rangeVals);
end

% 
im = densAll;
map_thresh = 0.4;
im_mask = im>quantile(im(:),map_thresh);

%% plot overall, training, test density
cmax = max(densAll(:))*0.8;
figure;set(gcf,'color','w')
plotTsneDens(xx,densAll,im_mask,cmax); title('all embedding'); colorbar('off')

% plot individual plot
% figure;set(gcf,'color','w')
% N = ceil(sqrt(numFiles));
% M = ceil(numFiles/N);
% for ii = 1:numFiles
%     subplot(M,N,ii)
%     plotTsneDens(xx,densIndiv(:,:,ii),im_mask,20*cmax)
%     title(['Data Set #' num2str(ii)],'fontsize',8); %,'fontweight','bold');
%     if ii~=numFiles
%         colorbar('off');
%     end
% end

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

%% plot density and segmentation
figure;set(gcf,'color','w')
scatter(emData(:,1),emData(:,2),'.');
xlim([xx(1) xx(end)]);ylim([xx(1) xx(end)])
axis equal tight

figure;set(gcf,'color','w')
subplot(1,3,1)
title('tSNE density')
plotTsneDens(xx,im,im_mask,cmax)
subplot(1,3,2)
plotTsneDens(xx,im.*(~seg_bound),im_mask,cmax)
title('watershed segmentation');
subplot(1,3,3)
plotRegionLabel(xx,seg_im,im_mask)
title('watershed segmentation')


%% visualize video samples
% plot each region separately
num_seg = length(setdiff(unique(seg_im(:)),0));
figure; set(gcf,'color','w')
N = ceil(sqrt(num_seg));
M = ceil(num_seg/N);
A = double(seg_im~=0);
A(im_mask==0) = -1;
for ii = 1:num_seg
    subplottight(M,N,ii); hold on
    imagesc(xx,xx,2-A);
    B = -1*double(seg_im==ii);
    B(B==0|im_mask==0) = NaN;
    pcolor(xx,xx,B); shading flat
    colormap(gca,gray);
    caxis([-1 2])
    axis equal tight off xy
    text(xx(1)+10,xx(end)-10,num2str(ii))
end

% convert sample to region index
vdata = emData;
vdata = round((vdata/maxVal*numPoints+numPoints)/2);
vdata(vdata<=0) = 1;
vdata(vdata>=numPoints) = numPoints;
segIndx = seg_im_trans(sub2ind(size(im),vdata(:,1),vdata(:,2)));

% make video for each region
dpath = 'F:\Data Timelapse Chris\20160613-18 time lapse WT\processed\';
movieParamMulti = paramMulti(dpath,param.fileIndx);
for ii = 1:num_seg;
    % visualizeResultMulti_galois(find(segIndx==qlabel),timeStep,movieParamMulti,1,0,'');
    visualizeResultMulti(find(segIndx==ii),param.timeStep,movieParamMulti,...
        1,1,num2str(ii));
end

%% save results
save([param.tsnepath param.infostr '_' param.datastr...
    '_unsp_workspace.mat'],'-v7.3');

end

