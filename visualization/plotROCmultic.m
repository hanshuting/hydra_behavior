function [auc] = plotROCmultic(labels,scores,numClass)
% plot ROC class for multiclass classifiers on current axis handle; return
% AUC vector

cc = jet(numClass+1);

auc = zeros(numClass,1);
h = cell(numClass,1);
hstr = '';
lstr = '';
hold on
plot([0 1],[0 1],'--','color','k');
for n = 1:numClass
    [xx,yy,~,auc(n)] = perfcurve(labels,scores(:,n),n);
    h{n} = plot(xx,yy,'color',cc(n,:));
    hstr = [hstr sprintf('h{%u}',n) ' '];
    lstr = [lstr '''' num2str(n) ''','];
end

eval(sprintf('legend([%s],%s)\n',hstr(1:end-1),lstr(1:end-1)));

end