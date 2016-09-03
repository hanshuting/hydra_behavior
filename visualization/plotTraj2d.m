function [] = plotTraj2d(indAll,mat,movieParam,tw,fr,saveresult)

if saveresult
    c = clock;
    writerobj = VideoWriter(['C:\Users\shuting\Desktop\temp\' ...
        num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))...
        num2str(round(c(6))) '.avi'],'Motion JPEG AVI');
    open(writerobj);
end

labels = unique(indAll);
baseline = 0.3;
colordim = floor(length(labels)^1/3);
cc = zeros((colordim+1)^3,3);
cc(:,1) = reshape(repmat(baseline:(1-2*baseline)/colordim:1-baseline,(colordim+1)^2,1),1,[]);
cc(:,2) = repmat(reshape(repmat(baseline:(1-2*baseline)/colordim:1-baseline,colordim+1,1),1,[]),1,colordim+1);
cc(:,3) = repmat(baseline:(1-2*baseline)/colordim:1-baseline,1,(colordim+1)^2);

ccused = cc(randperm(size(cc,1),length(labels)),:);

hf = figure;
set(hf,'Position',[500 500 1200 600]);
for i = 1:length(indAll)
    
    subplot(1,2,2);
    hold on;
    scatter(mat(i,1),mat(i,2),30,ccused(labels==indAll(i),:),'*');
    if i>1
        plot(mat(i-1:i,1),mat(i-1:i,2),'linestyle',':','color','k');
    end
    grid on;
    xlim([min(mat(:,1)) max(mat(:,1))]);
    ylim([min(mat(:,2)) max(mat(:,2))]);
    
    subplot(1,2,1);
    for j = 1:tw
        
            % read image
            imageRaw = double(imread([movieParam.filenameImages movieParam.filenameBasis ...
                movieParam.enumString((i-1)*tw+j,:) '.tif']));
            imagesc(imageRaw);
            colormap(gray);
            title(['frame ' num2str((i-1)*tw+j)]);
            pause(fr);
        
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