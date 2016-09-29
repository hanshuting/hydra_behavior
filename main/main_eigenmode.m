% MAIN ANALYSIS SCRIPT FOR EIGENMODE METHOD

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
param.egmpath = sprintf('%s/egm/%s/',param.pbase,param.datastr); % eigenmode
param.egmsvmpath = sprintf('%s/egmsvm/%s/',param.pbase,param.datastr);
param.annopath = sprintf('%s/annotations/',param.dpathbase);
param.parampath = sprintf('%s/param/',param.pbase);

% segmentation/registration parameters - set the same as BOW method
param.seg.skipStep = 1;
param.seg.outputsz = [150,150];
param.seg.ifscale = 1;

param.timeStep = 25;
param.annotype = 5;

% pca parameters
param.pca.percTrain = 1;
param.pca.ci = 0.9; % threshold of explained variance

% svm parameters
param.egmsvm.src = '/home/sh3276/software/libsvm';
param.egmsvm.name = 'eigenmode_spec';
param.egmsvm.percTrain = 0.9;
param.egmsvm.kernel = 2; % rbf kernel
param.egmsvm.probest = 1; % true

param.wbmap = '/home/sh3276/work/results/wbmap.mat'; %'C:\Shuting\results\wbmap.mat';

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
if exist(param.egmpath,'dir')~=7
    fprintf('creating directory %s...\n',param.egmpath);
    mkdir(param.egmpath);
end
if exist(param.egmsvmpath,'dir')~=7
    fprintf('creating directory %s...\n',param.egmsvmpath);
    mkdir(param.egmsvmpath);
end
if exist(param.parampath,'dir')~=7
    fprintf('creating directory %s...\n',param.parampath);
    mkdir(param.parampath);
end

% save parameters to file
dispStructNested(param,[],[param.parampath 'egm_param_' param.datastr '.txt']);

%% get registered and scaled images
im_train = [];
for n = 1:length(param.trainIndx)
    
    movieParam = paramAll(param.dpath,param.trainIndx(n));
    fprintf('collecting data from %s...\n',movieParam.fileName);
    load(sprintf('%s%s_seg.mat',param.segpath,movieParam.fileName));
    
    % take a subset for training pca transformation matrix
    num_frame = movieParam.numImages;
    out_dims = param.seg.outputsz(1)*param.seg.outputsz(2);
    subindx = randperm(num_frame,round(num_frame*param.pca.percTrain));
    im_mat = zeros(length(subindx),out_dims);
    
    % registration
    frscale = param.seg.outputsz(1)/3/nanmean(a);
    for j = 1:length(subindx)
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],j));
        if isnan(theta(j))
            im_mat(j,:) = NaN(1,out_dims);
        else
            im = imrotate(imtranslate(im,[movieParam.imageSize(1)/2-centroid(j,1)...
                movieParam.imageSize(2)/2-centroid(j,2)]),90-theta(j),'crop');
            bw = imrotate(imtranslate(segAll(:,:,j),[movieParam.imageSize(1)/2-centroid(j,1)...
                movieParam.imageSize(2)/2-centroid(j,2)]),90-theta(j),'crop');
            im = mat2gray(im.*double(bw~=0));
            im = scaleImage(im,param.seg.outputsz,frscale);
            im_mat(j,:) = reshape(im,1,[]);
        end
    end
    
    im_mat = im_mat(sum(isnan(im_mat),2)~=out_dims,:);
    im_train(end+1:end+size(im_mat,1),:) = im_mat;
    
end

clear a b bw centroid frscale im im_mat segAll segmat theta

%% pca
fprintf('pca...\n');
[coeff,score,latent,tsquared,explained,mu] = pca(im_train);

% plot explained variance curve
expcum = cumsum(explained);
figure;plot(expcum);
xlabel('#PC');ylabel('Variance explained')
saveas(gcf,[param.egmpath 'pca_var.fig']);

% get eigenmodes
num_mode = find(expcum>param.pca.ci*100,1);

% plot eigenmodes
cmax = 0.8*max(max(coeff(:,1:num_mode)));
cmin = 0.8*min(min(coeff(:,1:num_mode)));
N = ceil(sqrt(num_mode));
M = ceil(num_mode/N);
figure;set(gcf,'color','w')
for n = 1:num_mode
    h = subplottight(M,N,n);
    imagesc(reshape(coeff(:,n),param.seg.outputsz));
    colormap(gray);caxis([cmin cmax]);
    text(10,10,num2str(n),'color','w');
    axis equal off tight
end
saveas(gcf,[param.egmpath 'egm.fig']);

save([param.egmpath 'pcaCoeff.mat'],'coeff','latent','explained','mu',...
    'score','tsquared','num_mode','-v7.3');

