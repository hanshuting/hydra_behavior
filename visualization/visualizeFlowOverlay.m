function [] = visualizeFlowOverlay(movieParam,uu,vv,grid_step,ifsave)
% visualize optical flow with overlay raw video
% SYNOPSIS:
%     visualizeFlowOverlay(movieParam,uu,vv,grid_step,ifsave)
% INPUT:
%     movieParam: a struct returned by paramAll
%     uu,vv: x and y optical flow
%     grid_step: size of meshgrid for quiver plot
%     ifsave: 1 to save video
% 
% Shuting Han, 2015

[xx,yy] = meshgrid(1:grid_step:movieParam.imageSize(2),...
    1:grid_step:movieParam.imageSize(1));

hf = figure;
set(gcf,'color','k');

if ifsave
    c = clock;
    writerobj = VideoWriter(['C:\Users\shuting\Desktop\temp\outputs\' ...
        num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))...
        num2str(round(c(6))) '.avi']);
    open(writerobj);
end

for i = 1:movieParam.numImages-1
    
    im = double(imread([movieParam.filePath movieParam.fileName '.tif'],i));
    imagesc(im); colormap(gray);
    hold on;
    quiver(xx,yy,squeeze(uu(1:grid_step:end,1:grid_step:end,i)),...
        squeeze(vv(1:grid_step:end,1:grid_step:end,i)),'r');
    title(['frame ' num2str(i)],'color','w');
    pause(0.01);
    
    if ifsave
        F = getframe(hf);
        writeVideo(writerobj,F);
    end
    
end

if ifsave
    close(writerobj);
end

close(hf);

end