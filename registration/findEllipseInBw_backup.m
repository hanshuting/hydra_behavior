function [a,b,cent,theta,bw_region] = findEllipseInBw_backup(bw)
% this function finds the largest ellipse that fits into the given binary
% region
% SYNOPSIS:
%     [a,b,cent,theta,bw_region] = findEllipseInBw(bw)
% INPUT:
%     bw: binary matrix, 1 indicates the region to be fitted
% OUTPUT:
%     a,b: long/short axis
%     cent: centroid position
%     theta: orientation of ellipse
%     bw_region: the region that is fitted (in case there're multiple)
% 
% Shuting Han, 2016

% find the largest region
rs = regionprops(bw,'area','boundingbox','image');
indx = find(rs.Area==max(rs.Area(:)));
box_im = rs(indx).Image;
box_pos = rs(indx).BoundingBox(1:2);
box_sz = rs(indx).BoundingBox(3:4);

% this is the image that will be fitted
box_im = imfill(box_im,'holes');
bw_region = false(size(bw));
bw_region(round(box_pos(2)+1:box_pos(2)+box_sz(2)),round(box_pos(1)+1:...
    box_pos(1)+box_sz(1))) = box_im;

% get boundary pixels
im_bdr = bwboundaries(box_im,'noholes');
im_bdr = im_bdr{1};
im_bdr = im_bdr(:,[2,1]);

% initialize with regionprops
% ellp = regionprops(box_im,'Centroid','MajorAxisLength','MinorAxisLength','Orientation');
% cent = ellp.Centroid;
% a = ellp.MajorAxisLength;
% b = ellp.MinorAxisLength;
% theta = ellp.Orientation;
tol = 1;
while true
    
    % fit ellipse
    ellp = fit_ellipse(im_bdr(:,1),im_bdr(:,2));
    if isempty(ellp)||(~isempty(ellp)&&isempty(ellp.a))
        break;
    end
    cent = [ellp.X0_in,ellp.Y0_in];
    a = ellp.long_axis/2;
    b = ellp.short_axis/2;
%     theta = pi-ellp.phi;
    theta = ellp.phi;
    
    % find focii
    f = sqrt(a^2-b^2);
    f1 = cent+[f*cos(theta),f*sin(theta)];
    f2 = cent-[f*cos(theta),f*sin(theta)];
    
    % visualize
    hold off;imagesc(box_im);colormap(gray);
    hold on;scatter(im_bdr(:,1),im_bdr(:,2),'y*');
    scatter(f1(1),f1(2),'r*');scatter(f2(1),f2(2),'r*');
    plot_ellipse(a,b,theta,cent(1),cent(2),'r');pause(0.01);
    
    % check boundary pixel distances
    bdr_dist = pdist2(im_bdr,f1)+pdist2(im_bdr,f2);

    % if all boundary pixels are in the ellipse, stop
    if all(abs(bdr_dist-2*a)<tol)||length(bdr_dist)<=5
        % put box back to image
        cent = [box_pos(2),box_pos(1)]+cent;
        break;
    else
        % remove the furthest points
%         [~,keepIndx] = sort(bdr_dist);
        keepIndx = bdr_dist>2*a;
        im_bdr = im_bdr(keepIndx,:);
        
    end
    
end


end