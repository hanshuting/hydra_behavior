function [msMbhxAll,msMbhyAll,mbhxCoords,mbhyCoords] = temporalMaskedMbh(...
    uu,vv,cubeStep,timeStep,numBins,mask)
% calculate MBH descriptors in both x and y directions
% SYNOPSIS:
%     [msMbhxAll,msMbhyAll,mbhxCoords,mbhyCoords] = temporalMaskedMbh(...
%       uu,vv,cubeStep,timeStep,numBins,mask)
% INPUT:
%     uu,vv: sz1-by-sz2-by-N matrix containing optical flow data
%     cubeStep: number, grid size of MBH
%     timeStep: size of time window
%     numBins: number of orientation bins of MBH
%     mask: a sz1-by-sz2-by-N binary matrix, with segmented hydra
% OUTPUT:
%     msMbhxAll, msMbhyAll: M-by-1 cell array, M is the number of time 
%       windows,each cell contains the histograms from a time window
%     mbhxCoords, mbhyCoords: M-by-1 cell array, with coordinates of each 
%       corresponding MBH feature (for calculating spatiotemporal MBH)
%
% Shuting Han, 2015

%% initialize
dims = size(uu);
binRanges = -pi:2*pi/numBins:pi;
tt = floor(dims(3)/timeStep);
uu = uu(:,:,1:tt*timeStep);
vv = vv(:,:,1:tt*timeStep);

% gradient filters
hx = [-1,0,1];
hy = -hx';

% initialize
msMbhxAll = cell(tt,1);
msMbhyAll = cell(tt,1);
mbhxCoords = cell(tt,1);
mbhyCoords = cell(tt,1);

% divide image into small regions
numCubex = floor(dims(1)/cubeStep);
numCubey = floor(dims(2)/cubeStep);
arrayx = cubeStep*ones(numCubex,1);
arrayx(end) = cubeStep+dims(1)-cubeStep*numCubex;
arrayy = cubeStep*ones(numCubey,1);
arrayy(end) = cubeStep+dims(2)-cubeStep*numCubey;

% generate coordinates for each region
[gridx,gridy] = meshgrid(1:cubeStep:dims(1),1:cubeStep:dims(2));
twCoord = [reshape(gridx,[],1),reshape(gridy,[],1)];

%% go over all frames
fprintf('processed time window:      0/%u',tt);
for i = 1:tt
% for i = 1:5
    
    % calculate image mask
    twMask = sum(mask(:,:,(i-1)*timeStep+1:i*timeStep),3);
    cellMask = reshape(mat2cell(twMask,arrayx,arrayy),[],1);
    cellMask = cellfun(@(A) reshape(A,1,[]),cellMask,'UniformOutput',false);
    
    % nonzero patches under mask
    maskIndx = cellfun(@(A) any(A~=0),cellMask);
    
    twMbhx = [];
    twMbhy = [];

    for j = 1:timeStep
        
        %% MBHx
        % motion information as image: motion in x
        fruu = double(uu(:,:,(i-1)*timeStep+j))/1000;
        gradxuu = imfilter(fruu,hx);
        gradyuu = imfilter(fruu,hy);
        fruuOri = atan2(gradyuu,gradxuu);
        fruuOri(isnan(fruuOri)) = 0;
        fruuWei = sqrt(single((gradyuu.^2)+(gradxuu.^2)));
        
        % divide results into patches
        cellOri = reshape(mat2cell(fruuOri,arrayx,arrayy),[],1);
        cellWei = reshape(mat2cell(fruuWei,arrayx,arrayy),[],1);
        
        % linearize patches
        cellOri = cellfun(@(A) reshape(A,1,[]),cellOri,'UniformOutput',false);
        cellWei = cellfun(@(A) reshape(A,1,[]),cellWei,'UniformOutput',false);
        
        % calculate histogram on each small neighborhood
        [~,histIndx] = cellfun(@(mat) histc(mat,binRanges),cellOri,...
            'UniformOutput',false);
        histIndx = cellfun(@(A) reshape(A,[],1),histIndx,'UniformOutput',false);
        frMbhx = cellfun(@(subs,val) transpose(accumarray(subs,val,[numBins+1,1])),...
            histIndx,cellWei,'UniformOutput',false);
        frMbhx = cell2mat(frMbhx);
        
        % merge last two bins
        frMbhx(:,8) = frMbhx(:,8)+frMbhx(:,9);
        frMbhx = frMbhx(:,1:8);
        
        % normalization
        frMbhx = frMbhx./(sum(frMbhx,2)*ones(1,numBins));
        twMbhx(1:size(frMbhx,1),(j-1)*numBins+1:j*numBins) = frMbhx;
        
        %% MBHy
        % motion in y
        frvv = double(vv(:,:,(i-1)*timeStep+j))/1000;
        gradxvv = imfilter(frvv,hx);
        gradyvv = imfilter(frvv,hy);
        frvvOri = atan2(gradyvv,gradxvv);
        frvvOri(isnan(frvvOri)) = 0;
        frvvWei = sqrt(single((gradyvv.^2)+(gradxvv.^2)));
        
        % divide results into patches
        cellOri = reshape(mat2cell(frvvOri,arrayx,arrayy),[],1);
        cellWei = reshape(mat2cell(frvvWei,arrayx,arrayy),[],1);
        
        % linearize patches
        cellOri = cellfun(@(A) reshape(A,1,[]),cellOri,'UniformOutput',false);
        cellWei = cellfun(@(A) reshape(A,1,[]),cellWei,'UniformOutput',false);
        
        % calculate histogram on each small neighborhood
        [~,histIndx] = cellfun(@(mat) histc(mat,binRanges),cellOri,...
            'UniformOutput',false);
        histIndx = cellfun(@(A) reshape(A,[],1),histIndx,'UniformOutput',false);
        frMbhy = cellfun(@(subs,val) transpose(accumarray(subs,val,[numBins+1,1])),...
            histIndx,cellWei,'UniformOutput',false);
        frMbhy = cell2mat(frMbhy);
        
        % merge last two bins
        frMbhy(:,8) = frMbhy(:,8)+frMbhy(:,9);
        frMbhy = frMbhy(:,1:8);
        
        % normalization
        frMbhy = frMbhy./(sum(frMbhy,2)*ones(1,numBins));
        twMbhy(1:size(frMbhy,1),(j-1)*numBins+1:j*numBins) = frMbhy;


    end % time_step
    
    
    % normalization
    twMbhx = twMbhx/timeStep;
    twMbhy = twMbhy/timeStep;
    twMbhx(isnan(twMbhx)) = 0;
    twMbhy(isnan(twMbhy)) = 0;
    
    % store results
    keepInd = sum(twMbhx,2)~=0;
    mbhxCoords{i} = twCoord(keepInd&maskIndx,:);
    msMbhxAll{i} = twMbhx(keepInd&maskIndx,:);
    
    keepInd = sum(twMbhy,2)~=0;
    mbhyCoords{i} = twCoord(keepInd&maskIndx,:);
    msMbhyAll{i} = twMbhy(keepInd&maskIndx,:);
    
    % update progress text
    fprintf(repmat('\b',1,length(num2str(tt))+length(num2str(i))+1));
    fprintf('%u/%u',i,tt);
    
end

fprintf('\n');

end
