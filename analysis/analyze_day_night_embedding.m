
findx = {1001:1011,1023:1033,1045:1055;1012:1022,1034:1044,1056:1066}';
fname = 'L_15_W_5_N_32_s_1_t_1_step_25_20161024_unsp_workspace';
fpath = 'C:\Shuting\Projects\hydra behavior\results\day_night\tsne\';
segpath = 'C:\Shuting\Projects\hydra behavior\results\day_night\seg\';
dpath = 'E:\Data Timelapse Chris\20160613-18 time lapse WT\processed\';
p = 0.05;
fr = 2; % this dataset is 1Hz
timeStep = 25; % but I still used 25 as window size
time_cvs = 1/fr/60/60; % hours

% Chris's detection result
load('E:\Data Timelapse Chris\egestion_detection\egt_cd.mat');

% load embedding result
load([fpath fname '.mat']);

%% load data
% load width data
wd = cell(size(findx));
for n = 1:2
    for m = 1:size(findx,1)
        b_vec = [];
        for ii = 1:length(findx{m,n})
            seg_info = load([segpath fileinfo(findx{m,n}(ii)) '_seg.mat']);
            b_vec(end+1:end+length(seg_info.b)) = seg_info.b;
%             fprintf('%u\n',length(seg_info.b));
        end
        wd{m,n} = b_vec;
    end
end
wd_all = cell2mat(reshape(wd',[],1)');

% moving average
wsz = 15*fr*60;
wd_mw = zeros(size(wd_all));
T = length(wd_all);
for n = 1:T
    wd_mw(n) = mean(wd_all(max([1,n-wsz]):n))-mean(wd_all(n:min([T,n+wsz])));
end

% detect events
[~,egt] = findpeaks(wd_mw,'minpeakheight',1,'minpeakprominence',1.2);

% plot
figure; set(gcf,'color','w'); clf; hold on; 
plot([1:length(wd_all)]*time_cvs,wd_all,'color',0.7*[1 1 1],'linewidth',0.5); 
plot([1:length(wd_all)]*time_cvs,wd_mw+19,'r','linewidth',1)
h1 = scatter(egt*time_cvs,wd_mw(egt)+19,'bo','linewidth',0.5);
h2 = scatter(egt_cd*time_cvs,wd_mw(egt_cd)+19,'k*','linewidth',0.5);
xlim([1 T]*time_cvs); legend([h1 h2],{'SH','CD'});
xlabel('time (h)'); ylabel('width (pixel)')

% remove incomplete windows
findx_sort = cell2mat(reshape(findx',[],1)');
movieParamMulti = paramMulti(dpath,findx_sort);
acm = [1 zeros(1,length(movieParamMulti))];
keepIndx = false(size(wd_all));
for n = 1:length(movieParamMulti)
    acm(n+1) = acm(n)+movieParamMulti{n}.numImages;
    movieParamMulti{n}.numImages = floor(movieParamMulti{n}.numImages/timeStep)*timeStep;
    movieParamMulti{n}.frameEnd = movieParamMulti{n}.numImages-1;
    keepIndx(acm(n):acm(n)+movieParamMulti{n}.numImages-1) = 1;
end

% get egestion time points after removing incomplete windows
egt_vec = false(size(wd_all));
egt_vec(egt) = 1;
egt_vec = egt_vec(keepIndx);
egt_wd = unique(ceil(find(egt_vec)/timeStep));

% Chris's annotation
egt_vec_cd = false(size(wd_all));
egt_vec_cd(egt_cd) = 1;
egt_vec_cd = egt_vec_cd(keepIndx);
egt_wd_cd = unique(ceil(find(egt_vec_cd)/timeStep));

% visualize
ifrandomize = 0;
% visualizeResultMulti(egt_wd,timeStep,movieParamMulti,ifrandomize,1,'egt_detection');

%% analyze embedding result
% density
[~,densEgt] = findPointDensity(emData(egt_wd,:),sigma,numPoints,rangeVals);
[~,densEgt_cd] = findPointDensity(emData(egt_wd_cd,:),sigma,numPoints,rangeVals);

figure; set(gcf,'color','w')

% detection
subplot(2,2,1); hold on
scatter(emData(:,1),emData(:,2),10,0.7*[1 1 1],'o','filled')
scatter(emData(egt_wd,1),emData(egt_wd,2),10,'ro','filled')
xlim([xx(1) xx(end)]); ylim([xx(1) xx(end)]);
xlabel('tSNE 1'); ylabel('tSNE 2')
title('SH')
subplot(2,2,3)
plotTsneDens(xx,densEgt,im_mask,max(densEgt(:)))
% Chris
subplot(2,2,2); hold on
scatter(emData(:,1),emData(:,2),10,0.7*[1 1 1],'o','filled')
scatter(emData(egt_wd_cd,1),emData(egt_wd_cd,2),10,'ro','filled')
xlabel('tSNE 1'); ylabel('tSNE 2')
xlim([xx(1) xx(end)]); ylim([xx(1) xx(end)]);
title('CD')
subplot(2,2,4)
plotTsneDens(xx,densEgt,im_mask,max(densEgt_cd(:)))


%% day/night analysis
acm = [1 zeros(1,length(movieParamMulti))];
for n = 1:length(movieParamMulti)
    acm(n+1) = acm(n)+movieParamMulti{n}.numImages/timeStep;
end

figure;
numd = size(findx,1);
for n = 1:2
    for m = 1:numd
        subplot(2,numd,(n-1)*numd+m); hold on
        imagesc(xx,xx,2-A);
        for ii = 1:length(findx{m,n})
            jj = find(findx_sort==findx{m,n}(ii));
            scatter(emData(acm(jj):acm(jj+1)-1,1),emData(acm(jj):acm(jj+1)-1,2),...
                10,'o','filled','markeredgecolor','none','markerfacecolor',[1 0 0]);
        end
        colormap(gca,gray);
        caxis([-1 2])
        axis equal tight off xy
    end
end

%% region 242 is egestion
% use smoothing kernal of 60 and re-run runFVtsneUnsp again
% do it manually here

% extract data labels
vdata = emData;
vdata = round((vdata/maxVal*numPoints+numPoints)/2);
vdata(vdata<=0) = 1;
vdata(vdata>=numPoints) = numPoints;
segIndx = seg_im_trans(sub2ind(size(im),vdata(:,1),vdata(:,2)));

% plot new segmented regions
figure; set(gcf,'color','w')
subplot(1,2,1)
plotTsneDens(xx,im,im_mask,cmax)
subplot(1,2,2)
plotRegionLabelHighlight(xx,seg_im,im_mask,242)

% plot densitiy overlayed with segmentation boundaries
figure; set(gcf,'color','w');
tmp = densEgt;
tmp(seg_im==0) = min(densEgt(:))-(max(densEgt(:))-min(densEgt(:)))/63;
tmp(im_mask==0) = min(densEgt(:))-(max(densEgt(:))-min(densEgt(:)))/63;
imagesc(xx,xx,tmp);
colormap([[1 1 1];jet(63)]);
pos = get(gca,'position');
shading flat; axis equal tight xy; colorbar
caxis([min(tmp(:)) max(densEgt(:))])
set(gca,'position',pos)


