function [distMat] = chiSquare(hist1,hist2)
% this function calculates the pairwise histogram distance in a histogram
% matrix and generate a distance matrix
% INPUT:
%     histMat: rows denotes histograms
% OUTPUT:
%     distMat: a matrix containing the pairwise distance of the histograms
%         in histMat

dims1 = size(hist1);
dims2 = size(hist2);
distMat = zeros(dims1(1),dims2(1));

for i = 1:dims1(1)
    P = hist1(i,:);
    for j = 1:dims2(1)
        Q = hist2(j,:);
        distMat(i,j) = nansum((P-Q).^2./(2*(P+Q)));
        %distMat(i,j) = histChiSquare(histMat(i,:),histMat(j,:));
    end
end

end