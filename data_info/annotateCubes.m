function [annoCubes,annoCubesBi] = annotateCubes(anno,tw)

% this function annotate each spatial-temporal cube by taking the mode of
% the mannual annotation as the label
% INPUT:
%     anno: vector of mannual annotation
%     tw: time window
% OUTPUT:
%     annoCubes: an annotated vector corresponding to the cubes

annoCubes = zeros(floor((size(anno,1)-1)/tw),1);
for i = 1:size(annoCubes,1)
   %annoCubes(i) =  mode(anno((i-1)*tw+2:i*tw+1));    
   annoCubes(i) = max(anno((i-1)*tw+2:i*tw+1));
end

numClusters = size(unique(annoCubes),1);
annoCubesBi = repmat(annoCubes,[1,numClusters]);
for i = 1:numClusters
    indx = annoCubesBi(:,i)==i;
    annoCubesBi(indx,i) = 1;
    annoCubesBi(~indx,i) = -1;
end

end