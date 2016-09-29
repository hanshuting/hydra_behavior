% MAIN ANALYSIS SCRIPT FOR SIMPLE FEATURE ANALYSIS

% reset random generator
rng(1000);

%% set path
addpath(genpath('/home/sh3276/work/code/hydra_behavior'));

%% setup parameters
param = struct();

% file information
param.fileIndx = [1:5,7:11,13:28,30:34];
param.trainIndx = [1:5,7:11,13:24,26:28,30:32];
param.testIndx = [25,33,34];

param.datastr = '20160906';

param.dpathbase = '/home/sh3276/work/data';
param.pbase = '/home/sh3276/work/results';
param.dpath = sprintf('%s/bkg_subtracted/',param.dpathbase);
param.segpath = sprintf('%s/seg/%s/',param.pbase,param.datastr);
param.sfpath = sprintf('%s/sf/%s/',param.pbase,param.datastr); % eigenmode
param.sfsvmpath = sprintf('%s/sfsvm/%s/',param.pbase,param.datastr);
param.annopath = sprintf('%s/annotations/',param.dpathbase);
param.parampath = sprintf('%s/param/',param.pbase);

% segmentation/registration parameters - set the same as BOW method
param.seg.skipStep = 1;
param.seg.outputsz = [150,150];
param.seg.ifscale = 1;

param.timeStep = 25;
param.annotype = 5;

% svm parameters
param.sfsvm.src = '/home/sh3276/software/libsvm';
param.sfsvm.name = 'smpfeat';
param.sfsvm.percTrain = 0.9;
param.sfsvm.kernel = 2; % rbf kernel
param.sfsvm.probest = 1; % true

%% check if all directories exist
if exist(param.dpath,'dir')~=7
    error('Incorrect data path')
end
if exist(param.annopath,'dir')~=7
    error('Incorrect annotation path')
end
if exist(param.segpath,'dir')~=7
    error('Incorrect segmentation data path')
end
if exist(param.sfpath,'dir')~=7
    fprintf('creating directory %s...\n',param.sfpath);
    mkdir(param.sfpath);
end
if exist(param.sfsvmpath,'dir')~=7
    fprintf('creating directory %s...\n',param.sfsvmpath);
    mkdir(param.sfsvmpath);
end
if exist(param.parampath,'dir')~=7
    fprintf('creating directory %s...\n',param.parampath);
    mkdir(param.parampath);
end

% save parameters to file
dispStructNested(param,[],[param.parampath 'smpfeat_param_' param.datastr '.txt']);

