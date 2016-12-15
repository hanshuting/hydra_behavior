function [trajAll,hofAll,hogAll,mbhxAll,mbhyAll,coordAll] = extractRegionTwDTCont...
    (movieParam,filepath,segmat,numRegion,dtparam)
% Extract the descriptors from Dense Trajectory code, and store them in
% cell arrays for codebook generation later.

L = dtparam.L;
s = dtparam.s;
t = dtparam.t;
W = dtparam.W;
N = dtparam.N;
tlen = dtparam.tlen;
thresh = dtparam.thresh;
timeStep = tlen*movieParam.fr;

% file information
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t)];
trackInfo = dir([filepath movieParam.fileName '_' num2str(tlen)...
    's_' num2str(thresh) '_' infostr '/*.txt']);
% numVideo = size(trackInfo,1);
numVideo = movieParam.numImages-timeStep;

% DT feature information
numPatch = s*s*t;
sTraj = 2*L;
sCoord = 2*L;
sHof = 9*numPatch;
sHog = 8*numPatch;
sMbh = 8*numPatch;
ltraj = floor(2*L/numPatch);

% initialization
trajAll = cell(numVideo,numRegion*numPatch);
hofAll = cell(numVideo,numRegion*numPatch);
hogAll = cell(numVideo,numRegion*numPatch);
mbhxAll = cell(numVideo,numRegion*numPatch);
mbhyAll = cell(numVideo,numRegion*numPatch);
coordAll = cell(numVideo,numRegion*numPatch);

% exclude the error information in the first two lines
dims = size(segmat);
for i = 1:numVideo
    
    % if file empty, put NaN
    if trackInfo(i).bytes==186 || trackInfo(i).bytes==0
        
        fprintf('feature file is empty: %s\n',trackInfo(i).name);
        crTraj = nan(1,sTraj);
        crCoord = nan(1,sCoord);
        crHof = nan(1,sHof);
        crHog = nan(1,sHog);
        crMbhx = nan(1,sMbh);
        crMbhy = nan(1,sMbh);
        regIndx = [];
        
    else
    
        dt_features = dlmread([filepath movieParam.fileName '_' num2str(tlen)...
    's_' num2str(thresh) '_' infostr '/' trackInfo(i).name],'\t',3,0);
        
        % trajectory coordinates
        crCoord = dt_features(:,11+sTraj:10+sTraj+sCoord);
        crCoord = round(crCoord(~any(isnan(crCoord),2),:));
        crCoord(crCoord<=0) = 1;
        xcoord = crCoord(:,1:2:end);
        ycoord = crCoord(:,2:2:end);
        xcoord(xcoord>dims(1)) = dims(1);
        ycoord(ycoord>dims(2)) = dims(2);
        
        % get segmentation region index
        lind = sub2ind([dims(1) dims(2)],ycoord,xcoord);
        regIndx = zeros(size(lind));
        for j = 1:L
            seg_im = segmat(:,:,i+j);
            regIndx(:,j) = seg_im(lind(:,j));
        end
        regIndx(regIndx==0) = NaN;
        regIndx = mode(regIndx,2);
        
        % descriptors
        crTraj = dt_features(:,11:10+sTraj);
        crTraj = crTraj(~any(isnan(crTraj),2),:);
        
        crHog = dt_features(:,11+sTraj+sCoord:10+sTraj+sCoord+sHog);
        crHog = crHog(~any(isnan(crHog),2),:);

        crHof = dt_features(:,11+sTraj+sCoord+sHog:10+sTraj+sCoord+sHof+sHog);
        crHof = crHof(~any(isnan(crHof),2),:);

        crMbhx = dt_features(:,11+sTraj+sCoord+sHof+sHog:10+sTraj+sCoord+sHof+sHog+sMbh);
        crMbhx = crMbhx(~any(isnan(crMbhx),2),:);
        
        crMbhy = dt_features(:,11+sTraj+sCoord+sHof+sHog+sMbh:10+sTraj+sCoord+sHof+sHog+sMbh*2);
        crMbhy = crMbhy(~any(isnan(crMbhy),2),:);
        
    end
    
    % save spatial-temporal patches
    for j = 1:numRegion
        if sum(regIndx==j)~=0
            for k = 1:numPatch
                trajAll{i,(j-1)*numPatch+k} = single(crTraj(regIndx==j,(k-1)*ltraj+1:k*ltraj));
                hofAll{i,(j-1)*numPatch+k} = single(crHof(regIndx==j,(k-1)*9+1:k*9));
                hogAll{i,(j-1)*numPatch+k} = single(crHog(regIndx==j,(k-1)*8+1:k*8));
                mbhxAll{i,(j-1)*numPatch+k} = single(crMbhx(regIndx==j,(k-1)*8+1:k*8));
                mbhyAll{i,(j-1)*numPatch+k} = single(crMbhy(regIndx==j,(k-1)*8+1:k*8));
                coordAll{i,(j-1)*numPatch+k} = single(crCoord(regIndx==j,(k-1)*ltraj+1:k*ltraj));
            end
%             hofAll{i,j} = single(crHof(regIndx==j,:));
%             hogAll{i,j} = single(crHog(regIndx==j,:));
%             mbhxAll{i,j} = single(crMbhx(regIndx==j,:));
%             mbhyAll{i,j} = single(crMbhy(regIndx==j,:));
        else
            for k = 1:numPatch
                trajAll{i,(j-1)*numPatch+k} = nan(1,ltraj);
                hofAll{i,(j-1)*numPatch+k} = nan(1,9);
                hogAll{i,(j-1)*numPatch+k} = nan(1,8);
                mbhxAll{i,(j-1)*numPatch+k} = nan(1,8);
                mbhyAll{i,(j-1)*numPatch+k} = nan(1,8);
                coordAll{i,(j-1)*numPatch+k} = nan(1,ltraj);
            end
%             hofAll{i,j} = nan(1,sHof);
%             hogAll{i,j} = nan(1,sHog);
%             mbhxAll{i,j} = nan(1,sMbh);
%             mbhyAll{i,j} = nan(1,sMbh);
        end
    end
    
end


end
