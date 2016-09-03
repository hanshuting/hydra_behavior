function [trajAll,hofAll,hogAll,mbhxAll,mbhyAll,coordALl] = extractDT...
    (movieParam,filepath,L,W,nxy,nt,numRegion,timeStep,nolen)
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

% DT parameters
numPatch = nxy*nxy*nt;
sTraj = 2*L;
sCoord = 2*L;
sHof = 9*numPatch;
sHog = 8*numPatch;
sMbh = 8*numPatch;
ltraj = floor(2*L/numPatch);
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_'...
    num2str(nxy) '_t_' num2str(nt)];

sFlow = 2*L;
sHof = 8*nxy*nxy*nt;
sHog = 9*nxy*nxy*nt;
sMbh = 8*nxy*nxy*nt;

% read file
dt_features = dlmread([filepath movieParam.fileName infostr '.txt'],'\t',2,0);

% initialize
numtw = floor(movieParam.numImages/timeStep);
hofAll = cell(numtw,1);
hogAll = cell(numtw,1);
mbhxAll = cell(numtw,1);
mbhyAll = cell(numtw,1);

% pull out track features in each time window
% marklist = zeros(size(dt_features,1),1);
for i = 1:numtw
    
    % index of tracks in the current time window
    crIndx = (dt_features(:,1) < (i*timeStep+nolen)) & ...
        (dt_features(:,1)-L > ((i-1)*timeStep-nolen));
%     marklist(crIndx) = 1;
    
    % save HOF
    crHof = dt_features(crIndx,11+sFlow:10+sFlow+sHof);
    crHof = crHof(~any(isnan(crHof),2),:);
    hofAll{i} = single(crHof);
    
    % save HOG
    crHog = dt_features(crIndx,11+sFlow+sHof:10+sFlow+sHof+sHog);
    crHog = crHog(~any(isnan(crHog),2),:);
    hogAll{i} = single(crHog);
    
    % save MBHx
    crMbhx = dt_features(crIndx,11+sFlow+sHof+sHog:10+sFlow+sHof+sHog+sMbh);
    crMbhx = crMbhx(~any(isnan(crMbhx),2),:);
    mbhxAll{i} = single(crMbhx);
    
    % save MBHy
    crMbhy = dt_features(crIndx,11+sFlow+sHof+sHog+sMbh:10+sFlow+sHof+sHog+sMbh*2);
    crMbhy = crMbhy(~any(isnan(crMbhy),2),:);
    mbhyAll{i} = single(crMbhy);
    
end

end