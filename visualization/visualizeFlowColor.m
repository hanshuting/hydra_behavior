function [] = visualizeFlowColor(uu,vv)
% visualize flows by converting to color

numFlows = size(uu,3);

hf = figure;
for i = 1:numFlows
    
    flow = single(uu(:,:,i));
    flow(:,:,2) = single(vv(:,:,i));
    flowcolor = flowToColor(flow);
    
    imagesc(flowcolor);
    title(num2str(i));
    pause(0.01);
    
end

close(hf);

end