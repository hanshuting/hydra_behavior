function [] = plotEthogram(label,annotype)
% [] = plotEthogram(label,annotype)
% label: T-by-3 matrix

ss = 0.2;
[~,numClass] = annoInfo(annotype,1);
cc = jet(numClass);
cc = max(cc-0.3,0);
labelset = cell(numClass,1);
hold on;
for n = 1:numClass

    labelset{n} = annoInfo(annotype,n);
    pdt = find(sum(label==n,2)~=0);
    ypos = 0.5*(n+1);
    for ii = 1:length(pdt)
        patch([pdt(ii)-0.5 pdt(ii)+0.5 pdt(ii)+0.5 pdt(ii)-0.5 pdt(ii)-0.5],...
            [ypos-ss ypos-ss ypos+ss ypos+ss ypos-ss],cc(n,:),'edgecolor','none');
    end
    
end
xlim([1 length(label)]);ylim([1-ss 0.5*(numClass+1)+ss])
set(gca,'tickdir','out','ticklen',[0 0],'ytick',1:0.5:0.5*(numClass+1),'yticklabel',labelset)
box on

end