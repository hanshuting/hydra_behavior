function [] = plot_ss_files(dpath,fileIndx,annotype,sstw,ctrltw,fgauss,...
    btype,hf,vpath,spath,timeStep,numClass,linew,cc,ifsave,ifvis)

load([dpath fileinfo(fileIndx) '_annotype' num2str(annotype) '_pred_results.mat']);
softpred = makeSoftPred(pred_score);

figure; set(gcf,'color','w','position',[1978 789 571 161])
plotEthogram(softpred(sstw,:),annotype);
% plotEthogram(pred(sstw,:),annotype);
title(fileinfo(fileIndx),'interpreter','none');
if ifsave
    saveas(gcf,[spath fileinfo(fileIndx) '_ss_pred_ethogram.fig']);
    print(gcf,'-dpdf','-painters','-bestfit',[spath fileinfo(fileIndx)...
        '_ss_pred_ethogram.pdf']);
end

% trajectory
eth_fr = zeros(numClass,length(sstw));
ctrl_fr = zeros(numClass,length(ctrltw));
for ii = 1:numClass
    eth_fr(ii,:) = conv(double(softpred(sstw,1)==ii),fgauss,'same');
    ctrl_fr(ii,:) = conv(double(softpred(ctrltw,1)==ii),fgauss,'same');
%    eth_fr(ii,:) = movmean(double(softpred(sstw{n},1)==ii),sig);
%     ctrl_fr(ii,:) = movmean(double(softpred(ctrltw{n},1)==ii),sig);
end
figure(hf);
plot3(eth_fr(btype(1),:),eth_fr(btype(2),:),eth_fr(btype(3),:),'linewidth',linew)
plot3(ctrl_fr(btype(1),:),ctrl_fr(btype(2),:),ctrl_fr(btype(3),:),...
    'linewidth',linew,'color',cc.gray)

if ifvis
%    vpath = 'E:\Projects\Summer2016\Sol_ColMedium\';
    movieParam = paramAll(vpath,fileIndx);
    makeAnnotatedMovie(sstw,softpred,annotype,movieParam,timeStep,0.1,1);
end
    
end