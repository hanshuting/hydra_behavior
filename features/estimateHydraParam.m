function [hydraParam,centroid] = estimateHydraParam(movieParam)

% this function read through all the images and estimate the angle of the
% hydra, the length of the hydra, the centroid, and calculate the rotation
% matrix, and store them in a struct

theta = zeros(movieParam.numImages,1);
majorAxis = zeros(movieParam.numImages,1);
minorAxis = zeros(movieParam.numImages,1);
centroid = zeros(movieParam.numImages,2);

for i = 1:movieParam.numImages
   
    imageRaw = double(imread([movieParam.filenameImages movieParam.filenameBasis...
        movieParam.enumString(i,:) '.tif']));
    bw = imageRaw>multithresh(imageRaw,1);
    regionstat = regionprops(double(bw),'orientation','centroid','majoraxislength','minoraxislength');
    theta(i) = regionstat.Orientation;
    majorAxis(i) = regionstat.MajorAxisLength;
    minorAxis(i) = regionstat.MinorAxisLength;
    centroid(i,:) = regionstat.Centroid;
    
end

hydraParam.theta = trimmean(theta,20);
thresh = quantile(majorAxis,0.95);
hydraParam.length = mean(majorAxis(majorAxis>thresh)); % take the longest positions
hydraParam.lengthAll = majorAxis;
thresh = quantile(minorAxis,0.95);
hydraParam.width = mean(minorAxis(minorAxis>thresh)); % take the widest positions
%hydraParam.length = trimmean(majorAxis,20);
%hydraParam.width = trimmean(minorAxis,20);

hydraParam.centroid = round(trimmean(centroid,20));
hydraParam.rotmat = [cos(-degtorad(hydraParam.theta+90))...
    -sin(-degtorad(hydraParam.theta+90)); sin(-degtorad(hydraParam.theta+90))...
    cos(-degtorad(hydraParam.theta+90))];


end