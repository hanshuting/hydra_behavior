
% findx = [301:2:324;302:2:324]';
% fileIndx = [301:2:312;302:2:312]'; % starved
% fileIndx = [313:2:324;314:2:324]'; % fed
% findx = [325:2:336;326:2:336]';
% findx = [301:2:324,325:2:336;302:2:324,326:2:336]';
% dpath = ['C:\Shuting\Projects\hydra behavior\results\dark_light\svm\20161015\'];
findx = [1001:1011,1023:1033,1045:1055;1012:1022,1034:1044,1056:1066];
dpath = 'C:\Shuting\Projects\hydra behavior\results\day_night\svm\20161024\';
p = 0.05;
annotype = 5;

%% load data
num_expt = size(findx,1);
[~,numClass] = annoInfo(annotype,1);
dark_data = cell(num_expt,1);
light_data = cell(num_expt,1);
dark_hist = zeros(num_expt,numClass);
light_hist = zeros(num_expt,numClass);

for i = 1:num_expt
    
    % dark
    movieParam = paramAll(dpath,findx(i,1));
    load([dpath movieParam.fileName '_annotype' num2str(annotype) '_pred_results.mat']);
    dark_data{i} = pred;
    dark_hist(i,:) = histc(pred,1:numClass)/length(pred);
    
    % light
    movieParam = paramAll(dpath,findx(i,2));
    load([dpath movieParam.fileName '_annotype' num2str(annotype) '_pred_results.mat']);
    light_data{i} = pred;
    light_hist(i,:) = histc(pred,1:numClass)/length(pred);
    
end

%% ethograms
for n = 1:size(findx,1)
    figure; set(gcf,'color','w')
    subplot(2,1,1)
    plotEthogram(dark_data{n},annotype);
    title('dark')
    subplot(2,1,2)
    plotEthogram(light_data{n},annotype);
    title('light')
    saveas(gcf,[dpath 'ethograme' num2str(annotype) '_' num2str(n) '.fig'])
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
    h1 = scatter((n-gridsz)*ones(num_expt,1),dark_hist(:,n),10,0.5*[1 1 1],'o','filled',...
        'linewidth',linew);
    h2 = scatter((n+gridsz)*ones(num_expt,1),light_hist(:,n),10,'ko','filled',...
        'linewidth',linew);
    plot((ones(num_expt,1)*[(n-gridsz),(n+gridsz)])',[dark_hist(:,n),light_hist(:,n)]',...
        'color',0.7*[1 1 1],'linewidth',linew);
    plot(n-gridsz+[-wsz,wsz],mean(dark_hist(:,n))*[1 1],'color',0*[1 1 1],'linewidth',2*linew);
    plot(n+gridsz+[-wsz,wsz],mean(light_hist(:,n))*[1 1],'color',0*[1 1 1],'linewidth',2*linew);
    [~,pval] = ttest(dark_hist(:,n),light_hist(:,n));
    if pval<p
        scatter(1,1.2*max(dark_hist(:,n)),20,'k*');
    end
end
xlim([0 numClass+1]);
set(gca,'xtick',1:numClass,'xticklabel',bhv_str)
ylabel('Time (%)');
box off
legend([h1,h2],'dark','light')

saveas(gcf,[dpath 'behavior_hist_annotype' num2str(annotype) '.fig'])
