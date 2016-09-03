function [] = visualizeFlowBatch(flows,flowCoords,movieParam,time_step,fr,ifsave)

% visualize the quiver plot of extracted optical flow and show different
% spatial patches in different colors

dims = size(flows);
cc = hsv(dims(2));
fscale = 10;

if ifsave
    c = clock;
    writerobj = VideoWriter(['C:\Users\shuting\Desktop\temp\outputs\' ...
        num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))...
        num2str(round(c(6))) '.avi']);
    open(writerobj);
end

hf = figure;
set(hf,'color','w');

for i = 1:dims(1)
    for j = 1:time_step
        tmpflow = [];
        tmpcoord = [];
        for k = 1:dims(2)
            tw_flow = flows{i,k}*fscale;
            tw_coords = flowCoords{i,k};
            %indx = 1:5:size(tw_coords,1);
            if ~isempty(tw_flow)
                tmpflow(end+1:end+size(tw_flow,1),:) = tw_flow;
                tmpcoord(end+1:end+size(tw_coords,1),:) = tw_coords;
                scatter(tw_coords(:,2),-tw_coords(:,1),3,cc(k,:),'*');
%                 quiver(tw_coords(:,2),-tw_coords(:,1),tw_flow(:,j*2),...
%                     -tw_flow(:,j*2-1),0.5,'color',cc(k,:),'autoscale','off');
                hold on;
            end
        end
        quiver(tmpcoord(:,2),-tmpcoord(:,1),tmpflow(:,j*2),-tmpflow(:,j*2-1),'color',[0.7,0.7,0.7]);
        xlim([0 movieParam.imageSize(1)]);
        ylim([-movieParam.imageSize(2) 0]);
        title(num2str((i-1)*time_step+j));
        hold off;
        pause(fr);
        
        keypressed=get(hf,'currentkey');
        if keypressed=='e'
            close(hf);
            return;
        end
        
        if ifsave
            F = getframe(hf);
            writeVideo(writerobj,F);
        end
    end
end

if ifsave
    close(writerobj);
end

close(hf);

end