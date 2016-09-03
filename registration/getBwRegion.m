function [seg_avg,theta,centroid,a,b] = getBwRegion(im,ifvisualize)
% SYNOPSIS:
%     [lower_body,upper_body,tent_region,theta,centroid,a,b] = ...
%       getBwRegion(im)
% INPUT:
%     im: image matrix
% OUTPUT:
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
P = round(size(im,1)*size(im,2)/(50*50));

%% segmentation
% smooth image
% sig = 1;
% fgauss = fspecial('gauss',4*sig+1,sig);
% im = imfilter(im,fgauss);

% segmentation body
thresh = multithresh(im,2);
bw = im>thresh(2);
bw = bwareaopen(bw,P);
bw = bwmorph(bw,'close');

% segmentation full
bwfull = im>thresh(1);
bwfull = bwareaopen(bwfull,P);
bwfull = imdilate(bwfull,strel('disk',3));

% fit ellipse
rs = regionprops(logical(bw),'orientation','centroid','majoraxislength',...
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
bwfull_pixels = regionprops(bwfull,'pixellist');
bwfull_pixels = cell2mat(squeeze(struct2cell(bwfull_pixels))');
bodyindx = pdist2(bwfull_pixels,f1)+pdist2(bwfull_pixels,f2)<=a;
ellp_region = zeros(dims);
ellp_region(sub2ind(dims,bwfull_pixels(bodyindx,2),bwfull_pixels(bodyindx,1))) = 1;
non_ellp_region = bwfull&(~ellp_region);

%% registration
% generate patchs
rg(1,:) = [-a a a -a -a]/2;
rg(2,:) = [-a -a a a -a]/2;
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

%% segment body parts
seg_avg = zeros([dims,10],'uint8');
for nn = 1:10
% over-segment the image
% bwskel = bwmorph(bwfull,'skel',Inf);
% bcp = bwmorph(bwskel,'branchpoint');
% bcp = imdilate(bcp,strel('square',3));
% centskel = regionprops(bwskel&(~bcp),'Centroid');
% centskel = round(cell2mat(squeeze(struct2cell(centskel))'));
% int_marker = false(dims);
% int_marker(sub2ind(dims,centskel(:,2),centskel(:,1))) = true;
% int_marker(bwskel&(~bcp)) = true;

% use random dots to generate internal marker
num_marker = 30;
markers = bwfull_pixels(randperm(size(bwfull_pixels,1),num_marker),:);
int_marker = false(dims);
int_marker(sub2ind(dims,markers(:,2),markers(:,1))) = true;

% force local minima
int_marker = imdilate(int_marker,strel('disk',3));
intm_dist = imcomplement(bwdist(bwfull&(~int_marker)));

% watershed
osreg = double(watershed(intm_dist));
seg_line = (osreg==0).*bwfull;
osreg = osreg.*bwfull;

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

upper_body = body_patch&upper_mask;
lower_body = body_patch&lower_mask;
tent_region = non_ellp_region&(~lower_body)&(~upper_body);

seg_im = NaN(dims);
seg_im(lower_body) = 1;
seg_im(upper_body) = 2;
seg_im(tent_region) = 3;
seg_avg(:,:,nn) = seg_im;

end

seg_avg = mode(seg_avg,3);
seg_avg(isnan(seg_avg)) = 0;

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