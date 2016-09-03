function [] = plotMatSeq(mat,ind)
% this function plots the given matrix and rearrange it by the given identity vector
% INPUT:
%     mat: N*M matrix
%     ind: N*1 matrix, corresponding histogram identities in histMat


[sortedInd,seq] = sort(ind);
seqMat = mat(seq,:);
seqMat = seqMat(seq,:);


figure;
ax1 = axes('position',[0 0 1 1],'visible','off');
ax2 = axes('position',[0.1 0.1 0.8 0.8]);
imagesc(seqMat);
%colorbar;
set(ax2,'xticklabel','');
set(ax2,'yticklabel','');
axes(ax1);

numCluster = max(ind);
for i = 1:numCluster
   loc = find(sortedInd==i);
   ht1 = text(0.05,0.9-0.8*loc(1)/size(ind,1),num2str(i));
   ht2 = text(0.1+0.8*loc(1)/size(ind,1),0.95,num2str(i));
   set(ht1,'FontSize',12);
   set(ht2,'FontSize',12);
end

axes(ax2);

end