
% findx = [301:2:324;302:2:324]';
% fileIndx = [301:2:312;302:2:312]'; % starved
% fileIndx = [313:2:324;314:2:324]'; % fed
% findx = [325:2:336;326:2:336]';
dark_indx = [601:612]';
light_indx = [302:2:324]';
dpath_dark = 'C:\Shuting\Projects\hydra behavior\results\red_light\svm\20161021\';
dpath_light = 'C:\Shuting\Projects\hydra behavior\results\dark_light\svm\20161015\';
p = 0.05;
annotype = 5;

%% load data
num_dark = size(dark_indx,1);
num_light = size(dark_indx,1);
[~,numClass] = annoInfo(annotype,1);
dark_data = cell(num_dark,1);
light_data = cell(num_light,1);
dark_hist = zeros(num_dark,numClass);
light_hist = zeros(num_light,numClass);

for i = 1:num_dark
    % dark
    movieParam = paramAll(dpath_dark,dark_indx(i));
    load([dpath_dark movieParam.fileName '_annotype' num2str(annotype) '_pred_results.mat']);
    dark_data{i} = pred;
    dark_hist(i,:) = histc(pred,1:numClass)/length(pred);
end
for i = 1:num_light
    % light
    movieParam = paramAll(dpath_light,light_indx(i));
    load([dpath_light movieParam.fileName '_annotype' num2str(annotype) '_pred_results.mat']);
    light_data{i} = pred;
    light_hist(i,:) = histc(pred,1:numClass)/length(pred);
    
end

%% ethograms
for n = 1:size(dark_indx,1)
    figure; set(gcf,'color','w')
    subplot(2,1,1)
    plotEthogram(dark_data{n},annotype);
    title('dark')
%     subplot(2,1,2)
%     plotEthogram(light_data{n},annotype);
%     title('light')
%     saveas(gcf,[dpath 'ethograme' num2str(annotype) '_' num2str(n) '.fig'])
end

%% plot histogram
bhv_str = cell(1,numClass);
for n = 1:numClass
    bhv_str{n} = annoInfo(annotype,n);
end

gridsz = 0.2;
wsz = 0.1;
linew = 1;

figure;
set(gcf,'color','w','position',[1992,394,595,518],'PaperPositionMode','auto')
hold on;
for n = 1:numClass
    h1 = scatter((n-gridsz)*ones(num_dark,1),dark_hist(:,n),10,0*[1 1 1],'o','filled',...
        'linewidth',linew);
    h2 = scatter((n+gridsz)*ones(num_dark,1),light_hist(:,n),10,[0,0,1],'o','filled',...
        'linewidth',linew);
%     plot((ones(num_expt,1)*[(n-gridsz),(n+gridsz)])',[dark_hist(:,n),light_hist(:,n)]',...
%         'color',0.7*[1 1 1],'linewidth',linew);
    plot(n-gridsz+[-wsz,wsz],mean(dark_hist(:,n))*[1 1],'color',0*[1 1 1],'linewidth',2*linew);
    plot(n+gridsz+[-wsz,wsz],mean(light_hist(:,n))*[1 1],'color',[0 0 1],'linewidth',2*linew);
    [~,pval] = ttest(dark_hist(:,n),light_hist(:,n));
    if pval<p
        scatter(n,1.2*max(dark_hist(:,n)),20,'k*');
    end
end
xlim([0 numClass+1]);
set(gca,'xtick',1:numClass,'xticklabel',bhv_str)
ylabel('Time (%)');
box off
legend([h1,h2],'dark','light')

saveas(gcf,[dpath_dark 'behavior_hist_annotype' num2str(annotype) '.fig'])
