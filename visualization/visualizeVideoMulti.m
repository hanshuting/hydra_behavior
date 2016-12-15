function [] = visualizeVideoMulti(indx,tw,movieParamMulti,ifrandomize,ifsave,namestr)
% visualize multiple video clips from multiple video sources at once
% SYNOPSIS:
%     visualizeVideoMulti(indx,tw,movieParamMulti,ifrandomize,ifsave,namestr)
% INPUT:
%     indx: index of start frames to visualize
%     tw: size of temporal windows
%     movieParamMulti: a cell array of struct, see paramMulti
%     ifrandomize: 1 to randomize the output order
%     ifsave: 1 to save the output video
%     namestr: optional naming rules
% 
% Shuting Han, 2016

% initialize
flag = 1;
colorscale = 1;
num_sample = length(indx);

% create figure object
hf = figure;
set(hf,'color','k','Position',[100 100 1500 1000]); % change here

% saving details
if ifsave
    
    % if no saving name is provided, use current time
    c = clock;
    if isempty(namestr)
        namestr = [num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4))...
            num2str(c(5)) num2str(round(c(6)))];
    end
    
    % create video object
    writerobj = VideoWriter(['C:\Users\shuting\Desktop\temp\outputs\' namestr '.avi']);
    writerObj.FrameRate = 10;
    open(writerobj);
    
end

% deal with video from multiple files
videoindx = [];
totPrevFrame = zeros(length(movieParamMulti),1);
for i = 1:length(movieParamMulti)
    videoindx(end+1:end+movieParamMulti{i}.numImages) = i;
    if i==1
        totPrevFrame(i) = movieParamMulti{i}.numImages;
    else
        totPrevFrame(i) = totPrevFrame(i-1)+movieParamMulti{i}.numImages;
    end
end
totPrevFrame(2:end) = totPrevFrame(1:end-1);
totPrevFrame(1) = 0;

% randomize sample order
if ifrandomize
    indx = indx(randperm(length(indx)));
end

% determine subplot number
color_range = [];
if num_sample <= 6*7
    N = ceil(sqrt(num_sample));
    M = ceil(num_sample/N);
else
    N = 7; M = 6;
end

% show video
while flag==1
    for k = 1:tw
        for j=1:min(num_sample,M*N)
            hs = subplottight(M,N,j);
            if j<=num_sample
                
                % determine source video file
                movieIndx = videoindx(indx(j)-1+k);
                movieParam = movieParamMulti{movieIndx};
                withinMovieFrameInd = indx(j)-totPrevFrame(movieIndx);
                
                % temporary modification to avoid errors
                if withinMovieFrameInd==floor(movieParam.numImages)
                    continue;
                end
                
                im = double(imread([movieParam.filePath movieParam.fileName '.tif'],...
                    (withinMovieFrameInd-1)+k));
                
                % get color axis range
                if isempty(color_range)
                    color_range(1) = min(im(:));
                    color_range(2) = max(im(:));
                end
                
                % plot
                imagesc(im); axis equal tight off
                set(hs,'XTickLabel',[],'YTickLabel',[]);
                colormap(gray);caxis([color_range(1) colorscale*color_range(2)]);
                
                % press 'e' to stop the video
                keypressed = get(hf,'currentkey');
                if keypressed=='e'
                    close(hf);
                    return;
                end

            else
                set(hs,'color','black');
            end
        end
        
        pause(0.01);
        
        % write frame
        if ifsave
            F = getframe(hf);
            writeVideo(writerobj,F);
        end
        
    end
    
    % pause longer between repeats
    pause(0.05);
    
    % save frame
    if ifsave
        for ii = 1:3
            F = getframe(hf);
            writeVideo(writerobj,F);
        end
        break;
    end

end

if ifsave
    close(writerobj);
end

close(hf);


end