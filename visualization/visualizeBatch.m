function [] = visualizeBatch(frameInd,trackLocBatch,trackVelBatch,tw,movieParam,saveresult)

dimsBatch = size(trackLocBatch);     
colordim = floor(dimsBatch(2)^(1/3));
cc = zeros((colordim+1)^3,3);
cc(:,1) = reshape(repmat(0:1/colordim:1,(colordim+1)^2,1),1,[]);
cc(:,2) = repmat(reshape(repmat(0:1/colordim:1,colordim+1,1),1,[]),1,colordim+1);
cc(:,3) = repmat(0:1/colordim:1,1,(colordim+1)^2);

ccused = cc(randperm(size(cc,1),dimsBatch(2)),:);

if saveresult
    c = clock;
    writerobj = VideoWriter([movieParam.filePath ...
        num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))...
        num2str(round(c(6))) '.avi']);
    open(writerobj);
end

hf = figure;
for i = 1:length(frameInd) % go through cubes
    for j = 1:tw % go through each frame in the cube
        %imageRaw = double(imread([movieParam.filenameImages ...
        %    movieParam.filenameBasis movieParam.enumString((frameInd(i)-1)*tw+j,:) '.tif']));
        %imageRot = imrotate(imageRaw,hydraParam.theta,'crop');
        %imagesc(imageRot);
        %colormap(gray);
        %hold on;
        for k = 1:dimsBatch(2) % go through spatial patches
            locmat = trackLocBatch{frameInd(i),k};
            velmat = trackVelBatch{frameInd(i),k};
            if isempty(locmat)
                continue;
            end
            hl = gscatter(locmat(:,2*j-1),locmat(:,2*j));
            hold on;
            %for nn = 1:size(velmat,1) % plot velocity by cells
            %    hv = plot([locmat(nn,2*j-1) locmat(nn,2*j-1)-velmat(nn,2*j-1)],...
            %        [locmat(nn,2*j) locmat(nn,2*j)-velmat(nn,2*j)]);
            %    hold on;
            %    %set(hv,'color',ccused(k,:));
            %end
            set(hl,'color',ccused(k,:));
            %xlim([-5 5]);
            %ylim([-5 5]);
            xlim([-100 100]);
            ylim([-120 100]);
        end
        hold off
        pause(0.01);
        if saveresult
            F = getframe(hf);
            writeVideo(writerobj,F);
        end
    end 
end

if saveresult
    close(writerobj);
end

end

