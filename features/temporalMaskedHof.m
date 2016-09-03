function [msHofAll,coords] = temporalMaskedHof(uu,vv,cubeStep,timeStep,...
    numBins,mask)
% extract neighbor cuboids of interest pixels under mask, concatenate
% HOF, generate a concatenated HOF matrix for each temporal window
% SYNOPSIS:
%     [msHofAll,coords] = temporalMaskedHof(uu,vv,cubeStep,timeStep,...
%        numBins,mask)
% INPUT:
%     uu,vv: sz1-by-sz2-by-N matrix containing optical flow data
%     cubeStep: number, grid size of HOG
%     timeStep: size of time window
%     numBins: number of orientation bins of HOG
%     mask: a sz1-by-sz2-by-N binary matrix, with segmented hydra
% OUTPUT:
%     msHofAll: a M-by-1 cell array, M is the number of time windows,each 
%       cell contains the histograms from a time window
%     coords: a M-by-1 cell array, with coordinates of each corresponding
%       HOF feature (for calculating spatiotemporal HOF)
%
% Shuting Han, 2015

%% initialize
dims = size(uu);
binRanges = -pi:2*pi/numBins:pi;
tt = floor(dims(3)/timeStep);
uu = uu(:,:,1:tt*timeStep);
vv = vv(:,:,1:tt*timeStep);

msHofAll = cell(tt,1);
coords = cell(tt,1);

% divide image into small neighborhoods
numCubex = floor(dims(1)/cubeStep);
numCubey = floor(dims(2)/cubeStep);
arrayx = cubeStep*ones(numCubex,1);
arrayx(end) = cubeStep+dims(1)-cubeStep*numCubex;
arrayy = cubeStep*ones(numCubey,1);
arrayy(end) = cubeStep+dims(2)-cubeStep*numCubey;

% generate coordinates for each neighborhood
[gridx,gridy] = meshgrid(1:cubeStep:dims(1),1:cubeStep:dims(2));
twCoord = [reshape(gridx,[],1),reshape(gridy,[],1)];

%% go over all time windows
fprintf('processed time window:      0/%u',tt);
for i = 1:tt
    
    % calculate image mask
    twMask = sum(mask(:,:,(i-1)*timeStep+1:i*timeStep),3);
    cellMask = reshape(mat2cell(twMask,arrayx,arrayy),[],1);
    cellMask = cellfun(@(A) reshape(A,1,[]),cellMask,'UniformOutput',false);
    
    % nonzero patches under mask
    maskIndx = cellfun(@(A) any(A~=0),cellMask);
    
    twHof = [];
    
    % go over each frame in the time window
    for j = 1:timeStep
        
        % calculate orientations and weights in the frame
        fruu = double(uu(:,:,(i-1)*timeStep+j))/1000;
        frvv = double(vv(:,:,(i-1)*timeStep+j))/1000;
        frOri = atan2(fruu,frvv);
        frWei = sqrt(fruu.^2+frvv.^2);
        
        % divide results into patches
        cellOri = reshape(mat2cell(frOri,arrayx,arrayy),[],1);
        cellWei = reshape(mat2cell(frWei,arrayx,arrayy),[],1);
        
        % linearize patches
        cellOri = cellfun(@(A) reshape(A,1,[]),cellOri,'UniformOutput',false);
        cellWei = cellfun(@(A) reshape(A,1,[]),cellWei,'UniformOutput',false);
        
        % calculate histogram on each small neighborhood
        [~,histIndx] = cellfun(@(mat) histc(mat,binRanges),cellOri,...
            'UniformOutput',false);
        histIndx = cellfun(@(A) reshape(A,[],1),histIndx,'UniformOutput',false);
        frHof = cellfun(@(subs,val) transpose(accumarray(subs,val,[numBins+1,1])),...
            histIndx,cellWei,'UniformOutput',false);
        frHof = cell2mat(frHof);
        
        % merge last two bins
        frHof(:,8) = frHof(:,8)+frHof(:,9);
        frHof = frHof(:,1:8);
        
        % normalization
        frHof = frHof./(sum(frHof,2)*ones(1,numBins));
        twHof(1:size(frHof,1),(j-1)*numBins+1:j*numBins) = frHof;
        
    end
    
    % normalization
    twHof = twHof/timeStep;
    twHof(isnan(twHof)) = 0;

    % store results
    keepInd = sum(twHof,2)~=0;
    coords{i} = twCoord(keepInd&maskIndx,:);
    msHofAll{i} = twHof(keepInd&maskIndx,:);
    
    % update progress text
    fprintf(repmat('\b',1,length(num2str(tt))+length(num2str(i))+1));
    fprintf('%u/%u',i,tt);
    
end

fprintf('\n');

end
