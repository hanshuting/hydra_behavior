function [] = plotComponent(mat,annotation)

labels = unique(annotation);
numClass = size(labels,1);
dims = size(mat,2);

baseline = 0.3;
colordim = floor(length(labels)^1/3);
cc = zeros((colordim+1)^3,3);
cc(:,1) = reshape(repmat(baseline:(1-2*baseline)/colordim:1-baseline,(colordim+1)^2,1),1,[]);
cc(:,2) = repmat(reshape(repmat(baseline:(1-2*baseline)/colordim:1-baseline,colordim+1,1),1,[]),1,colordim+1);
cc(:,3) = repmat(baseline:(1-2*baseline)/colordim:1-baseline,1,(colordim+1)^2);

ccused = cc(randperm(size(cc,1),length(labels)),:);

figure;
if dims>2
    scatter3(mat(annotation==labels(1),1),mat(annotation==labels(1),2),...
        mat(annotation==labels(1),3),30,ccused(1,:));
    hold on;
    for i = 2:numClass
        scatter3(mat(annotation==labels(i),1),mat(annotation==labels(i),2),...
            mat(annotation==labels(i),3),30,ccused(i,:));
    end
    hold off;
else
    scatter(mat(annotation==labels(1),1),mat(annotation==labels(1),2));
    hold on;
    scatter(mat(annotation==labels(2),1),mat(annotation==labels(2),2));
end

end