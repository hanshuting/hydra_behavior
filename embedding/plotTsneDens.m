function [] = plotTsneDens(xx,dens,im_mask,cmax)
% plotTsneDens(xx,dens,im_mask,cmax)
% plot the given density map matrix on current axis handle

% fill empty regions with NaNs
im = dens;
im(im_mask==0) = NaN;

% plot
pcolor(xx,xx,im)
pos = get(gca,'position');
% set(gca,'position',pos.*[1 1 1.2 1.2])
shading flat
axis equal tight off xy
caxis([0 cmax])
colormap(jet);
colorbar
set(gca,'position',pos)

end