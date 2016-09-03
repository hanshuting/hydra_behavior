function [] = playVideo(frameIndx,movieParam,tw,pauseTime,saveresult)
% play video with the given frame indexes
% SYNOPSIS:
%     playVideo(frameIndx,movieParam,tw,pauseTime,saveresult)
% INPUT:
%     frameIndx: a vector with the index of time windows to be played
%     movieParam: a struct array returned by paramAll
%     tw: size of time window, in frames
%     pauseTime: number of seconds pause between each frame, default 0.01
%     saveresult: 0 (default) to not save the result, 1 to save as avi
% 
% Shuting Han, 2015

%% check input
if nargin==3
    pauseTime = 0.01;
    saveresult = 0;
elseif nargin==4
    saveresult = 0;
end

%% play video
% save result if indicated
if saveresult
    c = clock;
    writerobj = VideoWriter(['C:\Users\shuting\Desktop\temp\outputs\' ...
        num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) ...
        num2str(c(5)) num2str(round(c(6))) '.avi']);
    open(writerobj);
end

% set intensity range
im = double(imread([movieParam.filePath movieParam.fileName '.tif'],1));
maxInt = max(im(:));
minInt = min(im(:));

% plot
hf = figure;
for i = 1:length(frameIndx)
    
    for j = 1:tw
        
        % read image
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],...
            (frameIndx(i)-1)*tw+j));
        imagesc(im);
        colormap(gray);
        caxis([minInt maxInt]);
        axis equal tight off
        title(['frame ' num2str((frameIndx(i)-1)*tw+j)]);
        pause(pauseTime);
        
        % press 'e' to exit
        keypressed = get(hf,'currentkey');
        if keypressed=='e'
            if saveresult
                close(writerobj);
            end
            close(hf);
            return;
        end
        
        % write frame to file
        if saveresult
            F = getframe(hf);
            writeVideo(writerobj,F);
        end
         
    end

end

% finish writing file
if saveresult
    close(writerobj);
end

close(hf);

end