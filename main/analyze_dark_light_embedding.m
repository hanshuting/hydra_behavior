
fileIndx = [301:2:324;302:2:324]';
% fileIndx = [301:2:312;302:2:312]'; % light/dark fed
% fileIndx = [313:2:324;314:2:324]'; % light/dark starved
K = 256;
infostr = 'L_15_W_2_N_32_s_1_t_1_step_25_K_256';
datastr = '20160510_spseg3';
modelstr = '20160323_spseg3';
filePath = ['E:\galois\results\embedding\' infostr '_' datastr '_by_'...
    modelstr '\'];
modelpath = 'E:\galois\results\embedding\';
savepath = ['E:\galois\results\embedding\' infostr '_light_dark'];
p = 0.05;

%% load data
load([modelpath infostr '_' modelstr '_emspace.mat']);

t_elong = zeros(size(fileIndx,1),2);
t_cb = zeros(size(fileIndx,1),2);
t_ts = zeros(size(fileIndx,1),2);
t_bs = zeros(size(fileIndx,1),2);
t_fd3 = zeros(size(fileIndx,1),2);

for i = 1:size(fileIndx,1);

    %% dark
    movieParam = paramAll(fileIndx(i,1));
    fprintf('processing %s...\n',movieParam.fileName);
    
    load([filePath movieParam.fileName '_embedding.mat']);
    
    % data to analyze
    vdata = emData-ones(size(emData,1),1)*mu;
    vdata = round((vdata/maxVal*numPoints+numPoints)/2);
    vdata(vdata<=0) = 1;
    vdata(vdata>=numPoints) = numPoints;
    regIndx = region_im_trans(sub2ind(size(region_im_trans),vdata(:,1),vdata(:,2)));
    
    numFrame = size(emData,1);
    t_elong(i,1) = sum(regIndx==2)/numFrame;
    t_cb(i,1) = sum(regIndx==6)/numFrame;
    t_ts(i,1) = sum(regIndx==3)/numFrame;
    t_bs(i,1) = sum(regIndx==4)/numFrame;
    t_fd3(i,1) = sum(regIndx==10)/numFrame;

    %% light
    movieParam = paramAll(fileIndx(i,2));
    fprintf('processing %s...\n',movieParam.fileName);
    
    load([filePath movieParam.fileName '_embedding.mat']);
    
    % data to analyze
    vdata = emData-ones(size(emData,1),1)*mu;
    vdata = round((vdata/maxVal*numPoints+numPoints)/2);
    vdata(vdata<=0) = 1;
    vdata(vdata>=numPoints) = numPoints;
    regIndx = region_im_trans(sub2ind(size(region_im_trans),vdata(:,1),vdata(:,2)));
    
    numFrame = size(emData,1);
    t_elong(i,2) = sum(regIndx==2)/numFrame;
    t_cb(i,2) = sum(regIndx==6)/numFrame;
    t_ts(i,2) = sum(regIndx==3)/numFrame;
    t_bs(i,2) = sum(regIndx==4)/numFrame;
    t_fd3(i,2) = sum(regIndx==10)/numFrame;

    
end


%% plot
h = figure;
set(h,'color','w','position',[1992,394,595,518],'PaperPositionMode','auto')
gridsz = 0.2;

% elongation
subplot(2,2,1);
hold on;
pdata = t_elong;
scatter((1-gridsz)*ones(size(pdata,1),1),...
    pdata(:,1),'k','linewidth',1);
scatter((1+gridsz)*ones(size(pdata,1),1),...
    pdata(:,2),'k','filled','linewidth',1);
plot((ones(size(pdata,1),1)*[(1-gridsz),(1+gridsz)])',...
    pdata','k-');
[~,pval] = ttest(pdata(:,1),pdata(:,2));
if pval<p
    scatter(1,1.2*max(pdata(:)),20,'k*');
end
xlim([1-gridsz*2,1+gridsz*2]);
set(gca,'xtick',[1-gridsz,1+gridsz],'xticklabel',{'dark','light'})
ylabel('% elongation');
box off

% contraction
subplot(2,2,2);
hold on;
pdata = t_cb;
scatter((1-gridsz)*ones(size(pdata,1),1),...
    pdata(:,1),'k','linewidth',1);
scatter((1+gridsz)*ones(size(pdata,1),1),...
    pdata(:,2),'k','filled','linewidth',1);
plot((ones(size(pdata,1),1)*[(1-gridsz),(1+gridsz)])',...
    pdata','k-');
[~,pval] = ttest(pdata(:,1),pdata(:,2));
if pval<p
    scatter(1,1.2*max(pdata(:)),20,'k*');
end
xlim([1-gridsz*2,1+gridsz*2]);
set(gca,'xtick',[1-gridsz,1+gridsz],'xticklabel',{'dark','light'})
ylabel('% contraction');
box off

% tentacle sway
subplot(2,2,3);
hold on;
pdata = t_ts;
scatter((1-gridsz)*ones(size(pdata,1),1),...
    pdata(:,1),'k','linewidth',1);
scatter((1+gridsz)*ones(size(pdata,1),1),...
    pdata(:,2),'k','filled','linewidth',1);
plot((ones(size(pdata,1),1)*[(1-gridsz),(1+gridsz)])',...
    pdata','k-');
[~,pval] = ttest(pdata(:,1),pdata(:,2));
if pval<p
    scatter(1,1.2*max(pdata(:)),20,'k*');
end
xlim([1-gridsz*2,1+gridsz*2]);
set(gca,'xtick',[1-gridsz,1+gridsz],'xticklabel',{'dark','light'})
ylabel('% tentacle sway');
box off

% body sway
subplot(2,2,4);
hold on;
pdata = t_bs;
scatter((1-gridsz)*ones(size(pdata,1),1),...
    pdata(:,1),'k','linewidth',1);
scatter((1+gridsz)*ones(size(pdata,1),1),...
    pdata(:,2),'k','filled','linewidth',1);
plot((ones(size(pdata,1),1)*[(1-gridsz),(1+gridsz)])',...
    pdata','k-');
[~,pval] = ttest(pdata(:,1),pdata(:,2));
if pval<p
    scatter(1,1.2*max(pdata(:)),20,'k*');
end
xlim([1-gridsz*2,1+gridsz*2]);
set(gca,'xtick',[1-gridsz,1+gridsz],'xticklabel',{'dark','light'})
ylabel('% body sway');
box off
