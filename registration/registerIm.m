function [theta,centroid,a,b,rarea] = registerIm(im,prevarea,prevc)
% HAS BUG!!! See registerBw (modified 2/17/2016, haven't checked carefully)
% Find the orientation and the centroid of the hydra in the given image by
% segmenting the image, finding the hydra segmentation using information 
% from the previous frame, and fitting it to an ellipse and compare the 
% edge distribution on the two ends
% SYNOPSIS:
%     [theta,centroid,a,b,rarea] = registerIm(im,prevarea,prevc)
% INPUT:
%     im: image matrix
%     prevarea: number, hydra area from the previous frame
%     prevc: 2-by-1 vector, hydra centroid from the previous frame
% OUTPUT:
%     theta: number, the head orietation of hydra (in degrees)
%     centroid: centroid of hydra
%     a: major axis length of the fitted ellipse
%     b: minor axis length of the fitted ellipse
%     rarea: hydra region area
%
% Shuting Han, 2015

% initialize
dims = size(im);
P = round(size(im,1)*size(im,2)/(50*50));

% segmentation
thresh = multithresh(im,2);
bw = im>thresh(2);
bw = bwareaopen(bw,P);
%bw = bw&(~bg);
bw = bwmorph(bw,'close');
bwfull = im>thresh(1);
bwfull = bwareaopen(bwfull,P);

% fit ellipse
rs = regionprops(logical(bw),'orientation','centroid','majoraxislength',...
    'minoraxislength','area','pixellist');

% if nothing is detected, return NaN
if isempty(rs)
    theta = NaN;
    centroid = [NaN,NaN];
    a = NaN;
    b = NaN;
    rarea = NaN;
    return;
end

% keep the region that is most similar to the previous frame
arg = zeros(length(rs),1);
if nargin<3||isnan(prevarea)
    for i = 1:length(rs)
        arg(i) = rs(i).Area;
    end
    [~,indx] = max(arg);
else
    for i = 1:length(rs)
        arg(i) = sum((rs(i).Centroid-prevc).^2)+sqrt(abs(rs(i).Area-prevarea));
    end
    [~,indx] = min(arg);
end
centroid = rs(indx).Centroid;
theta = rs(indx).Orientation;
% theta = deg2rad(theta);
a = rs(indx).MajorAxisLength;
b = rs(indx).MinorAxisLength;
rarea = rs(indx).Area;
% bodymask = zeros(dims);
% bodymask(sub2ind(dims,rs(indx).PixelList(:,2),rs(indx).PixelList(:,1))) = 1;

% determine head position by comparing edge information on both end
hx = [-1,0,1];
hy = -hx';
gradx = imfilter(bwfull,hx);
gradx(:,1) = 0;
grady = imfilter(bwfull,hy);
grady(end,:) = 0;

% generate patchs
rg(1,:) = [-a a a -a -a]/2;
rg(2,:) = [-a -a a a -a]/2;
theta_rad = pi*theta/180;
rg = [cos(-theta_rad) -sin(-theta_rad);sin(-theta_rad) cos(-theta_rad)]*rg;

% edge around first patch
rg1 = round(rg+(centroid'+[0.4*a*cos(theta_rad);-0.4*a*sin(theta_rad)])*ones(1,5));
mask1 = poly2mask(rg1(1,:),rg1(2,:),dims(1),dims(2));

% edge around second patch
rg2 = round(rg+(centroid'+[-0.4*a*cos(theta_rad);0.4*a*sin(theta_rad)])*ones(1,5));
mask2 = poly2mask(rg2(1,:),rg2(2,:),dims(1),dims(2));

% by edges
edge1 = sum(sum(abs(gradx.*(mask1&bwfull))+abs(grady.*(mask1&bwfull))));
edge2 = sum(sum(abs(gradx.*(mask2&bwfull))+abs(grady.*(mask2&bwfull))));

% adjust orientation
if edge2 > edge1
    theta = theta-180;
end


%% old code
if 0
rg(1,:) = [-a/3 a/3 a/3 -a/3 -a/3];
rg(2,:) = [-a/3 -a/3 a/3 a/3 -a/3];
rg = [cos(-theta) -sin(-theta);sin(-theta) cos(-theta)]*rg;
% edge around first patch
rg1 = round(rg+(centroid'+[0.4*a*cos(theta);-0.4*a*sin(theta)])*ones(1,5));
mask1 = poly2mask(rg1(1,:),rg1(2,:),dims(1),dims(2));
% edge1 = mean([mean(abs(gradx(mask1&(~bodymask)))),...
%     mean(abs(grady(mask1&(~bodymask))))]);
edge1 = mean([mean(abs(double(gradx).*double(mask1&(~bodymask)))),...
    mean(abs(double(grady).*double(mask1&(~bodymask))))]);
% edge around second patch
rg2 = round(rg+(centroid'+[-0.4*a*cos(theta);0.4*a*sin(theta)])*ones(1,5));
mask2 = poly2mask(rg2(1,:),rg2(2,:),dims(1),dims(2));
% edge2 = mean([mean(abs(gradx(mask2&(~bodymask)))),...
%     mean(abs(grady(mask2&(~bodymask))))]);
edge2 = mean([mean(abs(double(gradx).*double(mask2&(~bodymask)))),...
    mean(abs(double(grady).*double(mask2&(~bodymask))))]);

% adjust orientation
theta = rad2deg(theta);
if edge2 > edge1
    theta = theta-180;
end

end

end