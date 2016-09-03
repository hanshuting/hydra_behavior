function [drData,coeff] = drHist(data,ci)
% do PCA on input data, keep a given amount of variation
% SYNOPSIS:
%     [drData,coeff] = drHist(data,ci)
% INPUT:
%     data: data matrix to process
%     ci: cut off percentage of explained threshold in pca (0-100)
% OUTPUT:
%     drData: dimension reduced data
%     coeff: transformation matrix
% 
% Shuting Han, 2015

% pca
[coeff,score,~,~,explained] = pca(data);

% find the cut off threshold of dimensions
tmp = 0;
thresh = 1;
while tmp < ci
    tmp = tmp+explained(thresh);
    thresh = thresh+1;
end
if thresh > size(score,2)
    thresh = size(score,2);
end

% truncate data
drData = score(:,1:thresh);

end