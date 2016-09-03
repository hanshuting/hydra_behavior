function [spDescriptor,spCoord] = gnSptpDescriptor(descriptor,coords,m,n,timeStep,hydraLength,movieParam)
% assign descriptors to m*n spatio-temporal patches
% SYNOPSIS:
%     [spDescriptor,spCoord] = gnSptpDescriptor(descriptor,coords,m,n,hydraLength,movieParam)
% INPUT:
%     descriptor: T-by-1 cell array
%     coords: T-by-1 cell array
%     m,n: number of spatial patches in x and y
%     hydraLength: num_frame-by-1 vector, with the estimated length of hydra
%     movieParam: a struct returned by function paramAll
% OUTPUT:
%     spDescriptor: T-by-m*n cell array
%     spCoord: T-by-m*n cell array
% 
% Shuting Han, 2015

% initialize
dims = [movieParam.imageSize(1) movieParam.imageSize(2) size(descriptor,1)];
spDescriptor = cell(dims(3),m*n);
spCoord = cell(dims(3),m*n);

% go over time windows
for i = 1:dims(3)

    % take averaged length
    crLength = trimmean(hydraLength((i-1)*timeStep+1:i*timeStep),50);
    
    a = floor(crLength/m); % patch width in y
    b = floor(crLength/n); % patch width in x
    
    % calculate patch boundaries
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
    cumDim1 = cumsum(dim1Dist);
    cumDim2 = cumsum(dim2Dist);
    
    tw_des = descriptor{i};
    tw_coord = coords{i};
    for j = 1:size(tw_des,1)
        % calculate spatial index
        indx = find(sort([cumDim1;tw_coord(j,1)])==tw_coord(j,1),1)-1;
        indy = find(sort([cumDim2;tw_coord(j,2)])==tw_coord(j,2),1);
        inds = indx*n+indy;
        % store results
        tmpdes = spDescriptor{i,inds};
        tmpdes(end+1,:) = tw_des(j,:);
        spDescriptor{i,inds} = tmpdes;
        tmpcoord = spCoord{i,inds};
        tmpcoord(end+1,:) = tw_coord(j,:);
        spCoord{i,inds} = tmpcoord;
    end
        
    
end

end