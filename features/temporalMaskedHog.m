function [msHogAll,coords] = temporalMaskedHog(movieParam,theta,centroid,...
    cubeStep,timeStep,numBins,mask)
% extract neighbor cuboids of interest pixels under mask, concatenate
% HOG, generate a concatenated HOG matrix for each temporal window
% SYNOPSIS:
%     [msHogAll,coords] = temporalMaskedHog(movieParam,theta,centroid,...
%       cubeStep,timeStep,numBins,mask)
% INPUT:
%     movieParam: a struct with field: filePath, fileName, numImages,
%       frameStart, frameEnd, bitDepth, imageSize
%     theta: a N-by-1 vector of hydra orientation, N is #total frames
%     centroid: a N-by-2 vector of hydra centroid position, N is #total frames
%     cubeStep: number, grid size of HOG
%     timeStep: size of time window
%     numBins: number of orientation bins of HOG
%     mask: a sz1-by-sz2-by-N binary matrix, with segmented hydra
% OUTPUT:
%     msHogAll: a M-by-1 cell array, M is the number of time windows, each
%       cell has a matrix of concatenated HOG features in the time window
%     coords: a M-by-1 cell array, with coordinates of each corresponding
%       HOG feature (for calculating spatiotemporal HOG)
%
% Shuting Han, 2015

%% set parameters
dims = [movieParam.imageSize(1) movieParam.imageSize(2)];
binRanges = -pi:2*pi/numBins:pi;
tt = floor(length(theta)/timeStep);

% gradient filters
hx = [-1,0,1];
hy = -hx';

% initialize
msHogAll = cell(tt,1);
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
% for i = 1:5
    
    % calculate image mask
    twMask = sum(mask(:,:,(i-1)*timeStep+1:i*timeStep),3)~=0;
    cellMask = reshape(mat2cell(twMask,arrayx,arrayy),[],1);
    cellMask = cellfun(@(A) reshape(A,1,[]),cellMask,'UniformOutput',false);
    
    % nonzero patches under mask
    maskIndx = cellfun(@(A) any(A~=0),cellMask);
    
    twHog = [];
    
    % take averaged centroid and orientation
    cr_theta = 90-trimmean(theta((i-1)*timeStep+1:i*timeStep),50);
    cr_cent = trimmean(centroid((i-1)*timeStep+1:i*timeStep,:),50,1);
    
    % go over each frame in each time window
    for j = 1:timeStep
        
        % read image file
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],...
            (i-1)*timeStep+j));
        im = imrotate(imtranslate(im,round([movieParam.imageSize(1)/2-...
            cr_cent(1) movieParam.imageSize(2)/2-...
            cr_cent(2)])),cr_theta,'crop');
        
        % normalize image
        im = mat2gray(im);
        
        % visualize
        imagesc(im.*twMask);pause(0.1);
        
        % calculate gradient, orientation and weight
        gradx = imfilter(im,hx);
        grady = imfilter(im,hy);
        frOri = atan2(grady,gradx);
        frOri(isnan(frOri)) = 0;
        frWei = sqrt((grady.^2)+(gradx.^2));
        
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
        frHog = cellfun(@(subs,val) transpose(accumarray(subs,val,[numBins+1,1])),...
            histIndx,cellWei,'UniformOutput',false);
        frHog = cell2mat(frHog);
        
        % merge last two bins
        frHog(:,8) = frHog(:,8)+frHog(:,9);
        frHog = frHog(:,1:8);
        
        % normalization
        frHog = frHog./(sum(frHog,2)*ones(1,numBins));
        twHog(1:size(frHog,1),(j-1)*numBins+1:j*numBins) = frHog;

    end
    
    % normalization
    twHog = twHog/timeStep;
    twHog(isnan(twHog)) = 0;
    
    % store results
    keepInd = sum(twHog,2)~=0;
    msHogAll{i} = twHog(keepInd&maskIndx,:);
    coords{i} = twCoord(keepInd&maskIndx,:);
    
    % update progress text
    fprintf(repmat('\b',1,length(num2str(tt))+length(num2str(i))+1));
    fprintf('%u/%u',i,tt);
    
end

fprintf('\n');

end
