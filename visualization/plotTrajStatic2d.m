function [] = plotTrajStatic2d(label,data)
% Plot trajectory of the given data in 2d space
% SYNOPSIS:
%     plotTrajStatic2d(label,data)
% INPUT
%     label: vector with class labels
%     data: data matrix to be plotted (only plot the first two dimensions)
% 
% Shuting Han, 2015

labelset = unique(label);
labelnew = changem(label,1:length(labelset),labelset);

% generate random color
baseline = 0.3;
colordim = floor(length(labelset)^1/3);
cc = zeros((colordim+1)^3,3);
cc(:,1) = reshape(repmat(baseline:(1-2*baseline)/colordim:1-baseline,(colordim+1)^2,1),1,[]);
cc(:,2) = repmat(reshape(repmat(baseline:(1-2*baseline)/colordim:1-baseline,colordim+1,1),1,[]),1,colordim+1);
cc(:,3) = repmat(baseline:(1-2*baseline)/colordim:1-baseline,1,(colordim+1)^2);
cc = cc(randperm(size(cc,1),length(labelset)),:);

% plot
hf = figure;
set(hf,'Position',[500 500 600 600]);
plot(data(:,1),data(:,2),'linestyle',':','color','k');
hold on;
scatter(data(:,1),data(:,2),10,cc(labelnew,:),'*');
grid on;
xlim([min(data(:,1)) max(data(:,1))]);
ylim([min(data(:,2)) max(data(:,2))]);


 end