function [acr,prc] = evaluateClusters(clusterIndx,label)
% compare the clustering results with ground truth labels
% SYNOPSIS:
%     [acr,prc] = evaluateClusters(clusterIndx,label)
% INPUT:
%     clusterIndx: N-by-1 vector, index returned by clustering methods
%     label: N-by-1 vector, ground truth labels
% OUTPUT:
%     acr: label component in clusters, the ith row contains percentage of
%       each true label class in cluster i
%     prc: cluster component in labels, the ith row contains percentage of
%       each cluster class in true label class i
% 
% Shuting Han, 2015

% unique labels
uCluster = unique(clusterIndx);
uLabel = unique(label);
numClass = length(uLabel);
numCluster = length(uCluster);

% cluster percentage
acr = zeros(numCluster,numClass);
prc = zeros(numClass,numCluster);
for i = 1:numCluster
    trueCluster = sum(clusterIndx==uCluster(i));
    for j = 1:numClass      
        trueLabel = sum(label==uLabel(j));
        acr(i,j) = sum(clusterIndx==uCluster(i)&label==uLabel(j))/trueCluster;
        prc(j,i) = sum(clusterIndx==uCluster(i)&label==uLabel(j))/trueLabel;
    end
end
acr(isnan(acr)) = 0;
prc(isnan(prc)) = 0;

end