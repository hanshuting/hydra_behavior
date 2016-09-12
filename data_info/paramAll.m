function [movieParam] = paramAll(dpath,fileind)

movieParam = struct;
movieParam.filePath = dpath;
[movieParam.fileName,movieParam.numImages,...
    movieParam.fr,movieParam.imageSize] = fileinfo(fileind);

movieParam.frameStart = 1;
movieParam.frameEnd = movieParam.numImages;

% get movie information
% imInfo = imfinfo([movieParam.filePath movieParam.fileName '.tif']);
% movieParam.bitDepth = imInfo(1).BitDepth;
% if imInfo(1).BitDepth~=8
%     warning('image is not 8 bit');
% end
% movieParam.imageSize = [imInfo(1).Height,imInfo(1).Width];

end