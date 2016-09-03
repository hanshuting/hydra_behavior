% visualize clustering results
% assume the variables acm, indAll, and the embedding space emDataTrain, 
% xx, signa, rangeVal are loaded

fileIndx = [1:5,7:11,13:28,30:31];

%% merge clusters by annotation
% true labels
timeStep = 25;
annoType = 4;
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
movieParamMulti = paramMulti(fileIndx);
for i = 1:length(fileIndx)
    movieParamMulti{i}.numImages = (acm(i+1)-acm(i))*timeStep;
end
annoRaw = annoMulti(movieParamMulti,annoPath,timeStep,0);
annoAll = mergeAnno(annoRaw,annoType);

% compare clustering results with manual labels
indxLabel = unique(indAll);
[acr,prc] = evaluateClusters(indAll,annoAll(indxTrain));
[~,mergeIndx] = max(acr,[],2);
mergeLabel = unique(mergeIndx);
indAllMerged = zeros(size(indAll));
for i = 1:length(mergeLabel)
    mergeCluster = find(mergeIndx==mergeLabel(i));
    for j = 1:length(mergeCluster)
        indAllMerged(indAll==indxLabel(mergeCluster(j))) = i;
    end
end

%% calculate density for each cluster
maxVal = max(max(cell2mat(emDataAll)));
maxVal = round(maxVal * 1.1);

% these are parameters to adjust
sigma = maxVal/40;
numPoints = 501;
rangeVals = [-maxVal maxVal];

[xx,densTrain] = findPointDensity(emDataTrain,sigma,numPoints,rangeVals);
thresh = multithresh(densTrain,2);
bw = densTrain>thresh(1);

% make cluster density plot
fgauss = fspecial('gaussian',ceil(numPoints/10),ceil(numPoints/50));
numCluster = length(mergeLabel);
densCluster = zeros(numPoints,numPoints,numCluster);
smDensCluster = zeros(numPoints,numPoints,numCluster);
for i = 1:numCluster
    [~,densCluster(:,:,i)] = findPointDensity(emDataTrain(indAllMerged==i,:),...
        sigma,numPoints,rangeVals);
    smDensCluster(:,:,i) = imfilter(densCluster(:,:,i),fgauss);
end

% take maximum density cluster
[~,clusterReg] = max(smDensCluster,[],3);

% plot
figure;set(gcf,'color','w')
imagesc(clusterReg.*bw);
colormap(jet);
axis equal tight off xy

%% plot in embedding space
figure;set(gcf,'color','w')
imagesc(densAllrsz);
colormap(jet);
axis equal tight off xy
hold on;
for i = 1:length(mergeLabel)
    scatter(emDataTrain(indAllMerged==i,1)-xx(1)+1,...
        emDataTrain(indAllMerged==i,2)-xx(1)+1,'.');
end

