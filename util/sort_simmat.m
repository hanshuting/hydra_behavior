function [simmat_sorted] = sort_simmat(simmat,indx)
% sort similarity matrix by the given grouping index
% SYNOPSIS:
%     [simmat_sorted] = sort_simmat(simmat,indx)
% 

dims = size(simmat,1);

% sort by index
[indx_sorted,sort_seq] = sort(indx);
simmat_sorted = simmat(sort_seq,sort_seq);
borders = diff(indx_sorted);
borders = find(borders);

borders = [0;borders;dims];

% plot
figure;
set(gcf,'color','w');
imagesc(simmat_sorted);
colormap(jet)
hold on;
for i=2:length(borders)-1
    plot([borders(i) borders(i)],[borders(i-1) borders(i+1)],'k:','linewidth',2);
    plot([borders(i-1) borders(i+1)],[borders(i) borders(i)],'k:','linewidth',2);
end
colorbar;

end