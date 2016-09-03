function [] = makeAnnotatedMovie(frameIndx,anno,annoType,movieParam,tw,...
    pauseTime,saveresult)
% play video of given time windows with overlay annotation text
% SYNOPSIS:
%     makeAnnotatedMovie(frameIndx,anno,annoType,movieParam,tw,pauseTime,saveresult)
% INPUT:
%     frameIndx: a vector with the index of time windows to be played
%     anno: annotation, same length of frameIndx
%     annoType: annotation scheme, see function mergeAnno
%     movieParam: a struct array returned by paramAll
%     tw: size of time window, in frames
%     pauseTime: number of seconds pause between each frame, default 0.01
%     saveresult: 0 (default) to not save the result, 1 to save as avi
% 
% Shuting Han, 2015

%% check input
if nargin==5
    pauseTime = 0.01;
    saveresult = 0;
elseif nargin==6
    saveresult = 0;
end

%% play video
% save result if indicated
if saveresult
    c = clock;
    writerobj = VideoWriter(['C:\Users\shuting\Desktop\temp\outputs\' ...
        movieParam.fileName '_' num2str(c(1)) num2str(c(2)) num2str(c(3))...
        num2str(c(4)) num2str(c(5)) num2str(round(c(6))) '.avi']);
    open(writerobj);
end

% set intensity range
im = double(imread([movieParam.filePath movieParam.fileName '.tif'],1));
maxInt = 0.8*max(im(:));

% plot
hf = figure;set(hf,'color','w');
for i = 1:length(frameIndx)
    
    % load annotation string
    annostr = {};
    numanno = 0;
    for aa = 1:size(anno,2)
        if ~isnan(anno(i,aa))
            numanno = numanno+1;
            annostr{end+1} = annoInfo(annoType,anno(i,aa));
        end
    end
    
    for j = 1:tw
        
        % read image
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],...
            (frameIndx(i)-1)*tw+j));
        imagesc(im);
        set(gca,'xtick',[],'ytick',[])
        colormap(gray);
        caxis([0 maxInt]);
        axis equal tight xy off
        title(['frame ' num2str((frameIndx(i)-1)*tw+j)]);
        
        % show annotation text
        for aa = 1:numanno
            text(10,15*aa,annostr{aa},'color','w','fontsize',15);
        end
        pause(pauseTime);
        
        % press 'e' to exit
        keypressed=get(hf,'currentkey');
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