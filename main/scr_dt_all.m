
% set parameters
fileindx = [1:11,13];
savepath = 'C:\Shuting\Data\freely_moving\individual_samples\DT_features\';
% video_size = 5; % in seconds
timeStep = 25;
trackThresh = 0.5;
trackLength = 25;
sampleStride = 5;

numCenters = 1000;

%% assemble results
for i = 1:length(fileindx)
    
    movieParam = paramAll(i);
    movieParam.trackPath = 'C:\Shuting\Data\freely_moving\individual_samples\DT_features\20150218_light_1_5hz_resized_1s_0.5_L_4_W_5\';

    % load features
    [hofAll,hogAll,mbhxAll,mbhyAll] = extractDT(movieParam,trackLength,timeStep);

    % save features
    savename = [savepath movieParam.fileName '_' num2str(video_size) 's_' num2str(trackThresh)...
        '_L_' num2str(trackLength) '_W_' num2str(sampleStride) '_'];
    save([savename 'hof.mat'],'hofAll','-v7.3')
    save([savename 'hog.mat'],'hogAll','-v7.3')
    save([savename 'mbhx.mat'],'mbhxAll','-v7.3')
    save([savename 'mbhy.mat'],'mbhyAll','-v7.3')
    
end

%% % codebook
% flowCenters = gnCdbk(flowAll,numCenters);
% histFlow = assignMaskedCenters(flowAll,flowCenters,'exp');
% fprintf('flow codebook done\n');
% 
% hofCenters = gnCdbk(hofAll,numCenters);
% histHofCenters = assignMaskedCenters(hofAll,hofCenters,'exp');
% fprintf('hof codebook done\n');
% 
% hogCenters = gnCdbk(hogAll,numCenters);
% histHogCenters = assignMaskedCenters(hogAll,hogCenters,'exp');
% fprintf('hog codebook done\n');
% 
% mbhxCenters = gnCdbk(mbhxAll,numCenters);
% histMbhxCenters = assignMaskedCenters(mbhxAll,mbhxCenters,'exp');
% fprintf('mbhx codebook done\n');
% 
% mbhyCenters = gnCdbk(mbhyAll,numCenters);
% histMbhyCenters = assignMaskedCenters(mbhyAll,mbhyCenters,'exp');
% fprintf('mbhy codebook done\n');
% 
% save('C:\Shuting\Data\results\20141110_GFP_Tracking_original_resized_DT_kmeans','histFlow','histHofCenters','histHogCenters','histMbhxCenters','histMbhyCenters','flowCenters','hofCenters','hogCenters','mbhxCenters','mbhyCenters','-v7.3')

%% load results
% set parameters
video_size = 10;
trackThresh = 0;
trackLength = 49;
sampleStride = 5;

movieParam = paramAllDT(1);
timeStep = video_size*movieParam.fr;

filename = ['C:\Shuting\Data\freely_moving\individual_samples\DT_features\results\' ...
    movieParam.fileName '_' num2str(video_size) 's_' num2str(trackThresh)...
    '_L_' num2str(trackLength) '_W_' num2str(sampleStride) '_'];
%load([filename 'histFlow.mat']);
load([filename 'histHof.mat']);
load([filename 'histHog.mat']);
load([filename 'histMbhx.mat']);
load([filename 'histMbhy.mat']);

%% clustering
chi_square = @(P,Q) nansum((ones(size(Q,1),1)*P-Q).^2./...
    (2*(ones(size(Q,1),1)*P+Q)),2);

histAll = [histHofCenters,histHogCenters,histMbhxCenters,histMbhyCenters]/4;
distHistAll = pdist2(histAll,histAll,@(P,Q) chi_square(P,Q));
simHistAll = 1-distHistAll/max(distHistAll(:));
figure;set(gcf,'color','w');imagesc(simHistAll);colorbar;

% kmeans
numCluster = 5;
drHistAll = drHist(histAll,95);
[indAll,ccenters] = kmeans(drHistAll,numCluster,'replicate',3,...
    'emptyaction','drop');

% AP clustering
indAll = apcluster(simHistAll,median(simHistAll));
%indAll = apcluster(simHistAll,min(simHistAll(:))-1*(max(simHistAll(:))-min(simHistAll(:))));

%% svm
setSeed(0);
annoRaw = annoMulti({movieParam},timeStep,0);
annoAll = mergeAnno(annoRaw,1);
keepInd = annoAll~=0;
numCubes = sum(keepInd);
sample = drHistAll(keepInd);
label = annoAll(keepInd);
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
svm_param_grid(labelTraining,sample(indxTraining,:),'one-vs-one');
svmParam11 = '-t 2 -b 1 -q -c 10 -g 10';
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




