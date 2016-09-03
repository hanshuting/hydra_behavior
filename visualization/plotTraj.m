function [] = plotTraj(label,mat,movieParam,tw,fr,saveresult)
% Plot trajectory and play the movie
% INPUT:
%     label: N-by-1 vector, indicating the group/class of the sample
%     mat: matrix in the state space. Only plot the first three dimensions.
%     tw: size of time window
%     fr: frame rate
%     saveresult: 1 to save into avi, 0 otherwise
% 
% Shuting Han, 2015

if saveresult
    c = clock;
    writerobj = VideoWriter(['C:\Users\shuting\Desktop\temp\' ...
        num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))...
        num2str(round(c(6))) '.avi'],'Motion JPEG AVI');
    open(writerobj);
end

labels = unique(label);
baseline = 0.3;
colordim = floor(length(labels)^1/3);
cc = zeros((colordim+1)^3,3);
cc(:,1) = reshape(repmat(baseline:(1-2*baseline)/colordim:1-baseline,(colordim+1)^2,1),1,[]);
cc(:,2) = repmat(reshape(repmat(baseline:(1-2*baseline)/colordim:1-baseline,colordim+1,1),1,[]),1,colordim+1);
cc(:,3) = repmat(baseline:(1-2*baseline)/colordim:1-baseline,1,(colordim+1)^2);

ccused = cc(randperm(size(cc,1),length(labels)),:);

hf = figure;
set(hf,'Position',[500 500 1200 600]);
for i = 1:length(label)
    
    subplot(1,2,2);
    hold on;
    scatter3(mat(i,1),mat(i,2),mat(i,3),30,ccused(labels==label(i),:),'*');
    if i>1
        plot3(mat(i-1:i,1),mat(i-1:i,2),mat(i-1:i,3),'linestyle','-','color','k');
    end
    view([max(mat(:,1)),max(mat(:,2)),0.3*max(mat(:,3))]);
    grid on;
    xlim([min(mat(:,1)) max(mat(:,1))]);
    ylim([min(mat(:,2)) max(mat(:,2))]);
    zlim([min(mat(:,3)) max(mat(:,3))]);
    
    subplot(1,2,1);
    for j = 1:tw
        
            % read image
            imageRaw = double(imread([movieParam.filePath movieParam.fileName...
                '.tif'],(i-1)*tw+j));
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