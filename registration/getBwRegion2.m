function [seg_im,theta,centroid,a,b] = getBwRegion2(im,ifvisualize)
% SYNOPSIS:
%     [seg_avg,theta,centroid,a,b] = getBwRegion2(im,ifvisualize)
% INPUT:
%     im: image matrix
%     ifvisualize: 1 to plot final result
% OUTPUT:
%     seg_avg: matrix with body parts labeling, 1 for foot region, 2 for
%     upper body region, 3 for tentacle region
%     theta: number, the head orietation of hydra (in degrees)
%     centroid: centroid of hydra
%     a: major axis length of the fitted ellipse
%     b: minor axis length of the fitted ellipse
%
% Shuting Han, 2016

%% check input
if nargin < 2
    ifvisualize = false;
end

%% parameters
dims = size(im);
P = round(size(im,1)*size(im,2)/(20*20));

%% segmentation
im = mat2gray(im);

% smooth image
% sig = 1;
% fgauss = fspecial('gauss',4*sig+1,sig);
fgauss = fspecial('gaussian',3,1);
% im = imfilter(im,fgauss);

% substract background, adjust contrast
im_bkg = imopen(im,strel('disk',15));
im = im-im_bkg;
im = imadjust(im-im_bkg);
% im = imadjust(im);
% im = adapthisteq(im,'Distribution','uniform'); % - comment for night dataset
% im = wiener2(im); % - for night dataset

% threshold intensity
% thresh = multithresh(im,1);
% bw = im>thresh(1);
% im_seg = EMSeg(im,3);
im_seg = reshape(kmeans(im(:),3),dims(1),dims(2));
bw = im_seg~=mode(im_seg(:));

% threshold area
bw = bwareaopen(bw,P);
bw = imdilate(bw,strel('disk',3));

% convolve with a gaussian filter to detect body
im_conv = imfilter(im,fgauss);
im_conv = im_conv.*double(im_conv>multithresh(im_conv));
im_conv(im_conv==0) = NaN;
thresh = multithresh(im_conv);
bw_conv = im_conv>thresh;
bw_conv = imdilate(bw_conv,strel('disk',3));

% fit ellipse
rs = regionprops(logical(bw&bw_conv),'orientation','centroid','majoraxislength',...
    'minoraxislength','area','pixellist');
if isempty(rs)
    centroid = NaN;
    theta = NaN;
    a = NaN;
    b = NaN;
    seg_im = NaN(size(im));
    return;
else
    arg = zeros(length(rs),1);
    for i = 1:length(rs)
        arg(i) = rs(i).Area;
    end
    [~,indx] = max(arg);
    centroid = rs(indx).Centroid;
    theta = rs(indx).Orientation;
    a = rs(indx).MajorAxisLength;
    b = rs(indx).MinorAxisLength;
end

