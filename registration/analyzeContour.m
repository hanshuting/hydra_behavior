function [theta,a,b,mint] = analyzeContour(movieParam,ifInvert,ifVisualize,ifSave)

% a script for analyzing contours of epithelial imaging data
% Input:
%     movieParam: struct array
%     ifInvert: 1 if need to invert the gray scale image, 0 otherwise
% Output:
%     bw: a binary matrix of binarized video
%     bg: a binary matrix of background mask
%     theta: estimated orientation of the animal
%     a: estimated length of the animal
%     b: estimated width of the animal

%% initialization

%movieParam = paramAll(fileind);
nthresh = [2,1];

% initialization
theta = zeros(movieParam.numImages,1);
a = zeros(movieParam.numImages,1);
b = zeros(movieParam.numImages,1);
mint = zeros(movieParam.numImages,1);


%% calculate background
[~,bg] = gnMaskCD(movieParam,nthresh,ifInvert);

%% fit ellipses
% visualization option
if ifVisualize
    hf = figure;
    set(hf,'color','w');
    if ifSave
        c = clock;
        writerobj = VideoWriter(['C:\Users\shuting\Desktop\temp\outputs\' ...
            num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) ...
            num2str(c(5)) num2str(round(c(6))) '.avi']);
        open(writerobj);
    end
end

% estimate hydra parameters
for i = 1:movieParam.numImages
    
    im = double(imread([movieParam.filePath movieParam.fileName '.tif'],...
        i+movieParam.frameStart-1));
    
    % invert color
    if ifInvert
        im = 255-im;
    end
    
    % calculate mean intensity
    thresh = multithresh(im,2);
    imbw = im>thresh(1);
    mint(i) = mean(im(imbw&~bg));
    
    % adjust brightness scale
    immax = max(im(:));
    im = round(im/immax*255);
    
    % align and fit ellipse
    if i==1
        [theta(i),centroid,a(i),b(i),rarea] = registerImCD(im,bg,nthresh);
    else
        [theta(i),centroid,a(i),b(i),rarea] = registerImCD(im,bg,nthresh,...
            rareaprev,aprev,bprev,centroidprev);
    end
    centroidprev = centroid;
    aprev = a(i);
    bprev = b(i);
    rareaprev = rarea;
    
    % visualization option
    if ifVisualize
        imagesc(im);colormap(gray);title(num2str(i));
        axis equal tight;
        tmp.Centroid = centroid;tmp.MajorAxisLength=a(i);
        tmp.MinorAxisLength=b(i);tmp.Orientation=theta(i);
        hold on;plot_ellipse2(tmp);
        quiver(centroid(1),centroid(2),cos(degtorad(theta(i)))*a(i),...
            -sin(degtorad(theta(i)))*a(i));
        xlim([0 movieParam.imageSize(2)]);ylim([0 movieParam.imageSize(1)]);
        hold off
        pause(0.01);
        if ifSave
            F = getframe(hf);
            writeVideo(writerobj,F);
        end
    end
end

if ifVisualize
    close(hf);
end


if ifSave
    close(writerobj);
    close(hf);
end


%% plot length and width

% smooth by gaussian
gwidth = 5; gsig = 1;
gf = fspecial('gaussian',[gwidth,1],gsig);
sa = conv(a,gf,'same');
sb = conv(b,gf,'same');

% plot
frameindx = movieParam.frameStart:movieParam.frameEnd;
frameindx = (frameindx+1)';
figure;set(gcf,'color','w');
plot(frameindx,sa);
hold on;
plot(frameindx,sb,'r')
xlabel('time(frame)'); ylabel('pixel');
title(movieParam.fileName,'Interpreter','none')
legend('length','width');


end