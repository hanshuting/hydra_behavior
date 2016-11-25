% somersaulting

annotype = 5;
timeStep = 25;
spath = 'C:\Shuting\Projects\hydra behavior\results\ss_pred\';

%% from new sample
dpath = 'C:\Shuting\Projects\hydra behavior\results\svm\20161019\';
load([dpath 'annotype' num2str(annotype) '_mat_results.mat']);
sstw = 1:1925/timeStep;
sspred = pred.new_soft{2}(sstw,:);

% ethogram
figure; set(gcf,'color','w','position',[1978 789 571 161])
plotEthogram(sspred,annotype)
saveas(gcf,[spath fileinfo(fileIndx(n)) '_ss_pred_ethogram.fig']);
print(gcf,'-dpdf','-painters','-bestfit',[spath 'new_ss_pred_ethogram.pdf']);

% make sentence
sspred_word = cell(size(sspred));
for i = 1:size(sspred,1)
    for j = 1:size(sspred,2)
        if ~isnan(sspred(i,j))
            sspred_word{i,j} = annoInfo(annotype,sspred(i,j));
        end
    end
end

% print sentence
for i = 1:size(sspred,1)
    fprintf('%s',sspred_word{i,1});
    for j = 2:size(sspred,2)
        if ~isnan(sspred(i,j))
            fprintf('/%s',sspred_word{i,j});
        end
    end
    if i~=size(sspred,1)
        fprintf(' -> \n');
    else
        fprintf('\n');
    end
end


% visualize
vpath = 'E:\Data\hydra_behavior\bkg_subtracted\';
movieParam = paramAll(vpath,33);
makeAnnotatedMovie(1:length(sstw),sspred,annotype,movieParam,timeStep,0.1,1);

%% from medium swap experiment
fileIndx = [502,504,506];
sstw = {1:1900/timeStep,6250/timeStep:9600/timeStep,1:4000/timeStep};
dpath = 'C:\Shuting\Projects\hydra behavior\results\medium_swap\svm\20161121\';

for n = 1:length(fileIndx)
    load([dpath fileinfo(fileIndx(n)) '_annotype' num2str(annotype) '_pred_results.mat']);
    softpred = makeSoftPred(pred_score);
    figure; set(gcf,'color','w','position',[1978 789 571 161])
    plotEthogram(softpred(sstw{n},:),annotype);
    title(fileinfo(fileIndx(n)),'interpreter','none');
    saveas(gcf,[spath fileinfo(fileIndx(n)) '_ss_pred_ethogram.fig']);
    print(gcf,'-dpdf','-painters','-bestfit',[spath fileinfo(fileIndx(n))...
        '_ss_pred_ethogram.pdf']);
    
    vpath = 'E:\Projects\Summer2016\Sol_ColMedium\';
    movieParam = paramAll(vpath,fileIndx(n));
    makeAnnotatedMovie(sstw{n},softpred,annotype,movieParam,timeStep,0.1,1);

end

%% from dark/light experiment
fileIndx = [304,328];
sstw = {5300/timeStep:8100/timeStep,2000/timeStep:4400/timeStep};
dpath = 'C:\Shuting\Projects\hydra behavior\results\dark_light\svm\20161121\';

for n = 1:length(fileIndx)
    load([dpath fileinfo(fileIndx(n)) '_annotype' num2str(annotype) '_pred_results.mat']);
    softpred = makeSoftPred(pred_score);
    figure; set(gcf,'color','w','position',[1978 789 571 161])
    plotEthogram(softpred(sstw{n},:),annotype);
    title(fileinfo(fileIndx(n)),'interpreter','none');
    saveas(gcf,[spath fileinfo(fileIndx(n)) '_ss_pred_ethogram.fig']);
    print(gcf,'-dpdf','-painters','-bestfit',[spath fileinfo(fileIndx(n))...
        '_ss_pred_ethogram.pdf']);
    
    vpath = 'E:\Data\dark_light_behaviors\';
    movieParam = paramAll(vpath,fileIndx(n));
    makeAnnotatedMovie(sstw{n},softpred,annotype,movieParam,timeStep,0.1,1);

end


