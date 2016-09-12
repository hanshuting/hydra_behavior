function [] = plotcmat(cmat,label,pred)
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
colormap(hot);
colorbar;
xlabel('predicted');
ylabel('true');

% show text
for i = 1:dims(1)
%     acrstr = sprintf('%3.2f%%\n',100*cmat(i,i)/sum(cmat(i,:)));
    acrstr = sprintf('%3.0f%%\n',sum(double(label==i)==double(pred==i))/...
        length(label)*100);
    if cmat(i,i) < max(cmat(:))*0.6
        text(i,i,acrstr,'color','w','HorizontalAlignment','center','VerticalAlignment','middle');
    else
        text(i,i,acrstr,'color','k','HorizontalAlignment','center','VerticalAlignment','middle');
    end
end

axis equal tight

end