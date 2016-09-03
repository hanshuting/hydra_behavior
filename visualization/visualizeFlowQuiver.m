function [] = visualizeFlowQuiver(uu,vv,movieParam,fr)
% visualize optical flow by quiver plot
% SYNOPSIS:
%     visualizeFlowQuiver(uu,vv,movieParam,fr)
% INPUT:
%     uu,vv: x and y optical flow
%     movieParam: a struct returned by paramAll
%     fr: frame rate of output movie
%
% Shuting Han, 2015

grid_step = 5;
[xx,yy] = meshgrid(1:grid_step:movieParam.imageSize(2),...
    1:grid_step:movieParam.imageSize(1));

hf = figure;
for i = 1:size(uu,3)
    
%     im = double(imread([movieParam.filePath movieParam.fileName '.tif'],i));
%     im_reg = imrotate(imtranslate(im,[movieParam.imageSize(1)/2-centroids(i,1)...
%         movieParam.imageSize(2)/2-centroids(i,2)]),90-thetas(i),'crop');
%     imagesc(bw(:,:,i));colormap(gray);
%     hold on;
    quiver(xx,yy,squeeze(uu(1:grid_step:end,1:grid_step:end,i)),...
        squeeze(vv(1:grid_step:end,1:grid_step:end,i)),'r');
    xlim([0 movieParam.imageSize(1)]);
    ylim([0 movieParam.imageSize(2)]);
    title(num2str(i));
    pause(fr);
    hold off
    
    keypressed=get(hf,'currentkey');
    if keypressed=='e'
        close(hf);
        break;
    end
    
end

end