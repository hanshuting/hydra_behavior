
fileIndx = 1201:1229;
testIndx = [1201,1204,1219];
annopath = 'E:\Data\flat_prep\annotations\';
wbmap = 'C:\Shuting\Projects\hydra behavior\results\wbmap.mat';
fpath = 'C:\Shuting\Projects\hydra behavior\results\flat_prep\svm\';
annotype = 5;
timeStep = 25;
dpath = 'E:\Data\flat_prep\';

load(wbmap);

%% load results
% load all results
num_file = length(fileIndx);
pred_all = cell(num_file,1);
pred_all_soft = cell(num_file,1);
score_all = cell(num_file,1);
for n = 1:num_file
    fname = fileinfo(fileIndx(n));
    load([fpath fname '_annotype' num2str(annotype) '_pred_results.mat']);
    pred_all{n} = pred;
    pred_all_soft{n} = pred_soft;
    score_all{n} = pred_score;
end

% load test results and annotations
num_test = length(testIndx);
pred_test = cell(num_test,1);
pred_test_soft = cell(num_test,1);
score_test = cell(num_test,1);
for n = 1:num_test
    fname = fileinfo(testIndx(n));
    load([fpath fname '_annotype' num2str(annotype) '_pred_results.mat']);
    pred_test{n} = pred;
    pred_test_soft{n} = pred_soft;
    score_test{n} = pred_score;
end

%% compare with annotation
[~,numClass] = annoInfo(annotype,1);
svm_stats = struct();
cmat = struct();
anno_test = cell(num_test,1);

for n = 1:num_test
    movieParam = paramAll('',testIndx(n));
    annoAll = annoMulti({movieParam},annopath,annotype,timeStep);
    anno_test{n} = annoAll(annoAll~=0);
    [svm_stats.acr_all.new(n),svm_stats.prc.new{n},svm_stats.rec.new{n},...
        svm_stats.acr.new{n},cmat.new{n}] = precisionrecall(pred_test{n},anno_test{n},numClass);
end

[svm_stats.acr_all.new_all,svm_stats.prc.new_all,svm_stats.rec.new_all,...
    svm_stats.acr.new_all,cmat.new_all] = precisionrecall...
    (cell2mat(pred_test),cell2mat(anno_test),numClass);

% soft predictions
for n = 1:num_test
    svm_stats.acr_all.new_soft(n) = sum(anno_test{n}==pred_test_soft{n}(:,1)|...
        anno_test{n}==pred_test_soft{n}(:,2)|anno_test{n}==pred_test_soft{n}(:,3))/length(anno_test{n});
end
sp = cell2mat(pred_test_soft);
an = cell2mat(anno_test);
svm_stats.acr_all.new_all_soft = sum(an==sp(:,1)|an==sp(:,2)|an==sp(:,3))/length(an);

%% plot
% plot confusion matrix
figure;set(gcf,'color','w','position',[2064 559 930 257])
subplot(1,num_test+1,1)
plotcmat(cmat.new_all,wbmap);title('all');colorbar off
for n = 1:num_test
    subplot(1,num_test+1,n+1)
    plotcmat(cmat.new{n},wbmap);
    title(['New #' num2str(n)]);colorbar off
%     gcapos = get(gca,'position');colorbar off;set(gca,'position',gcapos)
end
set(findall(gcf,'-property','FontSize'),'FontSize',9)

% ROC curve
figure;set(gcf,'color','w','position',[2066 210 289 261])
auc.new = plotROCmultic(cell2mat(anno_test),cell2mat(score_test),numClass);

%% visualize some examples here
% movieParamMulti = paramMulti(dpath,testIndx);

ifRandomize = 1;
ifsave = 1;
for m = 1:num_test
    for n = 1:numClass
        movieParam = paramAll(dpath,testIndx(m));
        visualizeResultMulti(find(pred_test{m}==n),timeStep,{movieParam},...
            ifRandomize,ifsave,['test' num2str(m) '_class' num2str(n)']);
    end
end
