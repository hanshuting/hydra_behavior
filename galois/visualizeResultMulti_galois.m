function [] = visualizeResultMulti_galois(frameInd,tw,movieParamMulti,ifRandomize,saveresult)
% visualize multiple video clips from multiple video sources at once
% SYNOPSIS:
%     visualizeResultMulti_galois(frameIndx,timeStep,movieParamMulti,ifRandomize,saveresult)
% INPUT:
%     frameIndx: index of temporal windows to visualize
%     timeStep: size of temporal windows
%     movieParamMulti: a cell array of struct, see paramMulti
%     ifRandomize: 1 to randomize the output order
%     saveresult: 1 to save the output video
% 
% Shuting Han, 2015

flag = 1;
colorscale = 0.5;

hf = figure;
set(hf,'color','k','Position',[100 100 1500 1000]); % change here
%set(hf,'color','k','Position',[100 100 1200 400]); % change here

if saveresult
    c = clock;
    writerobj = VideoWriter(['/home/sh3276/work/results/output_videos/' ...
        num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))...
        num2str(round(c(6))) '.avi']);
    writerObj.FrameRate = 10;
    open(writerobj);
end

movieIndAll = [];
totPrevFrame = zeros(length(movieParamMulti),1);
for i = 1:length(movieParamMulti)
    movieIndAll(end+1:end+floor(movieParamMulti{i}.numImages/tw)) = i;
    if i==1
        totPrevFrame(i) = floor(movieParamMulti{i}.numImages/tw);
    else
        totPrevFrame(i) = totPrevFrame(i-1)+floor(movieParamMulti{i}.numImages/tw);
    end
end
totPrevFrame(2:end) = totPrevFrame(1:end-1);
totPrevFrame(1) = 0;

if ifRandomize
    frameInd = frameInd(randperm(length(frameInd)));
end

color_range = [];
while flag==1
    for k = 1:tw
        for j=1:6*7 % change here to modify the number of samples to show
            hs = subplottight(6,7,j); % change here to modify the number of samples to show
            if j<=length(frameInd)
                
                movieIndx = movieIndAll(frameInd(j));
                movieParam = movieParamMulti{movieIndx};
                withinMovieFrameInd = frameInd(j)-totPrevFrame(movieIndx);
    
                % temporary modification to avoid errors
                if withinMovieFrameInd==floor(movieParam.numImages/tw)
                    continue;
                end
                
                im = double(imread([movieParam.filePath movieParam.fileName '.tif'],...
                    (withinMovieFrameInd-1)*tw+k));
                
                % get color axis range
                if isempty(color_range)
                    color_range(1) = min(im(:));
                    color_range(2) = max(im(:));
                end
                
                % plot
                imagesc(im);
                set(hs,'XTickLabel',[],'YTickLabel',[]);
                colormap(gray);caxis([color_range(1) colorscale*color_range(2)]);
                
                keypressed=get(hf,'currentkey');
                if keypressed=='e'
                    close(hf);
                    return;
                end

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

    pause(0.05);

    if saveresult
        for ii = 1:3
            F = getframe(hf);
            writeVideo(writerobj,F);
        end
        break;
    end

end

if saveresult
    close(writerobj);
end

close(hf);


end