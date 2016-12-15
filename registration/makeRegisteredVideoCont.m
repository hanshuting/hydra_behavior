function [segmat] = makeRegisteredVideoCont(fileIndx,mask,timeStep,...
    dpath,segpath,videopath,ifscale,outputsz)
% generate registered video clips for Dense Trajectory code (segment,
% align, and scale)
% SYNOPSIS:
%     [segmat] = makeRegisteredVideo(fileIndx,mask,timeStep,skipStep,...
%         dpath,segpath,videopath,ifscale,outputsz)
% INPUT:
%     fileIndx: index of video file to be processed (see fileinfo.m)
%     timeStep: number of frames for each video clip
% 
% Shuting Han, 2015

% parameters
movieParam = paramAll(dpath,fileIndx);
timeLength = timeStep/movieParam.fr;
fprintf('making videos for %s...\n',movieParam.fileName);

% load registration data
load([segpath movieParam.fileName '_seg.mat']);
clear segAll
tt = size(mask,3)-timeStep;

% initialize
segmat = zeros([outputsz,tt],'uint8');

% set saving parameters
savename = [movieParam.fileName '_' num2str(timeLength) 's_0.5'];
mkdir(videopath,savename);

% generate registered video
frscale = outputsz(1)/3/nanmean(a);
for i = 1:tt
        
    % averaged mask in the time window
    frbw = any(mask(:,:,i:i+timeStep-1),3);
    
    if ifscale
        frbw = scaleImage(frbw,outputsz,frscale);
    end

    % create video file
    writerobj = VideoWriter([videopath savename '\' savename '_' ...
        num2str(i,'%04d') '.avi']);
    open(writerobj);
    
    avg_theta = trimmean(theta(i:i+timeStep-1),50);
    avg_cent = round(trimmean(centroid(i:i+timeStep-1,:),50,1));
    
    for j = 1:timeStep
            
        % registration
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],i+j));
        if ~isnan(avg_theta)
            im = imrotate(imtranslate(im,[movieParam.imageSize(2)/2-...
                avg_cent(1) movieParam.imageSize(1)/2-...
                avg_cent(2)]),90-avg_theta,'crop');
        end
        
        % scale
        if ifscale
            im = scaleImage(im,outputsz,frscale);
        end
        
        % keep only the segmented region
        im = im.*frbw;
        
        % write video
        im = uint8(im);
        writeVideo(writerobj,im);

        % register mask
        seg_im = mask(:,:,i+j);
        seg_im(seg_im==0) = NaN;
        seg_im = scaleImage(seg_im,outputsz,frscale);
        seg_im = round(seg_im);
        seg_im(isnan(seg_im)) = 0;
        segmat(:,:,i+j) = uint8(seg_im);
    end
    
    % close file
    close(writerobj);

end

end