%% generate pc representation on complete training data
load([param.egmpath 'pcaCoeff.mat']);

pcSpec = [];
for n = 1:length(param.trainIndx)
    
    movieParam = paramAll(param.dpath,param.trainIndx(n));
    fprintf('collecting data from %s...\n',movieParam.fileName);
    regparam = load(sprintf('%s%s_seg.mat',param.segpath,movieParam.fileName));

    pc_mat = egmPCSpec(movieParam,coeff(:,1:num_mode),latent(1:num_mode),...
        regparam,param.seg.outputsz,param.timeStep);
    pcSpec(end+1:end+size(pc_mat,1),:) = pc_mat;
    
end

save([param.egmpath 'eigenmode_spec.mat'],'pcSpec','-v7.3');

%% pc representation with new sample
for n = 1:length(param.testIndx)
    
    movieParam = paramAll(param.dpath,param.testIndx(n));
    fprintf('collecting data from %s...\n',movieParam.fileName);
    regparam = load(sprintf('%s%s_seg.mat',param.segpath,movieParam.fileName));
    pcSpec = egmPCSpec(movieParam,coeff(:,1:num_mode),latent(1:num_mode),...
        regparam,param.seg.outputsz,param.timeStep);

    save([param.egmpath 'eigenmode_spec_' movieParam.fileName '.mat'],'pcSpec','-v7.3');
    
end

clear regparam

%% SVM
% load annotation
movieParamMulti = paramMulti(param.dpath,param.trainIndx);
for n = 1:length(param.trainIndx)
    numT = floor(movieParamMulti{n}.numImages/param.timeStep);
    movieParamMulti{n}.numImages = numT*param.timeStep;
end
label = annoMulti(movieParamMulti,param.annopath,param.annotype,param.timeStep);

% write training and test data
savename = param.egmsvm.name;
load([param.egmpath 'eigenmode_spec.mat']);
keepIndx = (label~=0) & (sum(isnan(pcSpec),2)==0);
wei_str = mkLibSVMsample(pcSpec(keepIndx,:),param.egmsvm.percTrain,...
    label(keepIndx),savename,param.egmsvmpath);

% new sample
for n = 1:length(param.testIndx)
    movieParam = paramAll(param.dpath,param.testIndx(n));
    load([param.egmpath 'eigenmode_spec_' movieParam.fileName '.mat']);
    annoAll = annoMulti({movieParam},param.annopath,param.annotype,param.timeStep);
    keepIndx = (annoAll~=0) & (sum(isnan(pcSpec),2)==0);
    gnLibsvmFile(annoAll(keepIndx),pcSpec(keepIndx,:),[param.egmsvmpath ...
        savename '_' movieParam.fileName '.txt']);
end

% write bash script
writeSVMscript(param.egmsvm,wei_str,param.egmsvmpath,savename);

% train SVM
try 
    status = system(sprintf('bash %srunSVM.sh',param.egmsvmpath));
catch ME
    error('Error running libSVM');
end

% classify new samples
testnames = '';
for n = 1:length(param.testIndx)
    testnames = [testnames '"' fileinfo(param.testIndx(n)) '" '];
end
testnames = testnames(1:end-1);
writeSVMTestScript(param.egmsvm.src,param.egmsvmpath,param.egmsvmpath,savename,testnames);
try 
    status = system(sprintf('bash %ssvmClassifyIndv.sh',param.egmsvmpath));
catch ME
    error('Error running svm classification');
end

% get prediction results
anno = struct();
load([param.egmsvmpath 'eigenmode_spec_svm_data.mat']);
anno.train = label(indxTrain);
anno.test = label(indxTest);
for n = 1:length(param.testIndx)
    movieParam = paramAll(param.dpath,param.testIndx(n));
    load([param.egmpath 'eigenmode_spec_' movieParam.fileName '.mat']);
    annoAll = annoMulti({movieParam},param.annopath,param.annotype,param.timeStep);
    keepIndx = (annoAll~=0) & (sum(isnan(pcSpec),2)==0);
    anno.new{n} = annoAll(keepIndx);
end

pred = struct();
pred_score = struct();
[pred.train,pred_score.train] = saveSVMpred(param.egmsvmpath,['eigenmode_spec_train']);
[pred.test,pred_score.test] = saveSVMpred(param.egmsvmpath,['eigenmode_spec_test']);
for n = 1:length(param.testIndx)
    [pred.new{n},pred_score.new{n}] = saveSVMpred(param.egmsvmpath,...
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

save([param.egmsvmpath 'annotype' num2str(param.annotype) '_mat_results.mat'],...
    'pred','svm_stats','pred_score','anno','-v7.3');
save([param.egmsvmpath 'annotype' num2str(param.annotype) '_stats.mat'],...
    'svm_stats','cmat','auc','-v7.3');
