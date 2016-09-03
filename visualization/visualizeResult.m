function [] = visualizeResult(frameIndx,tw,movieParam,ifRandomize,saveresult,namestr)
% visualize a batch of video clips by index
% INPUT:
%     frameIndx: vector with index of video clips
%     tw: size of time window (length of video clips)
%     movieParam: a struct returned by paramAll
%     ifRandomize: 1 to randomize the display order, 0 to not
%     saveresult: 1 to save result into avi, 0 to not
% 
% Shuting Han, 2015

% figure display
hf = figure;
set(hf,'color','k','Position',[100 100 1500 1000]); % change here
%set(hf,'color','k','Position',[100 100 1200 400]); % change here

% save option
if saveresult
     c = clock;
    if isempty(namestr)
        namestr = [num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4))...
            num2str(c(5)) num2str(round(c(6)))];
    end
    writerobj = VideoWriter(['C:\Users\shuting\Desktop\temp\outputs\' namestr '.avi']);
    writerObj.FrameRate = 10;
    open(writerobj);
end

% randomize option
if ifRandomize
    frameIndx = frameIndx(randperm(length(frameIndx)));
end

% loop to play video
while true
    
    for i=1:tw
        for j=1:54 % change here to modify the number of samples to show
            hs = subplottight(6,9,j); % change here to modify the number of samples to show
            if j<=length(frameIndx)
                im = double(imread([movieParam.filePath movieParam.fileName '.tif'],...
                    (frameIndx(j)-1)*tw+i));
                imagesc(im);
                set(hs,'XTickLabel',[],'YTickLabel',[]);
                colormap(gray);caxis([0 255]);
            else
                set(hs,'color','black');
            end
        end
        
        pause(0.01);
        if saveresult
            F = getframe(hf);
            writeVideo(writerobj,F);
        end
    end

    pause(0.1);
    
    % press 'e' to stop video
    keypressed=get(hf,'currentkey');
    if keypressed=='e'
        close (hf);
        return;
    end

    if saveresult
        break;
    end

end

if saveresult
    close(writerobj);
end

close(hf);

end
