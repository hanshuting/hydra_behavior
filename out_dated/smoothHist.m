function [smHist] = smoothHist(rawHist)

% smooth histograms by the square root of the sum

dims = size(rawHist);
smHist = rawHist./sqrt(rawHist);
smHist(isnan(smHist)) = 0;
smHist = smHist./(sum(smHist,2)*ones(1,dims(2)));

end