%% extract features from training data
rab_all = [];
rregion_all = [];
solidity_all = [];
theta_all = [];
for n = 1:length(param.trainIndx)
    
    movieParam = paramAll(param.dpath,param.trainIndx(n));
    fprintf('collecting data from %s...\n',movieParam.fileName);
    regparam = load(sprintf('%s%s_seg.mat',param.segpath,movieParam.fileName));
    numT = floor(movieParam.numImages/param.timeStep);
       
    % extract features
    [rab,rregion,solidity] = extractRegionFeatures(regparam);
    rab_all(end+1:end+numT,:) = reshape(rab(1:numT*param.timeStep),[],param.timeStep)/max(rab);
    rregion_all(end+1:end+numT,:) = reshape(rregion(1:numT*param.timeStep,:)',param.timeStep*3,[])';
    solidity_all(end+1:end+numT,:) = reshape(solidity(1:numT*param.timeStep),[],param.timeStep);
    theta_all(end+1:end+numT,:) = reshape(regparam.theta(1:numT*param.timeStep),[],param.timeStep);
    
end

sfeat = [rab_all,rregion_all,solidity_all,(theta_all+90)/180];

save([param.sfpath param.sfsvm.name '.mat'],'sfeat','-v7.3');
clear regparam

%% new sample
for n = 1:length(param.testIndx)
    
    movieParam = paramAll(param.dpath,param.testIndx(n));
    fprintf('collecting data from %s...\n',movieParam.fileName);
    regparam = load(sprintf('%s%s_seg.mat',param.segpath,movieParam.fileName));
    numT = floor(movieParam.numImages/param.timeStep);
    [rab,rregion,solidity] = extractRegionFeatures(regparam);
    rab = reshape(rab(1:numT*param.timeStep),[],param.timeStep)/max(rab);
    rregion = reshape(rregion(1:numT*param.timeStep,:)',param.timeStep*3,[])';
    solidity = reshape(solidity(1:numT*param.timeStep),[],param.timeStep);
    theta = reshape(regparam.theta(1:numT*param.timeStep),[],param.timeStep);
    
    sfeat = [rab,rregion,solidity,theta];

    save([param.sfpath param.sfsvm.name '_' movieParam.fileName '.mat'],'sfeat','-v7.3');
    
end

clear regparam

%% SVM
anno = struct();

% load annotation
movieParamMulti = paramMulti(param.dpath,param.trainIndx);
for n = 1:length(param.trainIndx)
    numT = floor(movieParamMulti{n}.numImages/param.timeStep);
    movieParamMulti{n}.numImages = numT*param.timeStep;
end
label = annoMulti(movieParamMulti,param.annopath,param.annotype,param.timeStep);

% write training and test data
savename = param.sfsvm.name;
load([param.sfpath savename '.mat']);
keepIndx = (label~=0) & (sum(isnan(sfeat),2)==0);
[wei_str,indxTrain,indxTest] = mkLibSVMsample(sfeat(keepIndx,:),param.sfsvm.percTrain,...
    label(keepIndx),savename,param.sfsvmpath);
label = label(keepIndx);
anno.train = label(indxTrain);
anno.test = label(indxTest);

% new sample
for n = 1:length(param.testIndx)
    movieParam = paramAll(param.dpath,param.testIndx(n));
    load([param.sfpath savename '_' movieParam.fileName '.mat']);
    annoAll = annoMulti({movieParam},param.annopath,param.annotype,param.timeStep);
    keepIndx = (annoAll~=0) & (sum(isnan(sfeat),2)==0);
    gnLibsvmFile(annoAll(keepIndx),sfeat(keepIndx,:),[param.sfsvmpath ...
        savename '_' movieParam.fileName '.txt']);
    anno.new{n} = annoAll(keepIndx);
end

% write bash script
writeSVMscript(param.sfsvm,wei_str,param.sfsvmpath,savename);

% train SVM
try 
    status = system(sprintf('bash %srunSVM.sh',param.sfsvmpath));
catch ME
    error('Error running libSVM');
end

% classify new samples
testnames = '';
for n = 1:length(param.testIndx)
    testnames = [testnames '"' fileinfo(param.testIndx(n)) '" '];
end
testnames = testnames(1:end-1);
writeSVMTestScript(param.sfsvm.src,param.sfsvmpath,param.sfsvmpath,savename,testnames);
try 
    status = system(sprintf('bash %ssvmClassifyIndv.sh',param.sfsvmpath));
catch ME
    error('Error running svm classification');
end

%% get prediction results
pred = struct();
pred_score = struct();
[pred.train,pred_score.train] = saveSVMpred(param.sfsvmpath,[savename '_train']);
[pred.test,pred_score.test] = saveSVMpred(param.sfsvmpath,[savename '_test']);
for n = 1:length(param.testIndx)
    [pred.new{n},pred_score.new{n}] = saveSVMpred(param.sfsvmpath,...
        [savename '_' fileinfo(param.testIndx(n))]);
end

% analyze result
numClass = max(anno.train);
svm_stats = struct();
[svm_stats.acr_all.train,svm_stats.prc.train,svm_stats.rec.train,...
    svm_stats.acr.train,cmat.train] = precisionrecall(pred.train,anno.train,numClass);
[svm_stats.acr_all.test,svm_stats.prc.test,svm_stats.rec.test,...
    svm_stats.acr.test,cmat.test] = precisionrecall(pred.test,anno.test,numClass);
for n = 1:length(param.testIndx)
    [svm_stats.acr_all.new(n),svm_stats.prc.new{n},svm_stats.rec.new{n},...
        svm_stats.acr.new{n},cmat.new{n}] = precisionrecall(pred.new{n},anno.new{n},numClass);
end

[svm_stats.acr_all.new_all,svm_stats.prc.new_all,svm_stats.rec.new_all,...
    svm_stats.acr.new_all,cmat.new_all] = precisionrecall...
    (cell2mat(pred.new'),cell2mat(anno.new'),numClass);

save([param.sfsvmpath 'annotype' num2str(param.annotype) '_mat_results.mat'],...
    'pred','svm_stats','pred_score','anno','-v7.3');
save([param.sfsvmpath 'annotype' num2str(param.annotype) '_stats.mat'],...
    'svm_stats','cmat','-v7.3');

%% plot SVM results
% plot confusion matrix
load(param.wbmap);
num_plts = max([length(param.testIndx),3]);
figure;set(gcf,'color','w')
subplot(2,num_plts,1)
plotcmat(cmat.train,wbmap);title('Train');colorbar off
% gcapos = get(gca,'position');colorbar off; set(gca,'position',gcapos);
subplot(2,num_plts,2)
plotcmat(cmat.test,wbmap);title('Test');colorbar off
% gcapos = get(gca,'position');colorbar off; set(gca,'position',gcapos);
subplot(2,num_plts,3)
plotcmat(cmat.new_all,wbmap);title('New');colorbar off
for n = 1:length(param.testIndx)
    subplot(2,num_plts,length(param.testIndx)+n)
    plotcmat(cmat.new{n},wbmap);
    title(['New #' num2str(n)]);colorbar off
%     gcapos = get(gca,'position');colorbar off;set(gca,'position',gcapos)
end
set(findall(gcf,'-property','FontSize'),'FontSize',9)

disp(svm_stats.acr_all);
fprintf('Precision:\n');
disp(table(svm_stats.prc.train,svm_stats.prc.test,svm_stats.prc.new_all,...
    'variablenames',{'train','test','new'}));
fprintf('Recall:\n');
disp(table(svm_stats.rec.train,svm_stats.rec.test,svm_stats.rec.new_all,...
    'variablenames',{'train','test','new'}));
fprintf('Accuracy:\n');
disp(table(svm_stats.acr.train,svm_stats.acr.test,svm_stats.acr.new_all,...
    'variablenames',{'train','test','new'}));

% ROC curve
numClass = max(anno.train);
figure;set(gcf,'color','w')
subplot(1,3,1)
auc.train = plotROCmultic(anno.train,pred_score.train,numClass);
legend('off')
subplot(1,3,2)
auc.test = plotROCmultic(anno.test,pred_score.test,numClass);
legend('off')
subplot(1,3,3)
auc.new = plotROCmultic(cell2mat(anno.new'),cell2mat(pred_score.new'),numClass);




