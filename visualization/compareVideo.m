function [] = compareVideo(ind1,ind2,movieParam1,movieParam2,tw,saveresult)

if saveresult
    c = clock;
    writerobj = VideoWriter([movieParam.filenameImages ...
        num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))...
        num2str(round(c(6))) '.avi']);
    open(writerobj);
end


hf = figure;
set(hf,'Position',[200 200 1200 500]);
for i = 1:tw
  
    % read image
    imageRaw1 = double(imread([movieParam1.filenameImages movieParam1.filenameBasis ...
        movieParam1.enumString(ind1+i,:) '.tif']));
    subplot(1,2,1);
    imagesc(imageRaw1);
    colormap(gray);
    imageRaw2 = double(imread([movieParam2.filenameImages movieParam2.filenameBasis ...
        movieParam2.enumString(ind2+i,:) '.tif']));
    subplot(1,2,2);
    imagesc(imageRaw2);
    pause(0.1);
    
    % write frame to file
    if saveresult
        F = getframe(hf);
        writeVideo(writerobj,F);
    end
    
end

% finish writing file
if saveresult
    close(writerobj);
end

close(hf);


end