% separate body and tentacles
theta_rad = pi*theta/180;
f = sqrt((a/2)^2-(b/2)^2);
f1 = centroid+[f*cos(theta_rad),-f*sin(theta_rad)];
f2 = centroid-[f*cos(theta_rad),-f*sin(theta_rad)];
rs_bwfull = regionprops(bw,'pixellist');
bwpixel_all = cell2mat(struct2cell(rs_bwfull)');

% ellipse region
bodyindx = pdist2(bwpixel_all,f1)+pdist2(bwpixel_all,f2)<=a;
ellp_region = zeros(dims);
ellp_region(sub2ind(dims,bwpixel_all(bodyindx,2),bwpixel_all(bodyindx,1))) = 1;

% whole body region
bwfull_area = zeros(length(rs_bwfull),1);
for i = 1:length(rs_bwfull)
    bwfull_part = false(dims);
    bwfull_part(sub2ind(dims,rs_bwfull(i).PixelList(:,2),...
        rs_bwfull(i).PixelList(:,1))) = 1;
    bwfull_area(i) = sum(sum(bwfull_part&ellp_region));
end
[~,bw_indx] = max(bwfull_area);
bwfull_pixels = rs_bwfull(bw_indx).PixelList;
bwbody = zeros(dims);
bwbody(sub2ind(dims,bwfull_pixels(:,2),bwfull_pixels(:,1))) = 1;
non_ellp_region = bwbody&(~ellp_region);

%% registration
% generate patchs
rg(1,:) = [-a a a -a -a]/2;
rg(2,:) = [-a -a a a -a]/2;
% rg(1,:) = [-b b a -b -b]/2;
% rg(2,:) = [-b -b a b -b]/2;
rg = [cos(-theta_rad) -sin(-theta_rad);sin(-theta_rad) cos(-theta_rad)]*rg;

% edge around first patch
rg1 = round(rg+(centroid'+[0.5*a*cos(theta_rad);-0.5*a*sin(theta_rad)])*ones(1,5));
mask1 = poly2mask(rg1(1,:),rg1(2,:),dims(1),dims(2));

% edge around second patch
rg2 = round(rg+(centroid'+[-0.5*a*cos(theta_rad);0.5*a*sin(theta_rad)])*ones(1,5));
mask2 = poly2mask(rg2(1,:),rg2(2,:),dims(1),dims(2));

% determine head orientation
if sum(sum(mask2&non_ellp_region)) > sum(sum(mask1&non_ellp_region))
    theta = theta-180;
    lower_mask = mask1;
    upper_mask = mask2;
else
    lower_mask = mask2;
    upper_mask = mask1;
end

%% body parts
upper_body = ellp_region&upper_mask;
lower_body = bwbody&lower_mask;
tent_region = bwbody&(~lower_body)&(~upper_body);

seg_im = NaN(dims);
seg_im(lower_body) = 1;
seg_im(upper_body) = 2;
seg_im(tent_region) = 3;
seg_im(isnan(seg_im)) = 0;


%% segment body parts
if 0
% over-segment the image
bwskel = bwmorph(bw,'skel',Inf);
bcp = bwmorph(bwskel,'branchpoint');
bcp = imdilate(bcp,strel('square',3));
int_marker = false(dims);
int_marker(bwskel&(~bcp)) = true;

% use random dots to generate internal marker
% gridsz = 20;
% [xx,yy] = meshgrid(min(bwfull_pixels(:,1))-gridsz:gridsz:max(bwfull_pixels(:,1))+gridsz,...
%     min(bwfull_pixels(:,2))-gridsz:gridsz:max(bwfull_pixels(:,2))+gridsz);
% markers=[xx(:),yy(:)];
% int_marker = false(dims);
% int_marker(sub2ind(dims,markers(:,2),markers(:,1))) = true;

% force local minima
int_marker = imdilate(int_marker,strel('disk',3));
intm_dist = imcomplement(bwdist(bw&(~int_marker)));

% watershed
osreg = double(watershed(intm_dist));
seg_line = (osreg==0).*bw;
osreg = osreg.*bw;

% get the region directly connected with the ellipse patch
body_patch = zeros(dims);
cc = bwconncomp(osreg);
for i = 1:cc.NumObjects
    cc_patch = zeros(dims(1)*dims(2),1);
    cc_patch(cc.PixelIdxList{i}) = 1;
    cc_patch = reshape(cc_patch,dims(1),dims(2));
    cc_bdr = seg_line&imdilate(cc_patch,strel('square',3));
    if sum(sum(cc_patch&ellp_region)) > 0
        body_patch = body_patch|cc_patch|cc_bdr;
    end
end

% body_patch = bwbody;

upper_body = body_patch&upper_mask;
lower_body = body_patch&lower_mask;
tent_region = non_ellp_region&(~lower_body)&(~upper_body);

seg_im = NaN(dims);
seg_im(lower_body) = 1;
seg_im(upper_body) = 2;
seg_im(tent_region) = 3;
seg_im(isnan(seg_im)) = 0;

end

%% visualization
if ifvisualize
    imagesc(im);colormap(gray);
    axis equal tight;
    hold on;plot_ellipse2(rs(indx));
    quiver(rs(indx).Centroid(1),rs(indx).Centroid(2),cos(degtorad(rs(indx).Orientation))*...
    rs(indx).MajorAxisLength,-sin(degtorad(rs(indx).Orientation))*rs(indx).MajorAxisLength);
    xlim([0 dims(1)]);ylim([0 dims(2)]);
    hold off
    pause(0.01);
end

end