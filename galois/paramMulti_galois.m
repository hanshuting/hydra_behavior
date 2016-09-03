function [movieParamMulti] = paramMulti_galois(fileInd)

numSample = length(fileInd);
movieParamMulti = cell(numSample,1);

for i = 1:length(fileInd)
    
    movieParamMulti{i} = paramAll_galois(fileInd(i));
    
end

end