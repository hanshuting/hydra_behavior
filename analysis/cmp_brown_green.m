
%% set parameters
% file information

% full dataset
% findx = {{(621:628)',(629:636)',(645:652)',(673:679)',(687:694)',(703:710)'};...
%     {(760:764)',(765:769)',(770:777)',(778:783)',(784:790)'}};

% exclude beginning and end
findx = {{(622:627)',(630:635)',(646:651)',(674:678)',(688:693)',(704:709)'};...
    {(761:764)',(766:769)',(771:776)',(779:782)',(785:789)'}}; % brown; green

dpathbase = 'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\';
dpath = {{[dpathbase '20161026\'],[dpathbase '20161105\'],...
    [dpathbase '20161110\'],[dpathbase '20161203\hydra1\'],...
    [dpathbase '20161203\hydra2\'],[dpathbase '20161211\']};...
    {[dpathbase '20170209\'],[dpathbase '20170209\'],...
    [dpathbase '20170209\'],[dpathbase '20170209\'],...
    [dpathbase '20170209\']}};
name_str = {'vulgaris','viridis'};
cc = {[0.8 0.4 0],[0 0.4 0.2]}; % colors: brown, green

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
% initialize
num_type = 2;
num_expt = cellfun('length',findx);
[~,numClass] = annoInfo(annotype,1);
data = cell(num_type,1);
data_hist = cell(num_type,1); % histogram
R = cell(num_type,1); % rate

% smoothing kernel for calculating rate
winsz = 10; % 10, in min
sig = winsz*60*fr/timeStep;
mu = 2*ceil(2*sig)+1;
fgauss = fspecial('gaussian',[mu,1],sig);

for n = 1:num_type
    for ii = 1:num_expt(n)
        
        % load data
        num_file = length(findx{n}{ii});
        combined_data = [];
        for jj = 1:num_file
            movieParam = paramAll(dpath{n}{ii},findx{n}{ii}(jj));
            load([dpath{n}{ii} movieParam.fileName '_annotype' num2str(annotype) '_pred_results.mat']);
            combined_data(end+1:end+length(pred)) = pred;
        end
        data{n}{ii} = combined_data;
        
        % calculate histogram counts
        data_hist{n}(ii,:) = histc(combined_data,1:numClass)/length(combined_data);
        
        % convolve to get rate for each behavior
        numT = length(combined_data);
        eth_fr = zeros(numClass,numT);
        for jj = 1:numClass
            eth_fr(jj,:) = conv(double(combined_data==jj),fgauss,'same');
        end
        R{n}{ii} = eth_fr;
        
    end
end

%% ethograms
figure; set(gcf,'color','w')
for n = 1:num_type
    for ii = 1:num_expt(n)
        subplot(max(num_expt),num_type,(ii-1)*num_type+n);
        plotEthogram(data{n}{ii}',annotype);
    end
    subplot(max(num_expt),num_type,n);
    title(name_str{n});
end
% saveas(gcf,[dpath 'ethograme' num2str(annotype) '_' num2str(n) '.fig'])

%% plot histogram
stepsz = 0.2;
mksz = 15;
stepseq = [-1 1]*stepsz; % this has to be set manually for now
figure;
set(gcf,'color','w','position',[1963 662 848 384],'PaperPositionMode','auto')
hold on;
for n = 1:num_type
    for ii = 1:num_expt(n)
        scatter((1:numClass)+stepseq(n),data_hist{n}(ii,:),mksz,cc{n},'filled')
    end
    for ii = 1:numClass
        plot([ii+stepseq(n)-0.1,ii+stepseq(n)+0.1],mean(data_hist{n}(:,ii))*[1 1],...
            'color',cc{n},'linewidth',1.5);
    end
end
% significance test
for ii = 1:numClass
    [~,pval] = ttest2(data_hist{1}(:,ii),data_hist{2}(:,ii));
%     pval = ranksum(data_hist{1}(:,ii),data_hist{2}(:,ii));
    if pval < p
        scatter(ii,max([data_hist{1}(:,ii);data_hist{2}(:,ii)])+0.1,'k*');
    end
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
for n = 1:num_type
    for ii = 1:num_expt(n)
        plot3(R{n}{ii}(plot_indx(1),:),R{n}{ii}(plot_indx(2),:),...
            R{n}{ii}(plot_indx(3),:),'linewidth',1.5,'color',cc{n})
    end
end
xlabel(bhv_str{plot_indx(1)})
ylabel(bhv_str{plot_indx(2)})
zlabel(bhv_str{plot_indx(3)})

%% bin to time windows
tw = 30; % in min
bin_len = tw*60*fr/timeStep;

data_bin = cell(num_type,1);
for n = 1:num_type
    data_bin{n} = cell(num_expt(n),1);
    for ii = 1:num_expt(n)
        num_bin = floor(length(data{n}{ii})/bin_len);
        for jj = 1:num_bin
            data_bin{n}{ii}(end+1,:) = histc(data{n}{ii}((jj-1)*bin_len+1:jj*bin_len),...
                1:numClass)/bin_len;
        end
    end
end

% plot
cc_indv = jet(max(num_expt));
cc_indv = max(cc_indv-0.3,0);

stepsz = 0.07;
stepvec = [-3*stepsz:stepsz:3*stepsz];
figure
for n = 1:num_type
    subplot(num_type,1,n); hold on;
    for ii = 1:num_expt(n)
        for jj = 1:size(data_bin{n}{ii},1)
            scatter((1:numClass)+stepvec(ii),data_bin{n}{ii}(jj,:),mksz,cc_indv(ii,:),'filled')
        end
        plot(ones(2,1)*((1:numClass)+stepvec(ii))+stepsz*[-1;1]*ones(1,7),...
            ones(2,1)*mean(data_bin{n}{ii},1),'color',cc_indv(ii,:),'linewidth',3)
    end
    xlim([0 numClass+1]);
    set(gca,'xtick',1:numClass,'xticklabel',bhv_str)
    ylabel('Time (%)');
    title(name_str{n})
    box off
end


