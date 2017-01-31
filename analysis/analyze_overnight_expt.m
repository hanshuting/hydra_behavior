
% findx = {(621:628)',(613:620)'};
% fstr = {'dark','light'};
% dpath = {'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\20161026\',...
%     'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\20161024\'};

% findx = {(629:636)',(637:644)'};
% fstr = {'dark','light'};
% dpath = {'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\20161105\',...
%     'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\20161105\'};

% findx = {(645:652)',(653:657)'};
% fstr = {'dark','light'};
% dpath = {'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\20161110\',...
%     'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\20161110\'};

% findx = {(673:679)',(680:686)'};
% fstr = {'dark','light'};
% dpath = {'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\20161203\hydra1\',...
%     'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\20161203\hydra1\'};

% findx = {(687:694)',(695:702)'};
% fstr = {'dark','light'};
% dpath = {'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\20161203\hydra2\',...
%     'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\20161203\hydra2\'};

findx = {(703:710)',(711:717)'};
fstr = {'dark','light'};
dpath = {'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\20161211\',...
    'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\20161211\'};

p = 0.05;
annotype = 5;
fr = 5;
timeStep = 25;

%% process results
[~,numClass] = annoInfo(annotype,1);

% hf = figure;
% set(gcf,'color','w','position',[1982 152 615 500])

for n = 1:length(findx)
    
    % load data
    num_file = length(findx{n});
    combined_data = [];

    for ii = 1:num_file
        movieParam = paramAll(dpath{n},findx{n}(ii));
        load([dpath{n} movieParam.fileName '_annotype' num2str(annotype) '_pred_results.mat']);
        combined_data(end+1:end+length(pred)) = pred;
    end
    bhv_hist = histc(combined_data,1:numClass)/length(combined_data);

    bhv_str = cell(1,numClass);
    for ii = 1:numClass
        bhv_str{ii} = annoInfo(annotype,ii);
    end

    save([dpath{n} fstr{n} '_bhv_hist.mat'],'bhv_hist','combined_data','-v7.3')

    %% ethograms
    figure; set(gcf,'color','w')
    plotEthogram(combined_data',annotype);
    title(fstr{n});
%     saveas(gcf,[dpath{n} fstr{n} '_ethogram_annotype' num2str(annotype) '.fig'])
    
    %% instataneous frequency
    winsz = 10; % 10 min
    sig = winsz*60*fr/timeStep;
    mu = 2*ceil(2*sig)+1;
    fgauss = fspecial('gaussian',[mu,1],sig);
    
    % convolve to get rate
    numT = length(combined_data);
    eth_fr = zeros(numClass,numT);
    for ii = 1:numClass
        eth_fr(ii,:) = conv(double(combined_data==ii),fgauss,'same');
    end
    
    % active and nonactive rate
    act_indx = {[1,3],[2,4:6]}; % nonactive & active indices
    eth_act_fr = zeros(2,numT); % first column: non-active; second: active
    for ii = 1:length(act_indx)
        ind = false(size(combined_data));
        for jj = 1:length(act_indx{ii})
            ind = ind|combined_data==act_indx{ii}(jj);
        end
        eth_act_fr(ii,:) = conv(double(ind),fgauss,'same');
    end
    
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
%     qnoise = 0.5;
%     fr_th = eth_act_fr(2,:);
%     fr_th(fr_th>=quantile(eth_act_fr(2,:),qnoise)) = NaN;
%     th = 3*nanstd(fr_th(:))+nanmean(fr_th(:));
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
    
    %% plot power
%     [~,F1,~,P1] = spectrogram(eth_act_fr(1,:),hanning(512),256,1e-5:1e-4:2e-3,fr/timeStep);
%     [~,F2,T,P2] = spectrogram(eth_act_fr(2,:),hanning(512),256,1e-5:1e-4:2e-3,fr/timeStep);
%     
%     figure(hf);
%     subplot(2,2,(n-1)*2+1)
%     imagesc(T*timeStep/60/60,F1,10*log10(P1));
%     axis xy; xlabel('time (h)'); ylabel('Frequency (Hz)'); title([fstr{n} ' nonact']);
%     subplot(2,2,(n-1)*2+2)
%     imagesc(T*timeStep/60/60,F2,10*log10(P2));
%     axis xy; xlabel('time (h)'); ylabel('Frequency (Hz)'); title([fstr{n} ' act']);
%     
%     saveas(gcf,[dpath{n} 'spetrogram_' num2str(winsz) ...
%         'min_annotype' num2str(annotype) '.fig'])
    
end

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
    visualizeResultMulti(find(dark.combined_data==vis_anno),timeStep,movieParamMulti,...
        ifRandomize,ifsave,namestr);
end

%% combine all experiments
fstr = {'dark','light'};
dpathbase = 'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\';
dpath = {[dpathbase '20161026\'],[dpathbase '20161024\'];...
    [dpathbase '20161105\'],[dpathbase '20161105\'];...
    [dpathbase '20161110\'],[dpathbase '20161110\'];...
    [dpathbase '20161203\hydra1\'],[dpathbase '20161203\hydra1\'];...
    [dpathbase '20161203\hydra2\'],[dpathbase '20161203\hydra2\'];...
    [dpathbase '20161211\'],[dpathbase '20161211\']};
% dpath = {[dpathbase '20161211\'],[dpathbase '20161211\']};
figpath = 'C:\Shuting\Projects\hydra behavior\results\long_recording\fig\';
num_file = size(dpath,1);

%% hist
% load data
dark_hist = zeros(num_file,numClass);
light_hist = zeros(num_file,numClass);
for n = 1:num_file
    light = load([dpath{n,2} fstr{2} '_bhv_hist.mat']);
    dark = load([dpath{n,1} fstr{1} '_bhv_hist.mat']);
    dark_hist(n,:) = dark.bhv_hist;
    light_hist(n,:) = light.bhv_hist;
end

% plot settings
gridsz = 0.2;
wsz = 0.1;
linew = 1;

% plot
figure;
set(gcf,'color','w','position',[2003 555 733 326],'PaperPositionMode','auto')
hold on;
for n = 1:numClass
    h1 = scatter((n-gridsz)*ones(num_file,1),dark_hist(:,n),30,0*[1 1 1],'o','filled',...
        'linewidth',linew);
    h2 = scatter((n+gridsz)*ones(num_file,1),light_hist(:,n),30,[0,0.5,1],'o','filled',...
        'linewidth',linew);
    plot((ones(num_file,1)*[(n-gridsz),(n+gridsz)])',[dark_hist(:,n),light_hist(:,n)]',...
        'color',0.7*[1 1 1],'linewidth',linew);
    plot(n-gridsz+[-wsz,wsz],mean(dark_hist(:,n))*[1 1],'color',0*[1 1 1],'linewidth',2*linew);
    plot(n+gridsz+[-wsz,wsz],mean(light_hist(:,n))*[1 1],'color',[0 0 1],'linewidth',2*linew);
    [~,pval] = ttest(dark_hist(:,n),light_hist(:,n)); % paired t test
    if pval<p
        scatter(n,1.5*max(bhv_hist(:,n)),20,'k*');
    end
end
xlim([0 numClass+1]);
set(gca,'xtick',1:numClass,'xticklabel',bhv_str)
ylabel('Time (%)');
box off
legend([h1,h2],'dark','light')

saveas(gcf,[figpath 'dark_light_cmp_annotype' num2str(annotype) '.fig'])

%% nonactive stats
% load data
dark_bin_num = zeros(num_file,1);
light_bin_num = zeros(num_file,1);
darkT = zeros(num_file,1);
lightT = zeros(num_file,1);
dark_bin_len = cell(num_file,1);
light_bin_len = cell(num_file,1);
for n = 1:num_file
    dark = load([dpath{n,1} fstr{1} '_act_bin.mat']);
    light = load([dpath{n,2} fstr{2} '_act_bin.mat']);
    dark_iv = bn_to_iv(dark.nonact_prd);
    light_iv = bn_to_iv(light.nonact_prd);
    darkT(n) = sum(dark.nonact_prd)/dark.numT;
    lightT(n) = sum(light.nonact_prd)/light.numT;
    dark_bin_num(n) = size(dark_iv,1)/(dark.numT*timeStep/fr/60/60);
    light_bin_num(n) = size(light_iv,1)/(light.numT*timeStep/fr/60/60);
    dark_bin_len{n} = dark_iv(:,2)-dark_iv(:,1);
    light_bin_len{n} = light_iv(:,2)-light_iv(:,1);
end

% plot settings
gridsz = 0.2;
wsz = 0.1;
linew = 1;

% plot
figure;
set(gcf,'color','w','position',[1977 177 773 212],'PaperPositionMode','auto')
subplot(1,3,1); hold on
scatter((1-gridsz)*ones(num_file,1),dark_bin_num,30,0*[1 1 1],'o','filled',...
    'linewidth',linew);
scatter((1+gridsz)*ones(num_file,1),light_bin_num,30,[0,0.5,1],'o','filled',...
    'linewidth',linew);
plot((ones(num_file,1)*[(1-gridsz),(1+gridsz)])',[dark_bin_num,light_bin_num]',...
    'color',0.7*[1 1 1],'linewidth',linew);
plot(1-gridsz+[-wsz,wsz],mean(dark_bin_num)*[1 1],'color',0*[1 1 1],'linewidth',2*linew);
plot(1+gridsz+[-wsz,wsz],mean(light_bin_num)*[1 1],'color',[0 0 1],'linewidth',2*linew);
[~,pval] = ttest(dark_bin_num,light_bin_num);
if pval<p
    scatter(1,1.2*max([dark_bin_num light_bin_num]),20,'k*');
end
ylabel('# nonactive period')

subplot(1,3,2); hold on
dvec = cell2mat(dark_bin_len)*timeStep/fr/60;
lvec = cell2mat(light_bin_len)*timeStep/fr/60;
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

subplot(1,3,3); hold on
h1 = scatter((1-gridsz)*ones(num_file,1),darkT,30,0*[1 1 1],'o','filled',...
    'linewidth',linew);
h2 = scatter((1+gridsz)*ones(num_file,1),lightT,30,[0,0.5,1],'o','filled',...
    'linewidth',linew);
plot((ones(num_file,1)*[(1-gridsz),(1+gridsz)])',[darkT,lightT]',...
    'color',0.7*[1 1 1],'linewidth',linew);
plot(1-gridsz+[-wsz,wsz],mean(darkT)*[1 1],'color',0*[1 1 1],'linewidth',2*linew);
plot(1+gridsz+[-wsz,wsz],mean(lightT)*[1 1],'color',[0 0 1],'linewidth',2*linew);
[~,pval] = ttest(darkT,lightT);
if pval<p
    scatter(1,1.2*max([darkT lightT]),20,'k*');
end
ylabel('nonactive time (%)')
legend([h1,h2],'dark','light')

saveas(gcf,[figpath 'nonactive_time_annotype' num2str(annotype) '.fig'])
