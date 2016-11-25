
% read image
im = mat2gray(double(rgb2gray(imread('C:\Users\shuting\Desktop\temp\hydra_pic\hydra_light_1.tif'))));
im = imadjust(im);

% convolve?
fgauss = fspecial('disk',3);
im_conv = imfilter(im,fgauss);

% initialize
m = double(double(im)>multithresh(double(im)));

% I = imresize(I,.5);  %-- make image smaller 
% m = imresize(m,.5);  %     for fast computation

clf
subplot(2,2,1); imshow(im); title('Input Image');
subplot(2,2,2); imshow(m); title('Initialization');
subplot(2,2,3); title('Segmentation');

seg = region_seg(im, m, 100,0.01); %-- Run segmentation

subplot(2,2,4); imshow(seg); title('Global Region-Based Segmentation');

