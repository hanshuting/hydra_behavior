function [auc] = plotROCmultic(labels,scores,numClass)
% plot ROC class for multiclass classifiers on current axis handle; return
% AUC vector

% cc = jet(numClass+1);
cc = jet(numClass);

auc = zeros(numClass,1);
h = cell(numClass,1);
hstr = '';
lstr = '';
hold on
% patch([0 1 1 0 0],[0 0 1 1 0],0.9*[1 1 1],'edgecolor','none')
plot([0 1],[0 1],'--','color','k','linewidth',1);
for n = 1:numClass
    [xx,yy,~,auc(n)] = perfcurve(labels,scores(:,n),n);
    h{n} = plot(xx,yy,'color',cc(n,:),'linewidth',1);
    hstr = [hstr sprintf('h{%u}',n) ' '];
    lstr = [lstr '''' num2str(n) ''','];
%     text(10,10,sprintf('AUC=%1.2f',auc(n)));
end
set(gca,'linewidth',1)
xlabel('FPR');ylabel('TPR')

eval(sprintf('legend([%s],%s)\n',hstr(1:end-1),lstr(1:end-1)));

end