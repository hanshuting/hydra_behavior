function [movieParamMulti] = paramMulti(dpath,fileInd)

numSample = length(fileInd);
movieParamMulti = cell(numSample,1);

for i = 1:length(fileInd)
    movieParamMulti{i} = paramAll(dpath,fileInd(i));
end

end