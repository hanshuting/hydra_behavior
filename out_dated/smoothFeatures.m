function [smData] = smoothFeatures(data,filtsz)
% This function smoothes features by convolving with a gaussian filter

% make gaussian filter
fgauss = gausswin(filtsz);

% convolve data
smData = conv2(data,fgauss,'same');

end