function [histDist] = histChiSquare(P,Q)

% this function calculates the chi-square distance between two histograms P
% and Q
% INPUT: P and Q must be one dimensional arrays with the same length

%dims = size(P);
%histDist = 0;

%for i = 1:dims(2)
%    if ~isnan(P(i)) && ~isnan(Q(i)) && P(i)+Q(i)~=0
%        histDist = histDist+(P(i)-Q(i))^2/(2*(P(i)+Q(i)));
%    end
%end

histDist = nansum((P-Q).^2./(2*(P+Q)));

end