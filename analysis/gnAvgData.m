function [avgData] = gnAvgData(fileindx,step)
% This function generates an averaged image from the files specified by
% file indx, with a time step specified by step
% SYNOPSIS:
%     [avgData] = gnAvgData(fileindx,step)
% INPUT:
%     fileindx: see fileinfo.m
%     step: number, time step
% OUTPUT:
%     avgData: averaged data
% 
% Shuting Han, 2015

% registration parameter path
parampath = 'C:\Shuting\Data\yeti\features\registration_param\';

% initialize
avgData = zeros(300,300);

for i = 1:length(fileindx)
    
    % get movie parameters
    movieParam = paramAll(fileindx(i));
    load([parampath movieParam.fileName '_results_registration.mat']);
    
    % calculate averaged image from the video 
    avgIm = zeros(movieParam.imageSize);
    for j = 1:floor(movieParam.numImages/step)
        
        % read image
        im = double(imread([movieParam.filePath movieParam.fileName ...
            '.tif'],(j-1)*step+1));
        
        % registration and segmentation
        im = imrotate(imtranslate(im,[movieParam.imageSize(1)/2-...
            hydraCent((j-1)*step+1,1) movieParam.imageSize(2)/2-...
            hydraCent((j-1)*step+1,2)]),90-hydraOri((j-1)*step+1),'crop');
        im = im.*bwReg(:,:,(j-1)*step+1);
        
        % add up
        avgIm = avgIm+mat2gray(im);
        
    end
    
    avgData = avgData+mat2gray(imresize(im,[300,300]));
    
end

end