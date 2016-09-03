function [hofAll,hogAll,mbhxAll,mbhyAll] = extractDT_galois(fileIndx,filepath,timeStep,nolen,trackLength,sampleStride,N,nxy,nt)
% Extract dense trajectory features from DT output file
% SYNOPSIS:
%     [hofAll,hogAll,mbhxAll,mbhyAll] = extractDT(fileindx,timeStep)
% INPUT:
%     fileIndx: index of the file to be processed, one at a time (see fileinfo.m)
%     filepath: path of input files
%     timeStep: output time window size
%     nolen: maximum non-overlapping length of trajectory in a time window
% OUTPUT:
%     hofAll: a N-by-1 cell array, each cell contains the matrix of HOF
%       features in the time window. N is the number of total time windows
%     hogAll: a N-by-1 cell array with HOG features
%     mbhxAll: a N-by-1 cell array with MBHx features
%     mbhyAll: a N-by-1 cell array with MBHy features
% 
% Shuting Han, 2015

movieParam = paramAll_galois(fileIndx);
infostr = ['_L_' num2str(trackLength) '_W_' num2str(sampleStride) '_N_' num2str(N) '_s_' num2str(nxy) '_t_' num2str(nt)];
numPatch = nxy*nxy*nt;
sFlow = 2*trackLength;
sHof = 9*nxy*nxy*nt;
sHog = 8*nxy*nxy*nt;
sMbh = 8*nxy*nxy*nt;

% read file
dt_features = dlmread([filepath movieParam.fileName infostr '.txt'],'\t',2,0);

% initialize
numtw = floor(movieParam.numImages/timeStep);
hofAll = cell(numtw,numPatch);
hogAll = cell(numtw,numPatch);
mbhxAll = cell(numtw,numPatch);
mbhyAll = cell(numtw,numPatch);

% pull out track features in each time window
% marklist = zeros(size(dt_features,1),1);
for i = 1:numtw
    
    % index of tracks in the current time window
    crIndx = (dt_features(:,1) <= (i*timeStep+nolen)) & ...
        (dt_features(:,1)-trackLength >= ((i-1)*timeStep-nolen));
%     marklist(crIndx) = 1;
    
    if sum(crIndx)==0
        crHof = nan(1,sHof);
        crHog = nan(1,sHog);
        crMbhx = nan(1,sMbh);
        crMbhy = nan(1,sMbh);
    else

        % get descriptors
        crHog = dt_features(crIndx,11+sFlow:10+sFlow+sHog);
        crHog = crHog(~any(isnan(crHog),2),:);
    
        crHof = dt_features(crIndx,11+sFlow+sHog:10+sFlow+sHog+sHof);
        crHof = crHof(~any(isnan(crHof),2),:);
    
        crMbhx = dt_features(crIndx,11+sFlow+sHof+sHog:10+sFlow+sHof+sHog+sMbh);
        crMbhx = crMbhx(~any(isnan(crMbhx),2),:);
    
        crMbhy = dt_features(crIndx,11+sFlow+sHof+sHog+sMbh:10+sFlow+sHof+sHog+sMbh*2);
        crMbhy = crMbhy(~any(isnan(crMbhy),2),:);
        
    end
    
    % save spatial-temporal patches
    for j = 1:numPatch
        hofAll{i,j} = single(crHof(:,(j-1)*9+1:j*9));
        hogAll{i,j} = single(crHog(:,(j-1)*8+1:j*8));
        mbhxAll{i,j} = single(crMbhx(:,(j-1)*8+1:j*8));
        mbhyAll{i,j} = single(crMbhy(:,(j-1)*8+1:j*8));
    end
    
end

end
