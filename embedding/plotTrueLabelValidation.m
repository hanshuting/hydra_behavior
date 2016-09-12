function [] = plotTrueLabelValidation(regIndx,anno,numRegions,numAnnoClass,num_row,start_row)
% plot histogram of true label distribution in each merged cluster, with
% the given number of rows and starting row index

cc = jet(64);
for ii = 1:numRegions
    subplot(num_row,numRegions,(start_row-1)*numRegions+ii)
    histogram(anno(regIndx==ii),0.5:1:numAnnoClass+0.5,...
        'facecolor',cc(round(ii/numRegions*64),:),'facealpha',1,...
        'Normalization','probability');
    title(['Class #' num2str(ii)],'fontsize',12,'fontweight','bold');
    set(gca,'xtick',1:numAnnoClass);box off
    xlim([0 numAnnoClass+1]);ylim([0 1]);
end

end