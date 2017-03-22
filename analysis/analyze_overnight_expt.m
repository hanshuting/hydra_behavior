
%% parameters

% full dataset
% findx = {(621:628)',(629:636)',(645:652)',(673:679)',(687:694)',(703:710)';...
%     (613:620)',(637:644)',(653:657)',(680:686)',(695:702)',(711:717)'};

% exclude the beginning
findx = {(623:627)',(631:635)',(647:651)',(675:678)',(689:693)',(705:709)';...
    (615:619)',(639:643)',(655:656)',(682:685)',(697:701)',(713:717)'};

fstr = {'dark','light'};
dpathbase = 'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\';
dpath = {[dpathbase '20161026\'],[dpathbase '20161105\'],[dpathbase '20161110\'],...
    [dpathbase '20161203\hydra1\'],[dpathbase '20161203\hydra2\'],[dpathbase '20161211\'];...
    [dpathbase '20161024\'],[dpathbase '20161105\'],[dpathbase '20161110\'],...
    [dpathbase '20161203\hydra1\'],[dpathbase '20161203\hydra2\'],[dpathbase '20161211\']};
figpath = 'C:\Shuting\Projects\hydra behavior\results\long_recording\fig\';

p = 0.05;
annotype = 5;
fr = 5;
timeStep = 25;
num_file = size(dpath,2);
[~,numClass] = annoInfo(annotype,1);

% parameters for calculating rate
winsz = 10; % 10 min
sig = winsz*60*fr/timeStep;
mu = 2*ceil(2*sig)+1;
fgauss = fspecial('gaussian',[mu,1],sig);

% nonactive & active indices
act_indx = {[1,3],[2,4:6]}; 

bhv_str = cell(1,numClass);
for ii = 1:numClass
    bhv_str{ii} = annoInfo(annotype,ii);
end

%% process results
all_data = cell(size(findx));
data_fr = cell(size(findx));
data_hist = zeros(2,num_file,numClass);
eth_act_fr = cell(size(findx)); % first column: non-active; second: active
nonact_prd = cell(size(findx));
nonact_T = zeros(size(findx));
nonact_bin_num = zeros(size(findx));
nonact_bin_len = cell(size(findx));

for m = 1:2
    for n = 1:num_file

        % combine data
        combined_data = [];
        for ii = 1:length(findx{m,n})
            movieParam = paramAll(dpath{m,n},findx{m,n}(ii));
            load([dpath{m,n} movieParam.fileName '_annotype' num2str(annotype)...
                '_pred_results.mat']);
            combined_data(end+1:end+length(pred)) = pred;
        end
        numT = length(combined_data);
        all_data{m,n} = combined_data;

        % histogram
        data_hist(m,n,:) = histc(combined_data,1:numClass)/length(combined_data);

        % rate
        eth_fr = zeros(numClass,numT);
        for ii = 1:numClass
            eth_fr(ii,:) = conv(double(all_data{m,n}==ii),fgauss,'same');
        end
        data_fr{m,n} = eth_fr;

        % active and nonactive rate
        th = 0.5;
        act_fr = zeros(numT,2);
        for ii = 1:length(act_indx)
            ind = false(size(combined_data));
            for jj = 1:length(act_indx{ii})
                ind = ind|combined_data==act_indx{ii}(jj);
            end
            act_fr(:,ii) = conv(double(ind),fgauss,'same')';
        end
        nonact_prd{m,n} = act_fr(:,1)>th;
        eth_act_fr{m,n} = act_fr;

        iv = bn_to_iv(nonact_prd{m,n});
        nonact_T(m,n) = sum(nonact_prd{m,n})/numT;
        nonact_bin_num(m,n) = size(iv,1)/(numT*timeStep/fr/60/60);
        nonact_bin_len{m,n} = iv(:,2)-iv(:,1);
            
    end
end

%% plot ethograms
% figure; set(gcf,'color','w')
% for m = 1:2
%     for n = 1:num_file
%         subplot(num_file,2,(n-1)*2+m);
%         plotEthogram(all_data{m,n}',annotype);
%     end
%     subplot(num_file,2,m);
%     title(fstr{m});
% end

%% plot counts
% plot settings
gridsz = 0.2;
wsz = 0.1;
mksz = 15;
linew = 1;

% plot
figure;
set(gcf,'color','w','position',[2003 555 733 326],'PaperPositionMode','auto')
hold on;
for n = 1:numClass
    h1 = scatter((n-gridsz)*ones(num_file,1),data_hist(1,:,n),mksz,0*[1 1 1],'o','filled',...
        'linewidth',linew);
    h2 = scatter((n+gridsz)*ones(num_file,1),data_hist(2,:,n),mksz,[0,0.5,1],'o','filled',...
        'linewidth',linew);
    plot((ones(num_file,1)*[(n-gridsz),(n+gridsz)])',squeeze(data_hist(:,:,n)),...
        'color',0.7*[1 1 1],'linewidth',linew);
    plot(n-gridsz+[-wsz,wsz],mean(data_hist(1,:,n))*[1 1],'color',0*[1 1 1],'linewidth',2*linew);
    plot(n+gridsz+[-wsz,wsz],mean(data_hist(2,:,n))*[1 1],'color',[0 0 1],'linewidth',2*linew);
    [~,pval] = ttest(data_hist(1,:,n),data_hist(2,:,n)); % paired t test
    if pval<p
        scatter(n,1.5*max(bhv_hist(:,n)),mksz,'k*');
    end
end
xlim([0 numClass+1]);
set(gca,'xtick',1:numClass,'xticklabel',bhv_str)
ylabel('Time (%)');
box off
legend([h1,h2],'dark','light')

% saveas(gcf,[figpath 'dark_light_cmp_annotype' num2str(annotype) '.fig'])

%% nonactive stats
figure;
set(gcf,'color','w','position',[1977 177 773 212],'PaperPositionMode','auto')

% number of non-active periods
subplot(1,3,1); hold on
scatter((1-gridsz)*ones(num_file,1),nonact_bin_num(1,:),30,0*[1 1 1],'o','filled',...
    'linewidth',linew);
scatter((1+gridsz)*ones(num_file,1),nonact_bin_num(2,:),30,[0,0.5,1],'o','filled',...
    'linewidth',linew);
plot((ones(num_file,1)*[(1-gridsz),(1+gridsz)])',nonact_bin_num,...
    'color',0.7*[1 1 1],'linewidth',linew);
plot(1-gridsz+[-wsz,wsz],mean(nonact_bin_num(1,:))*[1 1],'color',0*[1 1 1],'linewidth',2*linew);
plot(1+gridsz+[-wsz,wsz],mean(nonact_bin_num(2,:))*[1 1],'color',[0 0 1],'linewidth',2*linew);
[~,pval] = ttest(nonact_bin_num(1,:),nonact_bin_num(2,:));
if pval<p
    scatter(1,1.2*max(nonact_bin_num(:)),mksz,'k*');
end
ylabel('# nonactive period')

% length of non-active periods
subplot(1,3,2); hold on
dvec = cell2mat(nonact_bin_len(1,:)')*timeStep/fr/60;
lvec = cell2mat(nonact_bin_len(2,:)')*timeStep/fr/60;
scatter((1-gridsz)*ones(length(dvec),1),dvec,30,0*[1 1 1],...
    'o','filled','linewidth',linew);
scatter((1+gridsz)*ones(length(lvec),1),lvec,30,[0,0.5,1],...
    'o','filled','linewidth',linew);
plot(1-gridsz+[-wsz,wsz],mean(dvec)*[1 1],'color',0*[1 1 1],'linewidth',2*linew);
plot(1+gridsz+[-wsz,wsz],mean(lvec)*[1 1],'color',[0 0 1],'linewidth',2*linew);
[~,pval] = ttest2(dvec,lvec);
if pval<p
    scatter(1,1.2*max([dvec;lvec]),20,'k*');
end
ylabel('Time (min)')

% total time
subplot(1,3,3); hold on
h1 = scatter((1-gridsz)*ones(num_file,1),nonact_T(1,:),30,0*[1 1 1],'o','filled',...
    'linewidth',linew);
h2 = scatter((1+gridsz)*ones(num_file,1),nonact_T(2,:),30,[0,0.5,1],'o','filled',...
    'linewidth',linew);
plot((ones(num_file,1)*[(1-gridsz),(1+gridsz)])',nonact_T,...
    'color',0.7*[1 1 1],'linewidth',linew);
plot(1-gridsz+[-wsz,wsz],mean(nonact_T(1,:))*[1 1],'color',0*[1 1 1],'linewidth',2*linew);
plot(1+gridsz+[-wsz,wsz],mean(nonact_T(2,:))*[1 1],'color',[0 0 1],'linewidth',2*linew);
[~,pval] = ttest(nonact_T(1,:),nonact_T(2,:));
if pval<p
    scatter(1,1.2*max(nonact_T(:)),mksz,'k*');
end
ylabel('nonactive time (%)')
legend([h1,h2],'dark','light')

% saveas(gcf,[figpath 'nonactive_time_annotype' num2str(annotype) '.fig'])



%% instataneous frequency
if 0
    
% plot selected classes
m = 5;
cc = jet(numClass); cc = max(cc-0.3,0);
tvec = timeStep/fr/60/60:timeStep/fr/60/60:numT*timeStep/fr/60/60;
figure; set(gcf,'color','w','position',[2083 131 560 662]);
subplot(m,1,1); hold on
plot(tvec,eth_fr(1,:),'color',cc(1,:));
plot(tvec,eth_fr(6,:),'color',cc(6,:));
legend('silent','contraction')
xlim([tvec(1) tvec(end)])
subplot(m,1,2); hold on
plot(tvec,eth_fr(6,:),'color',cc(6,:));
plot(tvec,eth_fr(5,:),'color',cc(5,:));
plot(tvec,eth_fr(4,:),'color',cc(4,:));
legend('contraction','bending','body sway')
xlim([tvec(1) tvec(end)])
subplot(m,1,3); hold on
plot(tvec,eth_fr(2,:),'color',cc(2,:));
plot(tvec,eth_fr(6,:),'color',cc(6,:));
legend('elongation','contraction')
ylabel('rate')
xlim([tvec(1) tvec(end)])
subplot(m,1,4); hold on
plot(tvec,eth_fr(3,:),'color',cc(3,:));
plot(tvec,eth_fr(7,:),'color',cc(7,:));
legend('tentacle','feeding')
xlim([tvec(1) tvec(end)])

% plot active cycles
th = 0.5;
nonact_prd = eth_act_fr(1,:)>th;

subplot(m,1,5)
imagesc(repmat(nonact_prd,2,1)==0); hold on
h1 = plot(1.5-eth_act_fr(1,:),'color','b');
h2 = plot(1.5-eth_act_fr(2,:),'color','r');
colormap(gray); caxis([-6 1]); box off
xlim([1 size(eth_act_fr,2)]); ylim([0.5 1.5])
set(gca,'xtick',0:2*fr*60*60/timeStep:numT,'xticklabel',0:2:tvec(end))
set(gca,'ytick',[0.5,1,1.5],'yticklabel',[1,0.5,0])
xlabel('Time (h)'); legend([h1,h2],{'nonactive','active'})

suptitle(fstr{n});
saveas(gcf,[dpath{n} fstr{n} '_ethogram_freq_pairs_' num2str(winsz) ...
    'min_annotype' num2str(annotype) '.fig'])

% save results
save([dpath{n} fstr{n} '_act_bin.mat'],'nonact_prd','numT','-v7.3')


%% visualize samples
datapath = {'E:\Data\long_recordings\20161102_dark\',...
    'E:\Data\long_recordings\20161103_light\'};
timeStep = 25;
ifRandomize = 1;
ifsave = 1;

for vis_anno = 1:numClass
    movieParamMulti = paramMulti(datapath{2},findx{2});
    namestr = ['day_class' num2str(vis_anno)];
    visualizeResultMulti(find(light.combined_data==vis_anno),timeStep,movieParamMulti,...
        ifRandomize,ifsave,namestr);

    movieParamMulti = paramMulti(datapath{1},findx{1});
    namestr = ['night_class' num2str(vis_anno)];
    visualizeResultMulti(find(all_data.combined_data==vis_anno),timeStep,movieParamMulti,...
        ifRandomize,ifsave,namestr);
end

end