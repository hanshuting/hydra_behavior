function [a,b,cent,theta,bw_region] = findEllipseInBw(bw)
% this function finds the largest ellipse that fits into the given binary
% region
% SYNOPSIS:
%     [a,b,cent,theta,bw_region] = findEllipseInBw(bw)
% INPUT:
%     bw: binary matrix, 1 indicates the region to be fitted
% OUTPUT:
%     a,b: long/short axis
%     cent: centroid position
%     theta: orientation of ellipse (in degree)
%     bw_region: the region that is fitted (in case there're multiple)
% 
% Shuting Han, 2016

% find the largest region
rs = regionprops(bw,'area','boundingbox','image');
rareas = zeros(length(rs),1);
for i = 1:length(rs)
    rareas(i) = rs(i).Area;
end
indx = find(rareas==max(rareas(:)));
box_im = rs(indx).Image;
box_pos = rs(indx).BoundingBox(1:2);
box_sz = rs(indx).BoundingBox(3:4);

% this is the image that will be fitted
box_im = imfill(box_im,'holes');
bw_region = false(size(bw));
bw_region(round(box_pos(2)+1:box_pos(2)+box_sz(2)),round(box_pos(1)+1:...
    box_pos(1)+box_sz(1))) = box_im;
bw_region = bw_region(1:size(bw,1),1:size(bw,2));

% now iteratively fit ellipse
count = 0;
while true

    % fit with regionprops
    ellp = regionprops(double(box_im),'Centroid','MajorAxisLength','MinorAxisLength','Orientation');
    if isempty(ellp)
        break;
    end
    cent = ellp.Centroid;
    a = ellp.MajorAxisLength;
    b = ellp.MinorAxisLength;
    theta = ellp.Orientation;

    % make ellipse mask
    [xcoord,ycoord] = plot_ellipse2(ellp,false);
    elmask = false(size(box_im));
    xcoord = round(xcoord);
    ycoord = round(ycoord);
    xcoord(xcoord<1) = 1;
    ycoord(ycoord<1) = 1;
    xcoord(xcoord>box_sz(1)) = box_sz(1);
    ycoord(ycoord>box_sz(2)) = box_sz(2);
    elmask(sub2ind(size(box_im),ycoord,xcoord)) = true;
    elmask = imdilate(elmask,strel('disk',3));
    elmask = imfill(elmask,'holes');
    
    % visualize
%     hold off;imagesc(box_im);colormap(gray);axis equal
%     hold on;plot_ellipse2(ellp);pause(0.01);

    % if less then tol pixesl are not fitted, stop
    tol = sum(elmask(:))*0.3;
    if sum(sum((~box_im)&elmask))<tol || count>10
        % put box back to image
        cent = [box_pos(1),box_pos(2)]+cent;
        break;
    else
        box_im = box_im&elmask;
        count = count+1;
    end
    
end


end