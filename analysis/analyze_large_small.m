
% findx = {[902,904,905,907,910],[901,903,906,908,909]}; % small, large
findx = {1104:1113,[1114,1118,1119,1121:1123,1125]}; % small, large; excluded floating hydra

dpath = 'C:\Shuting\Projects\hydra behavior\results\big_small_fed\svm\20170301\';
p = 0.05;
annotype = 5;

%% load data
num_expt = cellfun('length',findx);
[~,numClass] = annoInfo(annotype,1);

% small
small_data = cell(num_expt(1),1);
small_hist = zeros(num_expt(1),numClass);
for ii = 1:num_expt(1)
    movieParam = paramAll(dpath,findx{1}(ii));
    load([dpath movieParam.fileName '_annotype' num2str(annotype) '_pred_results.mat']);
    small_data{ii} = pred;
    small_hist(ii,:) = histc(pred,1:numClass)/length(pred);
end

% large
large_data = cell(num_expt(2),1);
large_hist = zeros(num_expt(2),numClass);
for ii = 1:num_expt(2)
    movieParam = paramAll(dpath,findx{2}(ii));
    load([dpath movieParam.fileName '_annotype' num2str(annotype) '_pred_results.mat']);
    large_data{ii} = pred;
    large_hist(ii,:) = histc(pred,1:numClass)/length(pred);
end

%% ethograms
figure; set(gcf,'color','w')
subplot(max(num_expt),2,1); title('small');
subplot(max(num_expt),2,2); title('large');
for n = 1:num_expt(1)
    subplot(max(num_expt),2,(n-1)*2+1)
    plotEthogram(small_data{n},annotype);
end
for n = 1:num_expt(2)
    subplot(max(num_expt),2,(n-1)*2+2)
    plotEthogram(large_data{n},annotype);
end
% saveas(gcf,[dpath 'ethograme' num2str(annotype) '_' num2str(n) '.fig'])

%% plot histogram
bhv_str = cell(1,numClass);
for n = 1:numClass
    bhv_str{n} = annoInfo(annotype,n);
end

gridsz = 0.2;
wsz = 0.1;
linew = 1;

pval = zeros(numClass,1);
figure;
set(gcf,'color','w','position',[1992,394,595,518],'PaperPositionMode','auto')
hold on;
for n = 1:numClass
    h1 = scatter((n-gridsz)*ones(num_expt(1),1),small_hist(:,n),15,[0 0.5 1],'o','filled',...
        'linewidth',linew);
    h2 = scatter((n+gridsz)*ones(num_expt(2),1),large_hist(:,n),15,[1 0.4 0.4],'o','filled',...
        'linewidth',linew);
%     plot((ones(num_expt,1)*[(n-gridsz),(n+gridsz)])',[small_hist(:,n),large_hist(:,n)]',...
%         'color',0.7*[1 1 1],'linewidth',linew);
    plot(n-gridsz+[-wsz,wsz],mean(small_hist(:,n))*[1 1],'color',0*[1 1 1],'linewidth',2*linew);
    plot(n+gridsz+[-wsz,wsz],mean(large_hist(:,n))*[1 1],'color',0*[1 1 1],'linewidth',2*linew);
    pval(n) = ranksum(small_hist(:,n),large_hist(:,n));
    if pval(n)<p
        scatter(n,1.2*max(small_hist(:,n)),20,'k*');
    end
end
xlim([0 numClass+1]);
set(gca,'xtick',1:numClass,'xticklabel',bhv_str)
ylabel('Time (%)');
box off
legend([h1,h2],'small','large')

% saveas(gcf,[dpath 'behavior_hist_annotype' num2str(annotype) '.fig'])
