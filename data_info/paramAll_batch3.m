function [movieParam] = paramAll_batch3(fileind,id,scriptsize)

% generate movie parameters by batch, and merge the last two ones if the
% last one is less than the given script size

% movie parameters
movieParam = struct;
[movieParam.filePath,movieParam.fileName,numImages,movieParam.fr] = ...
    fileinfo(fileind);

movieParam.frameStart = (id-1)*scriptsize+1;
if (id+1)*scriptsize-1<numImages
    movieParam.frameEnd = id*scriptsize;
else
    movieParam.frameEnd = numImages;
end
movieParam.numImages = movieParam.frameEnd-movieParam.frameStart+1;

% get movie information
imInfo = imfinfo([movieParam.filePath movieParam.fileName '.tif']);
%movieParam.numSeq = 1:movieParam.numImages;
if imInfo(1).BitDepth~=8
    error('image is not 8 bit');
end
movieParam.imageSize = [imInfo(1).Height,imInfo(1).Width];

end
