function [] = plotRegionLabel(xx,seg_im,im_mask)
% plotRegionLabel(xx,seg_im,im_mask)
% plot segmentation regions with labels

numPoints = length(xx);
im = double(seg_im);
im = double(im~=0);
im(im_mask==0) = -1;
imagesc(xx,xx,2-im);
colormap(gca,gray);
caxis([-1 2])
axis equal tight xy
title('watershed segmentation');
region_cent = regionprops(double(seg_im).*double(im_mask),'Centroid');
for i = 1:length(region_cent)
    regCoord = region_cent(i).Centroid;
    regNum = seg_im(round(regCoord(2)),round(regCoord(1)));
    if regNum~=0
        h = text(2*regCoord(1)/numPoints*xx(end)-xx(end),...
            2*regCoord(2)/numPoints*xx(end)-xx(end),num2str(regNum));
        set(h,'color','y','fontsize',6);
    end
end

end