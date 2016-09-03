% plot script
% im = imresize(densNew(:,:,5),[max(xx)-min(xx),max(xx)-min(xx)]);
vdata = cell2mat(emDataNew(1));
segIndx = seg_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,round(vdata(:,2))-xx(1)+1));
regIndx = region_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,round(vdata(:,2))-xx(1)+1));
cdark1 = histc(regIndx,0.5:1:axislim+0.5);
cdark1 = cdark1/sum(cdark1);

% im = imresize(densNew(:,:,6),[max(xx)-min(xx),max(xx)-min(xx)]);
vdata = cell2mat(emDataNew(2));
segIndx = seg_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,round(vdata(:,2))-xx(1)+1));
regIndx = region_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,round(vdata(:,2))-xx(1)+1));
clight1 = histc(regIndx,0.5:1:axislim+0.5);
clight1 = clight1/sum(clight1);

figure;set(gcf,'color','w');
bar([cdark1,clight1])
legend('dark starved','light starved')
xlabel('predicted behavior')
ylabel('percentage');
xlabel('embedding behavior class')
xlim([0 6.5]);colormap(hot);
box off

% im = imresize(densNew(:,:,11),[max(xx)-min(xx),max(xx)-min(xx)]);
vdata = cell2mat(emDataNew(7));
segIndx = seg_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,round(vdata(:,2))-xx(1)+1));
regIndx = region_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,round(vdata(:,2))-xx(1)+1));
cdark2 = histc(regIndx,0.5:1:axislim+0.5);
cdark2 = cdark2/sum(cdark2);

% im = imresize(densNew(:,:,12),[max(xx)-min(xx),max(xx)-min(xx)]);
vdata = cell2mat(emDataNew(8));
segIndx = seg_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,round(vdata(:,2))-xx(1)+1));
regIndx = region_im_trans(sub2ind(size(im),round(vdata(:,1))-xx(1)+1,round(vdata(:,2))-xx(1)+1));
clight2 = histc(regIndx,0.5:1:axislim+0.5);
clight2 = clight2/sum(clight2);

figure;set(gcf,'color','w');
bar([cdark2,clight2])
legend('dark fed','light fed')
xlabel('predicted behavior')
ylabel('percentage');
xlabel('embedding behavior class')
xlim([0 6.5]);colormap(hot);
box off

figure;set(gcf,'color','w');
bar([cdark1,clight1,cdark2,clight2])
legend('dark starved','light starved','dark fed','light fed')
xlabel('predicted behavior')
ylabel('percentage');
xlabel('embedding behavior class')
xlim([0 6.5]);colormap(hot);
box off
