% ANALYZE SOMERSULTING BEHAVIOR

annotype = 13;
timeStep = 25;
dpath = 'C:\Shuting\Projects\hydra behavior\results\ss_svm\20170321\';
spath = 'C:\Shuting\Projects\hydra behavior\results\ss_pred\';
[~,numClass] = annoInfo(annotype,1);

findx = [502,504,506,304,310,640];
sstw = {1000/timeStep:1550/timeStep,8800/timeStep:9350/timeStep,...
    2950/timeStep:3300/timeStep,7150/timeStep:7700/timeStep,...
    700/timeStep:1425/timeStep,17750/timeStep:18100/timeStep};
ctrltw = {3000/timeStep:3500/timeStep,2000/timeStep:2500/timeStep,...
    4000/timeStep:4500/timeStep,1:500/timeStep,...
    2000/timeStep:2700/timeStep,1:350/timeStep};
vidpath = {'F:\Projects\Summer2016\Sol_ColMedium\',...
    'F:\Projects\Summer2016\Sol_ColMedium\',...
    'F:\Projects\Summer2016\Sol_ColMedium\',...
    'F:\Data\dark_light_behaviors\',...
    'F:\Data\dark_light_behaviors\',...
    'F:\Data\long_recordings\20161103_light\'};

% behavior types to plot
btype = [4,5,6];

% smoothing kernel size
fr = 5; % frame rate
winsz = 0.2; % 10, in min
sig = ceil(winsz*60*fr/timeStep);
mu = 2*ceil(2*sig)+1;
fgauss = fspecial('gaussian',[mu,1],sig);

% plot settings
linew = 1;
cc = struct();
cc.gray = 0.8*[1 1 1];

%% load data
num_file = length(findx);
pred_all = cell(num_file,1);
score_all = cell(num_file,1);
for n = 1:num_file
    load([dpath fileinfo(findx(n)) '_annotype' num2str(annotype) '_pred_results.mat']);
    pred_all{n} = pred;
    score_all{n} = pred_score;
end

%% plot result
% ethogram
figure; set(gcf,'color','w')
for n = 1:num_file
    subplot(num_file,1,n);
    pred = double(pred_all{n}==1);
    text(find(pred),ones(sum(pred~=0),1),'|','fontsize',15)
    xlim([1 length(pred)]); ylim([0.8 1.2])
    box on; set(gca,'ytick',[])
end
xlabel('frame')

%% visualize
ifrand = 1;
ifsave = 1;
for n = 1:num_file
    pred = pred_all{n};
    movieParam = paramAll(vidpath{n},findx(n));
    visualizeResult(find(pred==1),timeStep,movieParam,ifrand,ifsave,movieParam.fileName);
end

% plot_ss_files(dpath,findx(n),annotype,sstw{n},ctrltw{n},fgauss,...
%         btype,hf,vpath,spath,timeStep,numClass,linew,cc,ifsave,ifvis)
