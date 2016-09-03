function [] = playVideoMulti_galois(frameInd,movieParamMulti,step,fr,saveresult)
% play video with the given frame indexes from multiple source files
% SYNOPSIS:
%     playVideoMulti(frameInd,movieParamMulti,step,fr,saveresult)
% INPUT:
%     frameInd: vector with frame index to be visualized
%     movieParamMulti: a cell array of structs, see function fileinfo
%     step: size of time window
%     fr: frame rate
%     saveresult: 1 to save, 0 otherwise
% 
% Shuting Han, 2015

if saveresult
    c = clock;
    writerobj = VideoWriter(['/home/sh3276/work/results/output_videos/' ...
        num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))...
        num2str(round(c(6))) '.avi']);
    open(writerobj);
end

movieIndAll = [];
totPrevFrame = zeros(length(movieParamMulti),1);
for i = 1:length(movieParamMulti)
    movieIndAll(end+1:end+floor(movieParamMulti{i}.numImages/step)) = i;
    if i==1
        totPrevFrame(i) = floor(movieParamMulti{i}.numImages/step);
    else
        totPrevFrame(i) = totPrevFrame(i-1)+floor(movieParamMulti{i}.numImages/step);
    end
end
totPrevFrame(2:end) = totPrevFrame(1:end-1);
totPrevFrame(1) = 0;

hf = figure;
for i = 1:length(frameInd)
    
    movieIndx = movieIndAll(frameInd(i));
    movieParam = movieParamMulti{movieIndx};
    withinMovieFrameInd = frameInd(i)-totPrevFrame(movieIndx);
    
    % temporary modification to avoid errors
    if withinMovieFrameInd==floor(movieParam.numImages/step)
        continue;
    end
        
    for j = 1:step
        
        % read image
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],...
            withinMovieFrameInd*step+j));
        imagesc(im);
        colormap(gray);
        title(['frame ' num2str(withinMovieFrameInd*step+j)]);
        pause(fr);
        
        % write frame to file
        if saveresult
            F = getframe(hf);
            writeVideo(writerobj,F);
        end
        
        keypressed=get(hf,'currentkey');
        if keypressed=='e'
            if saveresult
                close(writerobj);
            end
            close(hf);
            return;
        end
        
    end

end

% finish writing file
if saveresult
    close(writerobj);
end

close(hf);

end