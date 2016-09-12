function [] = plotRegionLabel(seg_im,im_mask,xx)
% plot segmentation regions with labels

imagesc(xx,xx,double(seg_im).*double(im_mask));
colormap(gray);
axis equal tight off xy
title('watershed segmentation');
region_cent = regionprops(double(seg_im).*double(im_mask),'Centroid');
for i = 1:length(region_cent)
    tmpCoord = [region_cent(i).Centroid(1),region_cent(i).Centroid(2)];
    tmpNum = seg_im(round(tmpCoord(2)),round(tmpCoord(1)));
    if tmpNum~=0
        h = text(double(2*maxVal*(tmpCoord(1)-numPoints/2)/numPoints),...
            double(2*maxVal*(tmpCoord(2)-numPoints/2)/numPoints),num2str(tmpNum));
        set(h,'color','y','fontsize',10);
    end
end

end