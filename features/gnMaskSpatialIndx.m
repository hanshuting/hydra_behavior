function [spInd,coordAll] = gnMaskSpatialIndx(m,n,as,mask,time_step,cube_step)
% generate the spatial patch index for each pixel under the given mask
% region
% INPUT:
%     m: number of spatial patches in x
%     n: number of spatial patches in y
%     dims: [image size in x, image size in y, number of frames]
%     as: estimated lengths of hydra, averaged per time window
%     mask: binary masks, per frame
%     time_step: number of frames per time window
% OUTPUT:
%     spInd: a cell array that contains the spatial patch index for every
%     pixel under the mask stacked in time window
%     spCoord: a cell array, each cell contains the coordinates of
%     corresponding points in spInd (for visualization)

dims = size(mask);
dims(3) = floor(dims(3)/time_step);
%cent = round([dims(1) dims(2)]/2);
spInd = cell(dims(3),1);
coordAll = cell(dims(3),1);

for i = 1:dims(3)
    
    tw_mask = sum(mask(:,:,(i-1)*time_step+1:i*time_step),3);
    %tw_mask = tw_mask';
    %nz = sum(tw_mask(:)~=0);
    
    a = floor(as(i)/m); % patch width in y
    b = floor(as(i)/n); % patch width in x
    
    % generate spatial index for each pixel
    if m==1
        dim1Dist = dims(1);
    else
        dim1Dist = a*ones(m,1);
        dim1Dist(1) = round((dims(1)-(m-2)*a)/2);
        dim1Dist(end) = dims(1)-(m-2)*a-dim1Dist(1);
    end
    if n==1
        dim2Dist = dims(2);
    else
        dim2Dist = b*ones(n,1);
        dim2Dist(1) = round((dims(2)-(n-2)*b)/2);
        dim2Dist(end) = dims(2)-(n-2)*b-dim2Dist(1);
    end
    
%     indMat = ones(dims(1),dims(2));
%     indCell = mat2cell(indMat,dim1Dist,dim2Dist);
%     for kk = 1:m*n
%         indCell{kk} = kk*indCell{kk};
%     end
%     indMat = cell2mat(indCell);
%     inds = indMat(logical(tw_mask));
%     spInd{i} = inds;
    
    % store coordinate information for each patch
    tmpcoord = [];
    inds = [];
    cumDim1 = cumsum(dim1Dist);
    cumDim2 = cumsum(dim2Dist);
    for ii = 1:cube_step:dims(1)
        for jj = 1:cube_step:dims(2)
            if tw_mask(ii,jj)~=0
                tmpcoord(end+1,1) = ii;
                tmpcoord(end,2) = jj;
                indx = find(sort([cumDim1;ii])==ii,1)-1;
                indy = find(sort([cumDim2;jj])==jj,1);
%                 fprintf('%u, %u\n',indx,indy);
                inds(end+1) = indx*n+indy;
            end
        end
    end
    coordAll{i} = tmpcoord;
    spInd{i} = inds';
    %[coordx,coordy] = ind2sub([dims(1) dims(2)],find(tw_mask(:)));
    %scatter(coordx,coordy);xlim([0 300]);ylim([0 300]);pause(0.01);
%     for kk = 1:m*n
%         coordAll{i,kk} = [coordy(inds==kk),coordx(inds==kk)];
%     end
    %coordAll{i} = [coordx,coordy];
    
end


end