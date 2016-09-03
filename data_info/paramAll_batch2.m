function [movieParam] = paramAll_batch2(fileind,id,scriptsize)

% This script is a summary of all parameters

% movie parameters
movieParam = struct;
[movieParam.filePath,movieParam.fileName,numImages,movieParam.fr] = fileinfo(fileind);

% set start and end frame
movieParam.frameStart = (id-1)*scriptsize;
if id*scriptsize > numImages
    movieParam.frameEnd = numImages;
else
    movieParam.frameEnd = id*scriptsize;
end
movieParam.numImages = movieParam.frameEnd-movieParam.frameStart+1;

% read movie information
imInfo = imfinfo([movieParam.filePath movieParam.fileName '.tif']);
if imInfo(1).BitDepth~=8
    error('image is not 8 bit');
end
movieParam.imageSize = [imInfo(1).Height,imInfo(1).Width];

end
