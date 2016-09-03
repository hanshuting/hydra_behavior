function [tracksAll] = processTracks(movieParam,hydraParam,m,n,step)

% process raw tracking results from trackmate, normalize by the length of
% the hydra, center at [0,0], and spatially segment by given parameters m
% and n, and store information in cell output tracksAll.

%% get parameters

% import csv track file and get the number of all cells in all frames
%tracksRaw = csvread(movieParam.filenameTracks);
tracksRaw = dlmread(movieParam.filenameTracks,'\t',1,3);

% put all tracks together
tracksAll = cell(floor((movieParam.numImages-1)/step),1);
scale = hydraParam.length/200; % normalizing parameter
for i = 1:step:movieParam.numImages
    ind = (tracksRaw(:,7)==i-1); % because in the csv file frame starts from 0
    infomat = zeros(sum(ind),3);
    infomat(:,1) = tracksRaw(ind,1); % track ID
    coordCurrent = tracksRaw(ind,3:4);
    % rotate to calibrated coordinate system (animal axis aligned) and
    % centralize the centroid
    coordNew = (coordCurrent-ones(sum(ind),1)*hydraParam.centroid)*...
        hydraParam.rotmat;
    % normalize by half length of the hydra, and scale up by 100
    coordNew = coordNew./scale;
    infomat(:,2:3) = coordNew; % (x,y) location
    tracksAll{(i-1)/step+1} = infomat;
    clear infomat
    clear ind
end

clear tracksRaw

% calculate parameters in the normalized coordinate system
a = floor(hydraParam.length/(scale*m));
b = floor(hydraParam.length/(scale*n));
a0 = m*a/2;
b0 = n*b/2;

%% spatial segmentation
segFrInd = find(hydraParam.lengthAll==max(hydraParam.lengthAll));
segFrInd = round(segFrInd(1)/step);

% go forward
for i = segFrInd:length(tracksAll) % neglect incomplete time window
    
    infomat = tracksAll{i};
    
    % go through all the tracked cells in current frame
    for j = 1:size(infomat,1)
        
        % record the initla patch index of all neurons in the first frame
        if i==segFrInd
            
            coord = infomat(j,2:3);
            if coord(1) <= -a0
                tmp1 = 1;
            elseif coord(1) > a0
                tmp1 = m;
            else
                tmp1 = ceil((coord(1)+a0)/a);
            end
            if coord(2) <= -b0
                tmp2 = 0;
            elseif coord(2) > b0
                tmp2 = (n-1)*m;
            else
                tmp2 = floor((coord(2)+b0)/b)*m;
            end
            inds = tmp1+tmp2;
            
            if inds==0
                inds;
            end
            
            infomat(j,4) = inds;
            tracksAll{i} = infomat;
            
            continue;
    
        end
        
        infomatPrev = tracksAll{i-1};
        indPrev = find(infomatPrev(:,1)==infomat(j,1));
        
        if ~isempty(indPrev) % if previous tracking information available
            
            % if patch index has been recorded
            if infomatPrev(indPrev,4)~=0
                inds = infomatPrev(indPrev,4);
                infomat(j,4) = inds;
            else % take the patch index of its nearest neighbor
                patchCenters = zeros(m*n,2);
                for k = 1:m*n
                    patchCenters(k,:) = mean(infomatPrev(infomatPrev(:,4)==k,2:3),1);
                end
                indNeighbor = findNeighbor(infomatPrev(indPrev,2:3),patchCenters,200);
                inds = indNeighbor(1);
                %indNeighbor = indNeighbor(2); % exclude itself
                %inds = infomatPrev(indNeighbor,4);
                infomat(j,4) = inds;
            end
            
        else % if previous tracking information unavailable
            patchCenters = zeros(m*n,2);
            for k = 1:m*n
                patchCenters(k,:) = mean(infomatPrev(infomatPrev(:,4)==k,2:3),1);
            end
            indNeighbor = findNeighbor(infomat(j,2:3),patchCenters,200);
            infomat(j,4) = indNeighbor(1);
            
            continue; % ignore this round
            
        end

    end
    
    tracksAll{i} = infomat;
    
end

% go backwards
for i = segFrInd-1:-1:1 % neglect incomplete time window
    
    infomat = tracksAll{i};
    
    % go through all the tracked cells in current frame
    for j = 1:size(infomat,1)
        
        % record the initla patch index of all neurons in the first frame
        
        infomatPrev = tracksAll{i+1};
        indPrev = find(infomatPrev(:,1)==infomat(j,1));
        
        if ~isempty(indPrev) % if previous tracking information available
            
            % if patch index has been recorded
            if infomatPrev(indPrev,4)~=0
                inds = infomatPrev(indPrev,4);
                infomat(j,4) = inds;
            else % take the patch index of its nearest neighbor
                patchCenters = zeros(m*n,2);
                for k = 1:m*n
                    patchCenters(k,:) = mean(infomatPrev(infomatPrev(:,4)==k,2:3),1);
                end
                indNeighbor = findNeighbor(infomatPrev(indPrev,2:3),patchCenters,200);
                inds = indNeighbor(1);
                %indNeighbor = indNeighbor(2); % exclude itself
                %inds = infomatPrev(indNeighbor,4);
                infomat(j,4) = inds;
            end
            
        else % if previous tracking information unavailable
            patchCenters = zeros(m*n,2);
            for k = 1:m*n
                patchCenters(k,:) = mean(infomatPrev(infomatPrev(:,4)==k,2:3),1);
            end
            indNeighbor = findNeighbor(infomat(j,2:3),patchCenters,200);
            infomat(j,4) = indNeighbor(1);
            
            continue; % ignore this round
            
        end

    end
    
    tracksAll{i} = infomat;
    
end


end