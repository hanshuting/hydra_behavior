function [desc] = extractAllTwDT(movieParam,...
    filepath,L,nxy,nt,W,N,chunkLen,track_thresh)
% [flows,hofAll,hogAll,mbhxAll,mbhyAll] = extractDT(movieParam)
% Extract the descriptors from Dense Trajectory code, and store them in
% cell arrays for codebook generation later.

% file information
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(nxy) '_t_' num2str(nt)];
trackInfo = dir([filepath movieParam.fileName '_' num2str(chunkLen)...
    's_' num2str(track_thresh) '_' infostr '/*.txt']);
% numVideo = floor(movieParam.numImages/timeStep);
numVideo = size(trackInfo,1);

% DT feature information
numPatch = nxy*nxy*nt;
sFlow = 2*L;
sHof = 9*numPatch;
sHog = 8*numPatch;
sMbh = 8*numPatch;

% initialization
desc = cell(numVideo,numPatch);

% exclude the error information in the first two lines
for i = 1:numVideo
    
    % if file empty, put NaN
    if trackInfo(i).bytes==124
        
        fprintf('feature file is empty: %s\n',trackInfo(i).name);
        crHof = nan(1,sHof);
        crHog = nan(1,sHog);
        crMbhx = nan(1,sMbh);
        crMbhy = nan(1,sMbh);
        
    else
    
        dt_features = dlmread([filepath movieParam.fileName '_' num2str(chunkLen)...
    's_' num2str(track_thresh) '_' infostr '/' trackInfo(i).name],'\t',2,0);
        
        crHof = dt_features(:,11+sFlow:10+sFlow+sHof);
        crHof = crHof(~any(isnan(crHof),2),:);

        crHog = dt_features(:,11+sFlow+sHof:10+sFlow+sHof+sHog);
        crHog = crHog(~any(isnan(crHog),2),:);

        crMbhx = dt_features(:,11+sFlow+sHof+sHog:10+sFlow+sHof+sHog+sMbh);
        crMbhx = crMbhx(~any(isnan(crMbhx),2),:);
        
        crMbhy = dt_features(:,11+sFlow+sHof+sHog+sMbh:10+sFlow+sHof+sHog+sMbh*2);
        crMbhy = crMbhy(~any(isnan(crMbhy),2),:);
        
    end
    
    % save spatial-temporal patches
    for j = 1:numPatch
        desc{i,j} = single([crHof(:,(j-1)*9+1:j*9),crHog(:,(j-1)*8+1:j*8),...
            crMbhx(:,(j-1)*8+1:j*8),crMbhy(:,(j-1)*8+1:j*8)]);
    end
    
end


end