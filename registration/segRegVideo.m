function [segmat] = segRegVideo(movieParam,mask,a,b,theta,centroid,locs,...
    videosavepath,outputsz,ifscale)
% generate registered video clips for Dense Trajectory code (segment,
% align, and scale)
% this version segment the video given segmentation points (locs)
% SYNOPSIS:
%     [segmat] = segRegVideo(movieParam,mask,a,b,theta,centroid,locs,...
%         videosavepath,outputsz,ifscale)
% INPUT:
%     movieParam: see fileinfo.m
% OUTPUT:
%     segmat: registered and scaled body part segmentation matrix
% 
% Shuting Han, 2016

% parameters
% rho = 1/25;
brightness_scale = 1.5;
% outputsz = [300,300];
% savepath = 'C:\Shuting\Data\DT_results\chopped_data\seg\3parts_20160328\';
dims = size(mask);
segmat = zeros([outputsz dims(3)],'uint8');
fprintf('processing file %s...\n',movieParam.fileName);
numVideo = length(locs)-1;
% locs = [1;locs];

if ~ifscale
    frscale = 1;
else
    frscale = 100/mean(a);
end

% set saving parameters
savename = movieParam.fileName;
mkdir(videosavepath,savename);

% generate registered video
hf = figure;
set(hf,'position',[300,300,outputsz(1),outputsz(2)]);

for i = 1:numVideo
    
%     fprintf('time window %u\n',i);

    % start and end frame
    fstart = locs(i);
    fend = locs(i+1)-1;
    
    % take the average angle and centroid in the time window
    avg_theta = 90-trimmean(theta(fstart:fend),50);
    avg_cent = round(trimmean(centroid(fstart:fend,:),50,1));
    
    %% register and scale mask
    for j = 1:fend-fstart+1
        reg_slice = squeeze(double(mask(:,:,fstart+j-1)));
        reg_slice = imtranslate(reg_slice,int8([dims(2)/2-avg_cent(1)...
            dims(1)/2-avg_cent(2)]));
        reg_slice(reg_slice==0) = NaN;
        reg_slice = imrotate(reg_slice,avg_theta,'crop');
        reg_slice = scaleImage(reg_slice,outputsz,frscale);
        reg_slice(isnan(reg_slice)) = 0;
        segmat(:,:,fstart+j-1) = uint8(reg_slice);
    end
    
    %% make registered videos
    % averaged mask in the time window
    frbw = any(segmat(:,:,fstart:fend),3);

    % create video file
    writerobj = VideoWriter([videosavepath savename '\' savename '_' ...
        num2str(i,'%04d') '.avi']);
    open(writerobj);
    
    for j = 1:fend-fstart+1
            
        % registration
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],...
            fstart-1+j));
        im = imrotate(imtranslate(im,[movieParam.imageSize(2)/2-...
            avg_cent(1) movieParam.imageSize(1)/2-...
            avg_cent(2)]),avg_theta,'crop');
        
        % smooth image (for gcamp)
%         im = imfilter(im,fgauss);
        
        % get scale
        if j==1
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

    end
    
    % close file
    close(writerobj);

end

close(hf);

end