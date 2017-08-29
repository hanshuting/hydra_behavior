% ANALYZE SOMERSULTING BEHAVIOR

annotype = 5;
timeStep = 25;
spath = 'C:\Shuting\Projects\hydra behavior\results\ss_pred\';
ifvis = 0;
ifsave = 0;
[~,numClass] = annoInfo(annotype,1);

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

%% from new sample
dpath = 'C:\Shuting\Projects\hydra behavior\results\svm\20161019\';
load([dpath 'annotype' num2str(annotype) '_mat_results.mat']);
sstw = 1:1925/timeStep;
ctrltw = 3000/timeStep:5000/timeStep;
% sstw = 975/timeStep:1300/timeStep;
% ctrltw = 4000/timeStep:4500/timeStep;
sspred = pred.new_soft{2}(sstw,:);
ctrlpred = pred.new_soft{2}(ctrltw,:);

% calculate firing rate
eth_fr = zeros(numClass,length(sstw));
ctrl_fr = zeros(numClass,length(ctrltw));
for ii = 1:numClass
    eth_fr(ii,:) = conv(double(sspred(:,1)==ii),fgauss,'same');
    ctrl_fr(ii,:) = conv(double(ctrlpred(:,1)==ii),fgauss,'same');
%     eth_fr(ii,:) = movmean(double(sspred(:,1)==ii),sig);
%     ctrl_fr(ii,:) = movmean(double(ctrlpred(:,1)==ii),sig);
end

% plot trajectory
hf = figure; hold on
plot3(eth_fr(btype(1),:),eth_fr(btype(2),:),eth_fr(btype(3),:),'linewidth',linew)
plot3(ctrl_fr(btype(1),:),ctrl_fr(btype(2),:),ctrl_fr(btype(3),:),'linewidth',linew,...
    'color',cc.gray)

% ethogram
figure; set(gcf,'color','w','position',[1978 789 571 161])
plotEthogram(sspred,annotype)
% plotEthogram(pred.new{2}(sstw,:),annotype);
if ifsave
    saveas(gcf,[spath fileinfo(fileIndx(n)) '_ss_pred_ethogram.fig']);
    print(gcf,'-dpdf','-painters','-bestfit',[spath 'new_ss_pred_ethogram.pdf']);
end

% % make sentence
% sspred_word = cell(size(sspred));
% for i = 1:size(sspred,1)
%     for j = 1:size(sspred,2)
%         if ~isnan(sspred(i,j))
%             sspred_word{i,j} = annoInfo(annotype,sspred(i,j));
%         end
%     end
% end
% 
% % print sentence
% for i = 1:size(sspred,1)
%     fprintf('%s',sspred_word{i,1});
%     for j = 2:size(sspred,2)
%         if ~isnan(sspred(i,j))
%             fprintf('/%s',sspred_word{i,j});
%         end
%     end
%     if i~=size(sspred,1)
%         fprintf(' -> \n');
%     else
%         fprintf('\n');
%     end
% end


% visualize
if ifvis
    vpath = 'E:\Data\hydra_behavior\bkg_subtracted\';
    movieParam = paramAll(vpath,33);
    makeAnnotatedMovie(1:length(sstw),sspred,annotype,movieParam,timeStep,0.1,1);
end

%% from medium swap experiment
fileIndx = [502,504,506];
% sstw = {1:1900/timeStep,6250/timeStep:9600/timeStep,1:4000/timeStep};
% ctrltw = {3000/timeStep:5000/timeStep,2000/timeStep:4000/timeStep,4025/timeStep:8000/timeStep};
sstw = {1000/timeStep:1550/timeStep,8800/timeStep:9350/timeStep,2950/timeStep:3300/timeStep};
ctrltw = {3000/timeStep:3500/timeStep,2000/timeStep:2500/timeStep,4000/timeStep:4500/timeStep};
dpath = 'C:\Shuting\Projects\hydra behavior\results\medium_swap\svm\20161121\';
vpath = 'E:\Projects\Summer2016\Sol_ColMedium\';

for n = 1:length(fileIndx)
    plot_ss_files(dpath,fileIndx(n),annotype,sstw{n},ctrltw{n},fgauss,...
        btype,hf,vpath,spath,timeStep,numClass,linew,cc,ifsave,ifvis)
end

%% from dark/light experiment
% dataset 1
fileIndx = [304,310];%,328,332,330];
sstw = {7150/timeStep:7700/timeStep,700/timeStep:1425/timeStep};
ctrltw = {1:500/timeStep,2000/timeStep:2700/timeStep};
dpath = 'C:\Shuting\Projects\hydra behavior\results\dark_light\svm\20161215\';
vpath = 'E:\Data\dark_light_behaviors\';

for n = 1:length(fileIndx)
    plot_ss_files(dpath,fileIndx(n),annotype,sstw{n},ctrltw{n},fgauss,...
        btype,hf,vpath,spath,timeStep,numClass,linew,cc,ifsave,ifvis)
end

% dataset 2: 332, 330 are ss-like but failed attempts
fileIndx = [328,332,330];
sstw = {3700/timeStep:4200/timeStep,5400/timeStep:5625/timeStep,...
    4100/timeStep:4300/timeStep};
ctrltw = {1:500/timeStep,1:225/timeStep,1:200/timeStep};
dpath = 'C:\Shuting\Projects\hydra behavior\results\dark_light\svm\20161015\';
vpath = 'E:\Data\dark_light_behaviors\';

for n = 1:length(fileIndx)
    plot_ss_files(dpath,fileIndx(n),annotype,sstw{n},ctrltw{n},fgauss,...
        btype,hf,vpath,spath,timeStep,numClass,linew,cc,ifsave,ifvis)
end

%% long recordings
fileIndx = [640];
sstw = {17750/timeStep:18100/timeStep};
ctrltw = {1:350/timeStep};
dpath = 'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\20161105\';
vpath = '';

for n = 1:length(fileIndx)
    plot_ss_files(dpath,fileIndx(n),annotype,sstw{n},ctrltw{n},fgauss,...
        btype,hf,vpath,spath,timeStep,numClass,linew,cc,ifsave,ifvis)
end

%% clean up figures
figure(hf)
set(gcf,'color','w')
xlabel(annoInfo(annotype,btype(1)));
ylabel(annoInfo(annotype,btype(2)));
zlabel(annoInfo(annotype,btype(3)));

