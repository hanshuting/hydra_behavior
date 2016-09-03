function [bw,bg] = gnMaskGcamp(movieParam,ifInvert)
% Segment hydra region from video and generate a mask matrix
% SYNOPSIS:
%     [bw,bg] = gnMask(movieParam,ifInvert)
% INPUT:
%     movieParam: a struct returned by paramAll
%     ifInvert: 0 if white object, black background, 1 otherwise
% OUTPUT:
%     bw: a binary matrix with the same size as input video
%     bg: a binary matrix with the same size as one frame of the video,
%       with the estimated background region
% 
% Shuting Han, 2015

% initialization
bw = false(movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages);
bg = true(movieParam.imageSize(1),movieParam.imageSize(2));

% area threshold
P = round(movieParam.imageSize(1)*movieParam.imageSize(2)/400);

sig = 3;
fgauss = fspecial('gaussian',2*ceil(2*sig)+1,sig);
for i = 1:movieParam.numImages
    
    % read image
    im = double(imread([movieParam.filePath movieParam.fileName '.tif'],i));
    if ifInvert
        im = 255-im;
    end
    
    % smoothe image
    im = imfilter(im,fgauss);
    
    % threshold intensity
    thresh = multithresh(im,2);
    f_bw = im>thresh(1);
    
    % threshold area
    f_bw = bwareaopen(f_bw,P);
    
    % fill holes
    f_bw = imfill(f_bw,'holes');
    
    % determine background mask
    bg = bg+f_bw;
    
    % thicken area
    f_bw = bwmorph(f_bw,'thicken');
    
    bw(:,:,i) = f_bw;
    
    % visualize
%     imagesc(bw(:,:,i));title(num2str(i));pause(0.01);
    
    
end

bg = bg>round(0.9*movieParam.numImages);

%bg = imfill(bg,'holes');
bg = bwmorph(bg,'thicken');
%se = strel('square',round(sqrt(movieParam.imageSize(1)*movieParam.imageSize(2)/1000)));
%bg = imdilate(bg,se);

% substract background
%for i = 1:movieParam.numImages
    %bw(:,:,i) = bw(:,:,i)&(~bg);
    %bw(:,:,i) = bwmorph(bw(:,:,i),'thicken');
    %bw(:,:,i) = bwmorph(bw(:,:,i),'bridge');
    %bw(:,:,i) = bwmorph(bw(:,:,i),'close');
%end

end