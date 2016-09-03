function [theta,centroid,a,b] = registerDataCD(im,bg)

% find the orientation and the centroid of the hydra in the given image
% theta: angle that rotate hydra to vertical position
% centroid: centroid of hydra body

P = round(size(im,1)*size(im,2)/(50*50));

thresh = multithresh(im,6);
bw1 = im>thresh(5);
%bw2 = im>thresh(3);
bw1 = bwareaopen(bw1,P);
%bw2 = bwareaopen(bw2,P);

% filter out background
bw1 = bw1&(~bg);
%bw2 = bw2&(~bg);

% fit ellipse
rs2 = regionprops(logical(bw1),'centroid','area');
bw1 = imfill(bw1,'holes');
bw1 = bwmorph(bw1,'thicken');
bw1 = imopen(bw1,strel('disk',3));
rs1 = regionprops(logical(bw1),'orientation','centroid','majoraxislength','minoraxislength','area');
%rs2 = regionprops(logical(bw2),'centroid','area');

% if nothing is detected, return NaN
if isempty(rs1)
    theta = NaN;
    centroid = [NaN,NaN];
    a = NaN;
    b = NaN;
    return;
end

% keep the region with largest area
ar = zeros(length(rs1),1);
for i = 1:length(rs1)
    ar(i) = rs1(i).Area;
end
[~,indx] = max(ar);
centroid = rs1(indx).Centroid;
theta = rs1(indx).Orientation;
a = rs1(indx).MajorAxisLength;
b = rs1(indx).MinorAxisLength;

ar = zeros(length(rs2),1);
for i = 1:length(rs2)
    ar(i) = rs2(i).Area;
end
[~,indx] = max(ar);
centroid2 = rs2(indx).Centroid;

%hold on;plot_ellipse2(rs1);

% adjust orientation
if (centroid(2)-centroid2(2))*theta < 0
    theta = theta+180;
end
%theta = 90-theta;


end