function [] = playMovie(data,ifsave)

scale = 1;
dims = size(data);
mi = min(data(:));
ma = scale*max(data(:));
hf = figure;
set(hf,'color','w');

if ifsave
    c = clock;
    writerobj = VideoWriter(['C:\Users\shuting\Desktop\temp\outputs\' ...
        num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))...
        num2str(round(c(6))) '.avi']);
    open(writerobj);
end

while true
    for i = 1:dims(3)
        imagesc(data(:,:,i),[mi ma]);
        title(['t=' num2str(i)]);
%         colormap(gray);
        colormap(hot);
        axis equal off tight
        %xlabel('press "e" to exit');
        keypressed = get(hf,'currentkey');
        pause(0.01);
        
        if ifsave
            F = getframe(hf);
            writeVideo(writerobj,F);
        end
        
        if keypressed=='e'
            close(hf);
            return;
        end
            
        if i == dims(3)
            if ifsave
                close(writerobj);
                close(hf);
                return;
            else
                i = 1;
            end
        end
    end
end

end
