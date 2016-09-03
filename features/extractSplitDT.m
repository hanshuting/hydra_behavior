function [hofAll,hogAll,mbhxAll,mbhyAll] = extractSplitDT(movieParam,trackLength,timeStep)
% Extract the descriptors from Dense Trajectory code, and store them in
% cell arrays for codebook generation later.
% SYNOPSIS:
%     [hofAll,hogAll,mbhxAll,mbhyAll] = extractDT(movieParam,
%       trackLength,timeStep)
% INPUT:
%     movieParam: a struct returned by function paramAll
%     trackLength: length of flows
%     timeStep: number of frames in each video clip
% OUTPUT:
%     hofAll, hogAll, mbhxAll, mbhyAll: numVideo-by-1 cell arrays, each
%       cell contains the descriptors from the time window
% 
% Shuting Han, 2015

% file information
trackInfo = dir([movieParam.trackPath '*.txt']);
% numVideo = floor(movieParam.numImages/timeStep);
numVideo = length(trackInfo);

% DT feature information
nxy = 2;
nt = 3;
sFlow = 2*trackLength;
sHof = 8*nxy*nxy*nt;
sHog = 9*nxy*nxy*nt;
sMbh = 8*nxy*nxy*nt;

% initialization
hofAll = cell(numVideo,1);
hogAll = cell(numVideo,1);
mbhxAll = cell(numVideo,1);
mbhyAll = cell(numVideo,1);

% exclude the error information in the first two lines
for i = 1:numVideo
    
    % if file empty, put NaN
    if trackInfo(i).bytes==124
        
        fprintf('feature file is empty: %s\n',trackInfo(i).name);
        hofAll{i} = nan(1,sHof);
        hogAll{i} = nan(1,sHog);
        mbhxAll{i} = nan(1,sMbh);
        mbhyAll{i} = nan(1,sMbh);
        
    else
        
        % read txt file
        dt_features = dlmread([movieParam.trackPath trackInfo(i).name],'\t',2,0);
        
        % save HOF
        crHof = dt_features(:,11+sFlow:10+sFlow+sHof);
        crHof = crHof(~any(isnan(crHof),2),:);
        hofAll{i} = single(crHof);
    
        % save HOG
        crHog = dt_features(:,11+sFlow+sHof:10+sFlow+sHof+sHog);
        crHog = crHog(~any(isnan(crHog),2),:);
        hogAll{i} = single(crHog);
        
        % save MBHx
        crMbhx = dt_features(:,11+sFlow+sHof+sHog:10+sFlow+sHof+sHog+sMbh);
        crMbhx = crMbhx(~any(isnan(crMbhx),2),:);
        mbhxAll{i} = single(crMbhx);
        
        % save MBHy
        crMbhy = dt_features(:,11+sFlow+sHof+sHog+sMbh:10+sFlow+sHof+sHog+sMbh*2);
        crMbhy = crMbhy(~any(isnan(crMbhy),2),:);
        mbhyAll{i} = single(crMbhy);
    
    end
    
end


end