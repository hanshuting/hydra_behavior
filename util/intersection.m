function [D] = intersection(hist1,hist2)
% this function computes the pairwise intersection similarity of rows of
% input histograms
% SYNOPSIS:
%     [D] = intersection(hist1,hist2)
% INPUT:
%     hist1, hist2: histogram matrix, rows are histograms
% OUTPUT:
%     D: intersection similarity
% 
% Shuting Han, 2015

dims = [size(hist1,1),size(hist2,1)];
D = zeros(dims(1),dims(2));

for i = 1:dims(1)
    P = hist1(i,:);
    for j = 1:dims(2)
        Q = hist2(j,:);
        D(i,j) = sum(min([P;Q],[],1));
    end
end


end