
% I don't remember the hydra of starved dataset were big or small
% findx = {[302:2:312],1104:1113}; % starved/fed; small
% findx = {[302:2:312],[1114,1118,1119,1121:1123,1125]}; % starved/fed; big
findx = {[1126:1134],[1114,1118,1119,1121:1123,1125]}; % starved/fed; big, new

% dpath = {'C:\Shuting\Projects\hydra behavior\results\dark_light\svm\20161215\',...
%     'C:\Shuting\Projects\hydra behavior\results\big_small_fed\svm\20170301\'};
dpath = {'C:\Shuting\Projects\hydra behavior\results\starved_light\svm\',...
    'C:\Shuting\Projects\hydra behavior\results\big_small_fed\svm\20170301\'};
p = 0.05;
annotype = 5;

%% load data
num_expt = cellfun('length',findx);
[~,numClass] = annoInfo(annotype,1);

% starved
stv_data = cell(num_expt(1),1);
stv_hist = zeros(num_expt(1),numClass);
for ii = 1:num_expt(1)
    movieParam = paramAll(dpath{1},findx{1}(ii));
    load([dpath{1} movieParam.fileName '_annotype' num2str(annotype) '_pred_results.mat']);
    stv_data{ii} = pred;
    stv_hist(ii,:) = histc(pred,1:numClass)/length(pred);
end

% fed
fed_data = cell(num_expt(2),1);
fed_hist = zeros(num_expt(2),numClass);
for ii = 1:num_expt(2)
    movieParam = paramAll(dpath{2},findx{2}(ii));
    load([dpath{2} movieParam.fileName '_annotype' num2str(annotype) '_pred_results.mat']);
    fed_data{ii} = pred;
    fed_hist(ii,:) = histc(pred,1:numClass)/length(pred);
end

%% ethograms
figure; set(gcf,'color','w')
subplot(max(num_expt),2,1); title('small');
subplot(max(num_expt),2,2); title('large');
for n = 1:num_expt(1)
    subplot(max(num_expt),2,(n-1)*2+1)
    plotEthogram(stv_data{n},annotype);
end
for n = 1:num_expt(2)
    subplot(max(num_expt),2,(n-1)*2+2)
    plotEthogram(fed_data{n},annotype);
end
% saveas(gcf,[dpath 'ethograme' num2str(annotype) '_' num2str(n) '.fig'])

%% plot histogram
bhv_str = cell(1,numClass);
for n = 1:numClass
    bhv_str{n} = annoInfo(annotype,n);
end

gridsz = 0.2;
wsz = 0.2;
linew = 1;

pval = zeros(numClass,1);
figure;
set(gcf,'color','w','position',[1992,394,595,518],'PaperPositionMode','auto')
hold on;
for n = 1:numClass
    h1 = scatter((n-gridsz)*ones(num_expt(1),1),stv_hist(:,n),15,[0 0.5 1],'o','filled',...
        'linewidth',linew);
    h2 = scatter((n+gridsz)*ones(num_expt(2),1),fed_hist(:,n),15,[1 0.4 0.4],'o','filled',...
        'linewidth',linew);
%     plot((ones(num_expt,1)*[(n-gridsz),(n+gridsz)])',[small_hist(:,n),large_hist(:,n)]',...
%         'color',0.7*[1 1 1],'linewidth',linew);
    plot(n-gridsz+[-wsz,wsz],mean(stv_hist(:,n))*[1 1],'color',[0 0.5 1],'linewidth',2*linew);
    plot(n+gridsz+[-wsz,wsz],mean(fed_hist(:,n))*[1 1],'color',[1 0.4 0.4],'linewidth',2*linew);
    pval(n) = ranksum(stv_hist(:,n),fed_hist(:,n));
    if pval(n)<p
        scatter(n,1.2*max(stv_hist(:,n)),20,'k*');
    end
end
xlim([0 numClass+1]);
set(gca,'xtick',1:numClass,'xticklabel',bhv_str)
ylabel('Time (%)');
box off
legend([h1,h2],'starved','fed')

% saveas(gcf,[dpath 'behavior_hist_annotype' num2str(annotype) '.fig'])

%% CB with length data
fr = 5;
segpath = {'C:\Shuting\Projects\hydra behavior\results\starved_light\seg\',...
    'C:\Shuting\Projects\hydra behavior\results\big_small_fed\seg\20170301\'};
len = cell(size(findx));
for n = 1:2
    for m = 1:length(findx{n})
        seg_info = load([segpath{n} fileinfo(findx{n}(m)) '_seg.mat']);
        len{n}{m} = seg_info.a;
    end
end

% moving average
wsz = 5*fr*60;
len_mw = cell(size(findx));
for n = 1:2
    for m = 1:length(findx{n})
        for ii = 1:length(len{n}{m})
            len_mw{n}{m}(ii) = mean(len{n}{m}(max([1,ii-wsz]):ii))-...
                mean(len{n}{m}(ii:min([length(len{n}{m}),ii+wsz])));
        end
    end
end

% find peaks
cb_pks = cell(size(findx));
for n = 1:2
    for m = 1:length(findx{n})
        [~,t] = findpeaks(len_mw{n}{m},'minpeakheight',10,'minpeakprominence',1.2);
        cb_pks{n}{m} = t;
    end
end

% plot
num_pl = max(cellfun('length',findx));
figure;
for n = 1:2
    for m = 1:length(findx{n})
        subplot(num_pl,2,(m-1)*2+n)
        plot(len{n}{m}); hold on
        plot(len_mw{n}{m},'r');
        scatter(cb_pks{n}{m},len_mw{n}{m}(cb_pks{n}{m}),'k*')
        xlim([1 length(len{n}{m})]);
        ylim([min(len_mw{n}{m}) max(len{n}{m})])
    end
end

% count
cb_freq = cell(2,1);
for n = 1:2
    cb_freq{n} = cellfun('length',cb_pks{n})./cellfun('length',len{n})*fr;
end
figure; hold on
scatter(ones(1,length(cb_freq{1})),cb_freq{1},'bo','filled')
scatter(2*ones(1,length(cb_freq{2})),cb_freq{2},'ro','filled')
plot(1+0.2*[-1 1],mean(cb_freq{1})*[1 1],'b','linewidth',1.5)
plot(2+0.2*[-1 1],mean(cb_freq{2})*[1 1],'r','linewidth',1.5)
xlim([0 3])


