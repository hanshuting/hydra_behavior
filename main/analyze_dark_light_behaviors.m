
% fileIndx = [301:2:324;302:2:324]';
% fileIndx = [301:2:312;302:2:312]';
fileIndx = [313:2:324;314:2:324]';
filePath = ['C:\Shuting\Data\DT_results\classification\L_15_W_2_N_32_s_1_'...
    't_1_step_25_K_256_20160510_spseg3_light_dark_behaviors\'];
infostr = 'L_15_W_2_N_32_s_1_t_1_step_25_annoType5';
p = 0.05;

%% load data
t_elong = zeros(size(fileIndx,1),2);
t_cb = zeros(size(fileIndx,1),2);
t_ts = zeros(size(fileIndx,1),2);
t_bs = zeros(size(fileIndx,1),2);

for i = 1:size(fileIndx,1)
    
    % dark
    movieParam = paramAll(fileIndx(i,1));
    load([filePath movieParam.fileName '_' infostr '_drFV_all_prediction.mat']);
    numFrame = length(predictedTest);
    t_elong(i,1) = sum(predictedTest==2)/numFrame;
    t_cb(i,1) = sum(predictedTest==6)/numFrame;
    t_ts(i,1) = sum(predictedTest==3)/numFrame;
    t_bs(i,1) = sum(predictedTest==4)/numFrame;
    
    % light
    movieParam = paramAll(fileIndx(i,2));
    load([filePath movieParam.fileName '_' infostr '_drFV_all_prediction.mat']);
    numFrame = length(predictedTest);
    t_elong(i,2) = sum(predictedTest==2)/numFrame;
    t_cb(i,2) = sum(predictedTest==6)/numFrame;
    t_ts(i,2) = sum(predictedTest==3)/numFrame;
    t_bs(i,2) = sum(predictedTest==4)/numFrame;
    
end

%% plot
h = figure;
set(h,'color','w','position',[1992,394,595,518],'PaperPositionMode','auto')
gridsz = 0.2;

% elongation
subplot(2,2,1);
hold on;
scatter((1-gridsz)*ones(size(t_elong,1),1),...
    t_elong(:,1),'k','linewidth',1);
scatter((1+gridsz)*ones(size(t_elong,1),1),...
    t_elong(:,2),'k','filled','linewidth',1);
plot((ones(size(t_elong,1),1)*[(1-gridsz),(1+gridsz)])',...
    t_elong','k-');
[~,pval] = ttest(t_elong(:,1),t_elong(:,2));
if pval<p
    scatter(1,1.2*max(t_elong(:)),20,'k*');
end
xlim([1-gridsz*2,1+gridsz*2]);
set(gca,'xtick',[1-gridsz,1+gridsz],'xticklabel',{'dark','light'})
ylabel('% elongation');
box off

% contraction
subplot(2,2,2);
hold on;
scatter((1-gridsz)*ones(size(t_cb,1),1),...
    t_cb(:,1),'k','linewidth',1);
scatter((1+gridsz)*ones(size(t_cb,1),1),...
    t_cb(:,2),'k','filled','linewidth',1);
plot((ones(size(t_cb,1),1)*[(1-gridsz),(1+gridsz)])',...
    t_cb','k-');
[~,pval] = ttest(t_cb(:,1),t_cb(:,2));
if pval<p
    scatter(1,1.2*max(t_cb(:)),20,'k*');
end
xlim([1-gridsz*2,1+gridsz*2]);
set(gca,'xtick',[1-gridsz,1+gridsz],'xticklabel',{'dark','light'})
ylabel('% contraction');
box off

% tentacle sway
subplot(2,2,3);
hold on;
scatter((1-gridsz)*ones(size(t_ts,1),1),...
    t_ts(:,1),'k','linewidth',1);
scatter((1+gridsz)*ones(size(t_ts,1),1),...
    t_ts(:,2),'k','filled','linewidth',1);
plot((ones(size(t_ts,1),1)*[(1-gridsz),(1+gridsz)])',...
    t_ts','k-');
[~,pval] = ttest(t_ts(:,1),t_ts(:,2));
if pval<p
    scatter(1,1.2*max(t_ts(:)),20,'k*');
end
xlim([1-gridsz*2,1+gridsz*2]);
set(gca,'xtick',[1-gridsz,1+gridsz],'xticklabel',{'dark','light'})
ylabel('% tentacle sway');
box off

% body sway
subplot(2,2,4);
hold on;
scatter((1-gridsz)*ones(size(t_bs,1),1),...
    t_bs(:,1),'k','linewidth',1);
scatter((1+gridsz)*ones(size(t_bs,1),1),...
    t_bs(:,2),'k','filled','linewidth',1);
plot((ones(size(t_bs,1),1)*[(1-gridsz),(1+gridsz)])',...
    t_bs','k-');
[~,pval] = ttest(t_bs(:,1),t_bs(:,2));
if pval<p
    scatter(1,1.2*max(t_bs(:)),20,'k*');
end
xlim([1-gridsz*2,1+gridsz*2]);
set(gca,'xtick',[1-gridsz,1+gridsz],'xticklabel',{'dark','light'})
ylabel('% body sway');
box off
