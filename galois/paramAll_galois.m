function [movieParam] = paramAll_galois(fileind)
% This script is a summary of all parameters

% movie parameters
movieParam = struct;
[movieParam.filePath,movieParam.fileName,movieParam.numImages,movieParam.fr,...
    movieParam.imageSize] = fileinfo_galois(fileind);

movieParam.frameStart = 1;
movieParam.frameEnd = movieParam.numImages;

end
