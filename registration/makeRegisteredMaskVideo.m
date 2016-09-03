function [] = makeRegisteredMaskVideo(fileIndx,timeStep)
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
outputsz = [300,300];
% savepath = 'C:\Shuting\Data\DT_results\chopped_data\scaled_mask\';
% parampath = 'C:\Shuting\Data\DT_results\register_param\';
savepath = 'C:\Shuting\Data\DT_results\chopped_data\seg\';
parampath = 'C:\Shuting\Data\DT_results\register_param\reg_seg\';
movieParam = paramAll(fileIndx);
timeLength = timeStep/movieParam.fr;
fprintf('processing file %s...\n',movieParam.fileName);

% load registration data
mask = load([parampath movieParam.fileName '_reg_seg.mat']);
mask = struct2array(mask);
numCube = floor(size(mask,3)/timeStep);

% set saving parameters
savename = [movieParam.fileName '_' num2str(timeLength) 's_0.5'];
mkdir(savepath,savename);

% generate registered video
hf = figure;
set(hf,'position',[300,300,outputsz(1),outputsz(2)]);
for i = 1:numCube
    
    mask_area = sum(logical(mask(:,:,(i-1)*timeStep+1:i*timeStep)),1);
    mask_area = sum(mask_area,2);
    mask_area = mean(mask_area);
    
    for j = 1:timeStep

        % create file
        if j==1
            writerobj = VideoWriter([savepath savename '\' savename '_' ...
                num2str(i,'%04d') '.avi']);
            open(writerobj);
        end

        % keep only the segmented region
        im = double(mask(:,:,(i-1)*timeStep+j));

        % scale
%         im = imresize(im,hydrasz/hydraLength(i));
        im = imresize(im,outputsz(1)*outputsz(2)/(25*mask_area));
        imrsz = size(im);
        im_final = zeros(size(im,1)+outputsz(1),size(im,2)+outputsz(2));
        im_final(round((size(im_final,1)-imrsz(1))/2)+1:...
            round((size(im_final,1)-imrsz(1))/2)+imrsz(1),...
            round((size(im_final,2)-imrsz(2))/2)+1:...
            round((size(im_final,2)-imrsz(2))/2)+imrsz(2)) = im;
        im_final = im_final(round((size(im_final,1)-outputsz(1))/2)+1:...
            round((size(im_final,1)-outputsz(1))/2)+outputsz(1),...
            round((size(im_final,2)-outputsz(2))/2)+1:...
            round((size(im_final,2)-outputsz(2))/2)+outputsz(2));
        
        % visualization
        imagesc(im_final);colormap(gray);tightfig;axis off;
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