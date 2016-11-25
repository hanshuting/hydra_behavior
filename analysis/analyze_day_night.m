
% findx = [301:2:324;302:2:324]';
% fileIndx = [301:2:312;302:2:312]'; % starved
% fileIndx = [313:2:324;314:2:324]'; % fed
% findx = [325:2:336;326:2:336]';
% findx = [301:2:324,325:2:336;302:2:324,326:2:336]';
% dpath = ['C:\Shuting\Projects\hydra behavior\results\dark_light\svm\20161015\'];
% findx = [1001:1011,1023:1033,1045:1055;1012:1022,1034:1044,1056:1066]';
findx = 1001:1066;
flabel = [ones(1,11),2*ones(1,11),ones(1,11),2*ones(1,11),ones(1,11),2*ones(1,11)];
labelstr = {'day','night'};
fpath = 'C:\Shuting\Projects\hydra behavior\results\day_night\svm\20161024\';
p = 0.05;
timeStep = 25;
annotype = 5;

%% load data
num_expt = length(findx);
[~,numClass] = annoInfo(annotype,1);
combined_data = [];
dark_hist = zeros(sum(flabel==1),numClass);
light_hist = zeros(sum(flabel==2),numClass);

bkg_mat = [];
for i = 1:num_expt
    
    % dark
    movieParam = paramAll(fpath,findx(i));
    load([fpath movieParam.fileName '_annotype' num2str(annotype) '_pred_results.mat']);
    combined_data(end+1:end+length(pred)) = pred;
    if flabel(i)==1
        dark_hist(i,:) = histc(pred,1:numClass)/length(pred);
    elseif flabel(i)==2
        light_hist(i,:) = histc(pred,1:numClass)/length(pred);
    else
        fprintf('file not labeled: %s\n',movieParam.fileName);
    end
    bkg_mat(end+1:end+length(pred)) = flabel(i);
end

%% ethograms
figure; set(gcf,'color','w')
imagesc(repmat(2-bkg_mat,numClass,1));
caxis([-10 1]); colormap(gray)
hold on;
plotEthogram(combined_data,annotype);
tmax = floor(length(bkg_mat)/movieParam.fr*timeStep/60/60); % in hours
set(gca,'xtick',0:4*60*60*movieParam.fr/timeStep:tmax*60*60*movieParam.fr/timeStep,...
    'xticklabel',0:4:tmax);
xlabel('Time (h)')
saveas(gcf,[fpath 'ethograme_annotype' num2str(annotype) '.fig'])

%% rate
fr = 2;
timeStep = 25;
winsz = 10; % min
sig = winsz*60*fr/timeStep;
mu = 2*ceil(2*sig)+1;
fgauss = fspecial('gaussian',[mu,1],sig);

bhv_str = cell(1,numClass);
for n = 1:numClass
    bhv_str{n} = annoInfo(annotype,n);
end

eth_fr = zeros(numClass,length(combined_data));
for n = 1:numClass
    eth_fr(n,:) = conv(double(combined_data==n),fgauss,'same');
end

tvec = timeStep/fr/60/60:timeStep/fr/60/60:length(combined_data)*timeStep/fr/60/60;
figure; set(gcf,'color','w')
plot(tvec,eth_fr)
xlim([tvec(1) tvec(end)])
xlabel('Time (h)')
legend(bhv_str);
saveas(gcf,[fpath 'ethogram_freq_' num2str(winsz) 'min_annotype' num2str(annotype) '.fig'])

m = 3;
cc = jet(numClass); cc = max(cc-0.3,0);
figure; set(gcf,'color','w','position',[2220 205 560 420]);
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
xlim([tvec(1) tvec(end)])
xlabel('Time (h)')
saveas(gcf,[fpath 'ethogram_freq_pairs_' num2str(winsz) 'min_annotype' num2str(annotype) '.fig'])


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

% saveas(gcf,[dpath 'behavior_hist_annotype' num2str(annotype) '.fig'])

%% visualize a few examples
datapath = 'E:\Data Timelapse Chris\20160613-18 time lapse WT\processed\';
vis_anno = 1;
timeStep = 25;
ifRandomize = 1;
ifsave = 1;

movieParamMulti = paramMulti(datapath,findx(:,1));
namestr = ['day_class' num2str(vis_anno)];
visualizeResultMulti(find(cell2mat(light_data)==vis_anno),timeStep,movieParamMulti,...
    ifRandomize,ifsave,namestr);

movieParamMulti = paramMulti(datapath,findx(:,2));
namestr = ['night_class' num2str(vis_anno)];
visualizeResultMulti(find(cell2mat(combined_data)==vis_anno),timeStep,movieParamMulti,...
    ifRandomize,ifsave,namestr);


