
% dark only dataset
findx = {(621:628)',(629:636)',(645:652)',(673:679)',(687:694)',(703:710)'};
dpathbase = 'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\';
dpath = {[dpathbase '20161026\'];[dpathbase '20161105\'];...
    [dpathbase '20161110\'];[dpathbase '20161203\hydra1\'];...
    [dpathbase '20161203\hydra2\'];[dpathbase '20161211\']};

p = 0.05;
annotype = 5;
timeStep = 25;
fr = 5; % frame rate

[~,numClass] = annoInfo(annotype,1);
bhv_str = cell(1,numClass);
for n = 1:numClass
    bhv_str{n} = annoInfo(annotype,n);
end

%% load data
num_expt = length(findx);
[~,numClass] = annoInfo(annotype,1);
data = cell(num_expt,1);
data_hist = zeros(num_expt,numClass);
R = cell(num_expt,1);

% smoothing kernel for calculating rate
winsz = 10; % 10, in min
sig = winsz*60*fr/timeStep;
mu = 2*ceil(2*sig)+1;
fgauss = fspecial('gaussian',[mu,1],sig);

for n = 1:num_expt
    
    % load data
    num_file = length(findx{n});
    combined_data = [];
    for ii = 1:num_file
        movieParam = paramAll(dpath{n},findx{n}(ii));
        load([dpath{n} movieParam.fileName '_annotype' num2str(annotype) '_pred_results.mat']);
        combined_data(end+1:end+length(pred)) = pred;
    end
    data{n} = combined_data;
    
    % calculate histogram counts
    data_hist(n,:) = histc(combined_data,1:numClass)/length(combined_data);
    
    % convolve to get rate for each behavior
    numT = length(combined_data);
    eth_fr = zeros(numClass,numT);
    for ii = 1:numClass
        eth_fr(ii,:) = conv(double(combined_data==ii),fgauss,'same');
    end
    R{n} = eth_fr;
    
end

%% ethograms
figure; set(gcf,'color','w')
for n = 1:num_expt
    subplot(num_expt,1,n);
    plotEthogram(data{n}',annotype);
end
% saveas(gcf,[dpath 'ethograme' num2str(annotype) '_' num2str(n) '.fig'])

%% plot histogram
figure;
set(gcf,'color','w','position',[1992,394,595,518],'PaperPositionMode','auto')
hold on;
for n = 1:num_expt
    scatter(1:numClass,data_hist(n,:),'filled')
end
xlim([0 numClass+1]);
set(gca,'xtick',1:numClass,'xticklabel',bhv_str)
ylabel('Time (%)');
box off

% saveas(gcf,[dpath 'behavior_hist_annotype' num2str(annotype) '.fig'])

%% plot rate
% behavior types to plot
plot_indx = [3,4,6]; 

% plot now
figure; set(gcf,'color','w')
hold on
for n = 1:num_expt
    plot3(R{n}(plot_indx(1),:),R{n}(plot_indx(2),:),R{n}(plot_indx(3),:),'linewidth',1.5)
end
xlabel(bhv_str{plot_indx(1)})
ylabel(bhv_str{plot_indx(2)})
zlabel(bhv_str{plot_indx(3)})

%% bin to time windows
tw = 30; % in min
bin_len = tw*60*fr/timeStep;

data_bin = cell(num_expt,1);
for n = 1:num_expt
    num_bin = floor(length(data{n})/bin_len);
    for ii = 1:num_bin
        data_bin{n}(end+1,:) = histc(data{n}((ii-1)*bin_len+1:ii*bin_len),...
            1:numClass)/bin_len;
    end
end

% plot
cc = jet(num_expt);
cc = max(cc-0.3,0);

stepsz = 0.07;
stepvec = [-3*stepsz:stepsz:3*stepsz];
figure
hold on;
for n = 1:num_expt
    for ii = 1:size(data_bin{n},1)
        scatter((1:numClass)+stepvec(n),data_bin{n}(ii,:),15,cc(n,:),'filled')
    end
    plot(ones(2,1)*((1:numClass)+stepvec(n))+stepsz*[-1;1]*ones(1,7),...
        ones(2,1)*mean(data_bin{n},1),'color',cc(n,:),'linewidth',3)
end
xlim([0 numClass+1]);
set(gca,'xtick',1:numClass,'xticklabel',bhv_str)
ylabel('Time (%)');
box off

