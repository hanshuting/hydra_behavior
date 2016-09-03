function [cdbkCenter,cdbkIndx] = gnCdbk(data,lengthObs,numCenters)
% SYNOPSIS:
%     [cdbkCenter,cdbkIndx] = gnCdbk(data,lengthObs,numCenters)
% INPUT:
%     data: a cell array, each cell contains a matrix where each row is an
%       observation
%     lengthObs: length of each observation to cluster. It could be a
%       number that can be divided by size(data,2), or size(data,2)
%     numCenters: number of codebook centers
% OUTPUT:
%     hofCenters: codebook centers
% 
% Shuting Han, 2015

%% build samples
allSamples = double(reshape(cell2mat(data)',lengthObs,[])');

% remove NaN
allSamples = allSamples(sum(isnan(allSamples),2)==0,:);
numSamples = size(allSamples,1);

%% generate codebook centers by k-means
if numSamples>1e5
    [cdbkIndx,cdbkCenter] = kmeans(allSamples(randperm(numSamples,1e5),:),...
        numCenters,'replicate',3,'emptyaction','drop');
else
    [cdbkIndx,cdbkCenter] = kmeans(allSamples,numCenters,'replicate',3,'emptyaction','drop');
end

cdbkCenter = cdbkCenter(sum(isnan(cdbkCenter),2)==0,:);

end
