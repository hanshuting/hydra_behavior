%% general parameters
m = 2;
n = 3;
step = 2;
tw = 5;
numCluster1 = 200;

%% set parameters for the reference video

movieParam.filenameTracks = '/vega/brain/users/sh3276/20141110_GFP_tracking_original/20141110_GFP_tracking.txt';
movieParam.filenameImages = '/vega/brain/users/sh3276/20141110_GFP_tracking_original/';
movieParam.filenameBasis = '20141110_GFP_tracking_original';
movieParam.frameStart = 0; %number of first image in movie
movieParam.frameEnd = 2499; %number of last image in movie
movieParam.digitNum = 4; %number of digits used for frame enumeration (1-4).
movieParam.numImages = movieParam.frameEnd-movieParam.frameStart+1;

% store tiff file names
movieParam.enumString = repmat('0',movieParam.numImages,movieParam.digitNum);
formatString = ['%0' num2str(movieParam.digitNum) 'i'];
for i = 1:movieParam.numImages
    movieParam.enumString(i,:) = num2str(i-1,formatString);
end

% read the first image and get movie information
imageRaw = double(imread([movieParam.filenameImages movieParam.filenameBasis...
    movieParam.enumString(1,:) '.tif']));
movieParam.imageSize = size(imageRaw);

hydraParam=estimateHydraParam(movieParam);

%% calculate histograms for the reference video

tracksAll=processTracks(movieParam,hydraParam,m,n,step);
[trackVelBatch,trackLocBatch] = extractTrackBatchStep(tracksAll,m,n,tw);
[flowsAll,flowInd] = getFlows(trackVelBatch,0);
keepInd = (sum(flowsAll==0,2)==0&sum(isnan(flowsAll),2)==0);
flowsAll = flowsAll(keepInd,:);
flowInd = flowInd(keepInd,:);
[rawInd,rawCenters] = kmeans(flowsAll,numCluster1,'replicate',3);
histAll = getCenterHist(flowsAll,flowInd,rawInd,rawCenters,m,n,'kcb_exp');

%% set parameters for the new video

%movieParam2.filenameTracks = '/vega/brain/users/sh3276/20141110_GFP_2_2_1_2500/20141110_GFP_2_2_1_2500_tracking.txt';
%movieParam2.filenameImages = '/vega/brain/users/sh3276/20141110_GFP_2_2_1_2500/';
%movieParam2.filenameBasis = '20141110_GFP_2_2_1_2500_';
movieParam2.filenameTracks = '/vega/brain/users/sh3276/20141110_GFP_tracking_original/20141110_GFP_tracking.txt';
movieParam2.filenameImages = '/vega/brain/users/sh3276/20141110_GFP_tracking_original/';
movieParam2.filenameBasis = '20141110_GFP_tracking_original';

movieParam2.frameStart = 0; %number of first image in movie
movieParam2.frameEnd = 50; %number of last image in movie
movieParam2.digitNum = 4; %number of digits used for frame enumeration (1-4).
movieParam2.numImages = movieParam2.frameEnd-movieParam2.frameStart+1;

% store tiff file names
movieParam2.enumString = repmat('0',movieParam2.numImages,movieParam2.digitNum);
formatString = ['%0' num2str(movieParam2.digitNum) 'i'];
for i = 1:movieParam2.numImages
    movieParam2.enumString(i,:) = num2str(i-1,formatString);
end

% read the first image and get movie information
imageRaw = double(imread([movieParam2.filenameImages movieParam2.filenameBasis...
    movieParam2.enumString(1,:) '.tif']));
movieParam2.imageSize = size(imageRaw);

%hydraParam2 = estimateHydraParam(movieParam2);

%% calculate pairwise distances
tracksAll = processTracks(movieParam,hydraParam,m,n,step);
dists = slidePatterns(m,n,step,tw,histAll,rawCenters,movieParam2,hydraParam2);

save('/vega/brain/users/sh3276/results/patterns_test.mat');
