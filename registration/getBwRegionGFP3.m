function [seg_im,theta,centroid,a,b] = getBwRegionGFP3(im,ifvisualize)
% This version segment the hydra into 6 regions for GFP videos
% SYNOPSIS:
%     [seg_avg,theta,centroid,a,b] = getBwRegion3(im,ifvisualize)
% INPUT:
%     im: image matrix
%     ifvisualize: 1 to plot final result
% OUTPUT:
%     seg_im: matrix with body parts labeling, 1 for foot region, 2 for
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
fgauss = fspecial('gaussian',[3,3],1);
im = imfilter(im,fgauss);

% adjust contrast
im = imadjust(im,[0,1],[0,1],0.1);
% im = adapthisteq(im,'Distribution','uniform');
% im = adapthisteq(im,'Distribution','exponential');

% threshold intensity
thresh = multithresh(im,1);
bw = im>thresh(1);
bw = bwareaopen(bw,P);
bw = imdilate(bw,strel('disk',3));

% convolve with a gaussian filter to detect body
% fgauss = fspecial('gaussian',round(dims/10),round(mean(dims))/40);
% % im_conv = imfilter(im,fgauss);
% im_conv = imfilter(im.*double(bw),fgauss);
% im_conv = im_conv.*double(im_conv>multithresh(im_conv));
% im_conv(im_conv==0) = NaN;
im_conv = imopen(im,strel('disk',round(mean(dims)/50)));
thresh = multithresh(im_conv,1);
bw_conv = im_conv>thresh(1);
bw_conv = imdilate(bw_conv,strel('disk',10));
bw_conv = imerode(bw_conv,strel('disk',10));

% fit ellipse
rs = regionprops(logical(bw&bw_conv),'orientation','centroid','majoraxislength',...
    'minoraxislength','area','pixellist');

arg = zeros(length(rs),1);
for i = 1:length(rs)
    arg(i) = rs(i).Area;
end
[~,indx] = max(arg);
centroid = rs(indx).Centroid;
theta = rs(indx).Orientation;
a = rs(indx).MajorAxisLength;
b = rs(indx).MinorAxisLength;

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
% non ellipse region
non_ellp_region = bwbody&(~ellp_region);

%% registration
% generate patchs
rg(1,:) = [-a a a -a -a]/2;
rg(2,:) = [-a -a a a -a]/2;
rg = [cos(-theta_rad) -sin(-theta_rad);sin(-theta_rad) cos(-theta_rad)]*rg;

rg_left(1,:) = [-a a a -a -a]/2;
rg_left(2,:) = [-a -a 0 0 -a]/2;
rg_left = [cos(-theta_rad) -sin(-theta_rad);sin(-theta_rad) cos(-theta_rad)]*rg_left;

rg_right(1,:) = [-a a a -a -a]/2;
rg_right(2,:) = [0 0 a a 0]/2;
rg_right = [cos(-theta_rad) -sin(-theta_rad);sin(-theta_rad) cos(-theta_rad)]*rg_right;

% patches for the first half ellipse
rg1 = round(rg+(centroid'+[0.5*a*cos(theta_rad);-0.5*a*sin(theta_rad)])*ones(1,5));
mask1 = poly2mask(rg1(1,:),rg1(2,:),dims(1),dims(2));
rg1_left = round(rg_left+(centroid'+[0.5*a*cos(theta_rad);-0.5*a*sin(theta_rad)])*ones(1,5));
mask1_left = poly2mask(rg1_left(1,:),rg1_left(2,:),dims(1),dims(2));
rg1_right = round(rg_right+(centroid'+[0.5*a*cos(theta_rad);-0.5*a*sin(theta_rad)])*ones(1,5));
mask1_right = poly2mask(rg1_right(1,:),rg1_right(2,:),dims(1),dims(2));

% patches for the second half ellipse
rg2 = round(rg+(centroid'+[-0.5*a*cos(theta_rad);0.5*a*sin(theta_rad)])*ones(1,5));
mask2 = poly2mask(rg2(1,:),rg2(2,:),dims(1),dims(2));
rg2_left = round(rg_left+(centroid'+[-0.5*a*cos(theta_rad);0.5*a*sin(theta_rad)])*ones(1,5));
mask2_left = poly2mask(rg2_left(1,:),rg2_left(2,:),dims(1),dims(2));
rg2_right = round(rg_right+(centroid'+[-0.5*a*cos(theta_rad);0.5*a*sin(theta_rad)])*ones(1,5));
mask2_right = poly2mask(rg2_right(1,:),rg2_right(2,:),dims(1),dims(2));

% patch for the entire image
k = -tan(theta_rad);
b = centroid(2)-k*centroid(1);
if b <= dims(2)&&b>0
    rg_left_x = [0,0,dims(1),dims(1),0];
    rg_right_x = rg_left_x;
    rg_left_y = [0,b,k*dims(1)+b,0,0];
    rg_right_y = [dims(2),b,k*dims(1)+b,dims(2),dims(2)];
else
    rg_left_x = [0,0,(dims(2)-b)/k,-b/k,0];
    rg_right_x = [dims(1),dims(1),(dims(2)-b)/k,-b/k,dims(1)];
    rg_left_y = [0,dims(2),dims(2),0,0];
    rg_right_y = rg_left_y;
end
mask_left_all = poly2mask(rg_left_x,rg_left_y,dims(1),dims(2));
mask_right_all = poly2mask(rg_right_x,rg_right_y,dims(1),dims(2));

% determine head orientation
if sum(sum(mask2&non_ellp_region)) > sum(sum(mask1&non_ellp_region))
    theta = theta-180;
    lower_left_mask = mask1_right;
    lower_right_mask = mask1_left;
    upper_left_mask = mask2_right;
    upper_right_mask = mask2_left;
    left_mask = mask_right_all;
    right_mask = mask_left_all;
else
    lower_left_mask = mask2_left;
    lower_right_mask = mask2_right;
    upper_left_mask = mask1_left;
    upper_right_mask = mask1_right;
    left_mask = mask_left_all;
    right_mask = mask_right_all;
end

%% segment body parts

% over-segment the image
int_marker = bwmorph(bwbody,'skel',Inf);
% int_marker = false(dims);
% int_marker(bwskel) = true;

% force local minima
int_marker = imdilate(int_marker,strel('disk',5));
intm_dist = imcomplement(bwdist(bwbody&(~int_marker)));

% watershed
osreg = double(watershed(intm_dist));
seg_line = (osreg==0).*bwbody;
osreg = osreg.*bwbody;

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

upper_left = body_patch&upper_left_mask;
upper_right = body_patch&upper_right_mask;
lower_left = body_patch&lower_left_mask;
lower_right = body_patch&lower_right_mask;
tent_left = non_ellp_region&(~lower_left)&(~lower_right)&(~upper_left)...
    &(~upper_right)&left_mask;
tent_right = non_ellp_region&(~lower_left)&(~lower_right)&(~upper_left)...
    &(~upper_right)&right_mask;

seg_im = NaN(dims);
seg_im(lower_left) = 1;
seg_im(lower_right) = 2;
seg_im(upper_left) = 3;
seg_im(upper_right) = 4;
seg_im(tent_left) = 5;
seg_im(tent_right) = 6;
seg_im(isnan(seg_im)) = 0;


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