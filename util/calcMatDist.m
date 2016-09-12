function [D] = calcMatDist(data,distType)
% Calculate distance between pairs of rows of input matrix, using given
% distance type
% INPUT:
%     data: M-by-N matrix, distance is calculated between rows
%     distType: chi square ('chi'), euclidean ('euc'), intersection
%     ('int'), cosine ('cos') or pearson correlation ('corr')
% OUTPUT:
%     D: M-by-M distance matrix
% 
% Shuting Han, 2016

switch distType
    case 'chi'
        D = chiSquare(data,data);
    case 'euc'
        D = pdist2(data,data);
    case 'int'
        D = 1-intersection(data,data);
    case 'cos'
        D = pdist2(data,data,'cosine');
    case 'corr'
        D = pdist2(data,data,'correlation');
    otherwise
        error('invalid distance type');
end

end