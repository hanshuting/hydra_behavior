function [] = makeRegisteredVideoCont(fileIndx,timeStep)
% generate registered video clips for Dense Trajectory code
% SYNOPSIS:
%     makeRegisteredVideo(fileindx,timeStep)
% INPUT:
%     fileIndx: index of video file to be processed (see fileinfo.m)
%     timeStep: number of frames for each video clip
% 
% Shuting Han, 2015

% parameters
savepath = 'C:\Shuting\Data\DT_results\chopped_data\cont\';
parampath = 'C:\Shuting\Data\DT_results\register_param\';
movieParam = paramAll(fileIndx);
timeLength = timeStep/movieParam.fr;
fprintf('processing file %s...\n',movieParam.fileName);

% load registration data
load([parampath movieParam.fileName '_results_params_step_1.mat']);
numCube = length(hydraLength);

% set saving parameters
savename = [movieParam.fileName '_' num2str(timeLength) 's_0.5'];
mkdir(savepath,savename);

% generate registered video
hf = figure;
set(hf,'position',[300,300,movieParam.imageSize(1),movieParam.imageSize(2)]);
for i = 1:numCube
    
%     fprintf('time window %u\n',i);
    
    % averaged mask in the time window
    frbw = any(bwReg(:,:,i:i+timeStep),3);
    
    % dilate mask
    frbw = imdilate(frbw,strel('disk',5));
    
    for j = 1:timeStep

        % create file
        if j==1
            writerobj = VideoWriter([savepath savename '\' savename '_' ...
                num2str(i,'%04d') '.avi']);
            open(writerobj);
        end

        % registration
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],i+j));
        im = imrotate(imtranslate(im,[movieParam.imageSize(1)/2-...
            hydraCent(i,1) movieParam.imageSize(2)/2-...
            hydraCent(i,2)]),90-hydraOri(i),'crop');
        
        % keep only the segmented region
        im = im.*frbw;
        
        % visualization
        imagesc(im);colormap(gray);tightfig;axis off;
        caxis([min(im(:)) max(im(:))*0.8]);
        set(gca,'xtick',[],'ytick',[],'position',[0 0 1 1]);
        set(hf,'position',[300,300,movieParam.imageSize(1),movieParam.imageSize(2)]);
        pause(0.01);
    
        % write file
        F = getframe(hf);
        writeVideo(writerobj,F);

%     im = uint8(im);
%     imwrite(im,savepath,'writemode','append');

    end

    % close file
    close(writerobj);

end

close(hf);

end