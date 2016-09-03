function [theta,centroid,a,b] = registerBw(bw)
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

im = double(bw);
dims = size(im);

% fit ellipse
[a,b,centroid,theta,bw_region] = findEllipseInBw(bw);

% tmp.Centroid = centroid;tmp.Orientation = theta;
% tmp.MajorAxisLength = a;tmp.MinorAxisLength = b;
% imagesc(bw);colormap(gray);axis equal
% hold on;plot_ellipse2(tmp);pause(0.01);

% if nothing is detected, return NaN
if isnan(a)
    return;
end

% generate patchs
rg(1,:) = [-a a a -a -a]/2;
rg(2,:) = [-a -a a a -a]/2;
theta_rad = pi*theta/180;
rg = [cos(-theta_rad) -sin(-theta_rad);sin(-theta_rad) cos(-theta_rad)]*rg;

% dialte body mask to include all edges
bw_region = imdilate(bw_region,strel('disk',3));

% edge around first patch
% stepsz = 10;
rg1 = round(rg+(centroid'+[0.4*a*cos(theta_rad);-0.4*a*sin(theta_rad)])*ones(1,5));
mask1 = poly2mask(rg1(1,:),rg1(2,:),dims(1),dims(2));
% edge1 = sum(sum(abs(gradx.*(mask1&bw_region))+abs(grady.*(mask1&bw_region))));
% bdr1 = bwboundaries(mask1&bw_region,'noholes');
% if ~isempty(bdr1)
%     if size(bdr1,1)>1
%         [rr,~] = cellfun(@size,bdr1);
%         bdr1 = bdr1{rr==max(rr)};
%     else
%         bdr1 = bdr1{1};
%     end
%     bdr1(end+1:end+stepsz,:) = bdr1(1:stepsz,:);
%     edge1 = atan((bdr1(stepsz+1:end,2)-bdr1(1:end-stepsz,2))./...
%         (bdr1(stepsz+1:end,1)-bdr1(1:end-stepsz,1)));
%     edgestd1 = std(edge1);
% else
%     edgestd1 = 0;
% end

% edge around second patch
rg2 = round(rg+(centroid'+[-0.4*a*cos(theta_rad);0.4*a*sin(theta_rad)])*ones(1,5));
mask2 = poly2mask(rg2(1,:),rg2(2,:),dims(1),dims(2));
% edge2 = sum(sum(abs(gradx.*(mask2&bw_region))+abs(grady.*(mask2&bw_region))));
% bdr2 = bwboundaries(mask2&bw_region,'noholes');
% if ~isempty(bdr2)
%     if size(bdr2,1)>1
%         [rr,~] = cellfun(@size,bdr2);
%         bdr2 = bdr2{rr==max(rr)};
%     else
%         bdr2 = bdr2{1};
%     end
%     bdr2(end+1:end+stepsz,:) = bdr2(1:stepsz,:);
%     edge2 = atan((bdr2(stepsz+1:end,2)-bdr2(1:end-stepsz,2))./...
%         (bdr2(stepsz+1:end,1)-bdr2(1:end-stepsz,1)));
%     edgestd2 = std(edge2);
% else
%     edgestd2 = 0;
% end

% by solidity
sld1 = regionprops(double(mask1&bw_region),'solidity');
sld2 = regionprops(double(mask2&bw_region),'solidity');

% adjust orientation
% if edgestd2 > edgestd1
if sld1.Solidity > sld2.Solidity
    theta = theta-180;
end

end