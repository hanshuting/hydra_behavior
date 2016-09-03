function [segmat] = makeRegisteredVideo(fileIndx,mask,timeStep,skipStep,...
    filepath,savepath,ifscale,outputsz)
% generate registered video clips for Dense Trajectory code (segment,
% align, and scale)
% SYNOPSIS:
%     makeRegisteredVideo(fileindx,timeStep)
% INPUT:
%     fileIndx: index of video file to be processed (see fileinfo.m)
%     timeStep: number of frames for each video clip
% 
% Shuting Han, 2015

% parameters
% rho = 1/25;
brightness_scale = 0.5;
movieParam = paramAll(fileIndx);
timeLength = timeStep*skipStep/movieParam.fr;
fprintf('processing file %s...\n',movieParam.fileName);

% load registration data
load([filepath movieParam.fileName '_seg.mat']);
clear segAll
tt = floor(size(mask,3)/timeStep/skipStep);

segmat = zeros([outputsz,tt],'uint8');

% set saving parameters
savename = [movieParam.fileName '_' num2str(timeLength) 's_0.5'];
mkdir(savepath,savename);

% generate registered video
hf = figure;
set(hf,'position',[300,300,outputsz(1),outputsz(2)]);
frscale = outputsz(1)/3/mean(a);
for i = 1:tt
    
%     fprintf('time window %u\n',i);
        
    % averaged mask in the time window
    frbw = any(mask(:,:,(i-1)*timeStep*skipStep+1:skipStep:i*timeStep*skipStep),3);
    
    if ifscale
%         avg_a = mean(a((i-1)*timeStep*skipStep+1:skipStep:i*timeStep*skipStep));
%         avg_b = mean(b((i-1)*timeStep*skipStep+1:skipStep:i*timeStep*skipStep));
%         frscale = outputsz(1)/4/avg_a;
        frbw = scaleImage(frbw,outputsz,frscale);
    end

    % create video file
    writerobj = VideoWriter([savepath savename '\' savename '_' ...
        num2str(i,'%04d') '.avi']);
    open(writerobj);
    
    avg_theta = trimmean(theta((i-1)*timeStep*skipStep+1:skipStep:i*timeStep*skipStep),50);
    avg_cent = round(trimmean(centroid((i-1)*timeStep*skipStep+1:skipStep:...
        i*timeStep*skipStep,:),50,1));
    
    for j = 1:timeStep
            
        % registration
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],...
            (i-1)*timeStep*skipStep+(j-1)*skipStep+1));
        im = imrotate(imtranslate(im,[movieParam.imageSize(2)/2-...
            avg_cent(1) movieParam.imageSize(1)/2-...
            avg_cent(2)]),90-avg_theta,'crop');
        
        % smooth image (for gcamp)
%         im = imfilter(im,fgauss);
        
        % get scale
        if i==1&&j==1
            im_min = min(im(:));
            im_max = max(im(:));
        end
        
        % scale
        if ifscale
            im = scaleImage(im,outputsz,frscale);
        end
        
        % keep only the segmented region
        im = im.*frbw;
        
        % visualization
        imagesc(im);colormap(gray);tightfig;axis off;
        caxis([im_min (im_max-im_min)*brightness_scale+im_min]);
        set(gca,'xtick',[],'ytick',[],'position',[0 0 1 1]);
        set(hf,'position',[300,300,outputsz(1),outputsz(2)]);
        pause(0.01);
    
        % write file
        F = getframe(hf);
        writeVideo(writerobj,F);

        % register mask
        seg_im = mask(:,:,(i-1)*timeStep*skipStep+(j-1)*skipStep+1);
        seg_im(seg_im==0) = NaN;
        seg_im = scaleImage(seg_im,outputsz,frscale);
        seg_im = round(seg_im);
        seg_im(isnan(seg_im)) = 0;
        segmat(:,:,(i-1)*timeStep+j) = uint8(seg_im);
    end
    
    % close file
    close(writerobj);

end

close(hf);

end