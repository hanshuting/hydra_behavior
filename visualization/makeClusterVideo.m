function [] = makeClusterVideo(twInd,movieParam,tw,saveresult)

if saveresult
    c = clock;
    writerobj = VideoWriter([movieParam.filenameImages ...
        num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))...
        num2str(round(c(6))) '.avi']);
    open(writerobj);
end

hf = figure;
for i = 1:size(twInd,1)
    
    for j = 1:tw
        
        % read image
        imageRaw = double(imread([movieParam.filenameImages movieParam.filenameBasis ...
            movieParam.enumString((i-1)*tw+j,:) '.tif']));
        imagesc(imageRaw);
        colormap(gray);
        h=text(20,20,num2str(twInd(i)));
        set(h,'Color',[1 1 1]);
        set(h,'FontSize',15);
        pause(0.01);
    
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

end