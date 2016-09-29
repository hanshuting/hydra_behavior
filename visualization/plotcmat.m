function [] = plotcmat(cmat,cmap)
% plot confusion matrix on current axis handle
% SYNOPSIS:
%     plotcmat(cmat)
% INPUT:
%     cmat: confusion matrix
% 
% Shuting Han, 2015

dims = size(cmat);

% plot confusion matrix
imagesc(cmat);
colormap(cmap);
colorbar;
xlabel('predicted');
ylabel('true');
caxis([0 1])

% show text
for i = 1:dims(1)
%     acrstr = sprintf('%3.0f%%\n',sum(double(label==i)==double(pred==i))/...
%         length(label)*100);
    acrstr = sprintf('%3.0f%%\n',cmat(i,i)/sum(cmat(i,:))*100);
    text(i,i,acrstr,'color','k','HorizontalAlignment','center','VerticalAlignment','middle');
%     if cmat(i,i) < max(cmat(:))*0.6 || isnan(cmat(i,i))
%         text(i,i,acrstr,'color','w','HorizontalAlignment','center','VerticalAlignment','middle');
%     else
%         text(i,i,acrstr,'color','k','HorizontalAlignment','center','VerticalAlignment','middle');
%     end
end

axis equal tight

end