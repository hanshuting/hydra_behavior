function [gists,gistParam] = gistFeatures(gistParam,movieParam)

% Pre-allocate gist:
Nfeatures = sum(gistParam.orientationsPerScale)*gistParam.numberBlocks^2;
gists = zeros([movieParam.numImages Nfeatures]); 

% Load first image and compute gist:
im = imread([movieParam.filenameImages movieParam.filenameBasis...
            movieParam.enumString(1,:) '.tif']);
[gists(1,:), gistParam] = LMgist(im, '', gistParam); % first call

% Loop:
for i = 2:movieParam.numImages
   im = imread([movieParam.filenameImages movieParam.filenameBasis...
            movieParam.enumString(i,:) '.tif']);
   gists(i, :) = LMgist(im, '', gistParam); % the next calls will be faster
end

end