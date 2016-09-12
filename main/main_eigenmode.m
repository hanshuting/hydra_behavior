% MAIN ANALYSIS SCRIPT FOR EIGENMODE METHOD

% reset random generator
rng(1000);

%% set path
addpath(genpath('/home/sh3276/work/code/hydra_behavior'));
addpath(genpath('/home/sh3276/software/MotionMapper/'));

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
param.seg.outputsz = [300,300];
param.seg.ifscale = 1;

param.timeStep = 25;
param.annotype = 5;

% pca parameters
param.pca.percTrain = 0.1;
param.pca.ci = 0.7; % threshold of explained variance

% svm parameters
param.egmsvm.percTrain = 0.9;

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
    subindx = randperm(num_frame,round(num_frame*param.pca.percTrain));
    im_mat = zeros(length(subindx),param.seg.outputsz(1)*param.seg.outputsz(2));
    
    % registration
    frscale = param.seg.outputsz(1)/3/nanmean(a);
    for j = 1:subindx
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],j));
        im = imrotate(imtranslate(im,[movieParam.imageSize(1)/2-centroid(j,1)...
            movieParam.imageSize(2)/2-centroid(j,2)]),90-theta(j),'crop');
        bw = imrotate(imtranslate(segAll(:,:,j),[movieParam.imageSize(1)/2-centroid(j,1)...
            movieParam.imageSize(2)/2-centroid(j,2)]),90-theta(j),'crop');
        im = mat2gray(im.*double(bw~=0));
        im = scaleImage(im,param.seg.outputsz,frscale);
        im_mat(j,:) = reshape(im,1,[]);
    end
    
    im_train(end+1:end+size(im_mat,1),:) = im_mat;
    
end

%% pca
fprintf('pca...\n');
[coeff,score,latent,tsquared,explained,mu] = pca(im_train);

% plot explained variance curve
expcum = cumsum(explained);
figure;plot(expcum);

% get eigenmodes
num_mode = find(expcum>param.pca.ci,1);

% plot eigenmodes
N = ceil(sqrt(num_mode));
M = ceil(num_mode/N);
figure;set(gcf,'color','w')
for n = 1:num_mode
    h = subplot(M,N,n);
    imagesc(reshape(coeff(:,n),outputsz));
    colormap(gray);title(num2str(n));
    axis equal off tight
end

save([param.egmpath 'pcaCoeff.mat'],'coeff','num_mode','-v7.3');

%% generate pc representation
pcSpec = [];
for n = 1:length(param.testIndx)
    
    movieParam = paramAll(param.dpath,param.testIndx(n));
    fprintf('collecting data from %s...\n',movieParam.fileName);
    load(sprintf('%s%s_scaled_reg_seg_step_%u.mat',param.segpath,...
        movieParam.fileName,param.timeStep));

    pc_mat = zeros(movieParam.numImages,num_mode);
    
    % take entire time windows
    for j = 1:size(bwReg,3)

        % registration
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],j));
        im = imrotate(imtranslate(im,[movieParam.imageSize(1)/2-hydraCent(j,1)...
            movieParam.imageSize(2)/2-hydraCent(j,2)]),90-hydraOri(j),'crop');
        im = im.*bwReg(:,:,j);
        im = mat2gray(im);
        im = scaleImage(im,outputsz,hydrasz/hydraLength(j));
        
        % pc representation
%         pc_mat(j,:) = reshape(im_final,1,[])*coeff(:,1:num_mode);
        pc_mat(j,:) = reshape(im_final,1,[])*coeff(:,1:num_mode)./sqrt(latent(1:num_mode)');

    end
    
    pcSpec(end+1:end+size(pc_mat,1),:) = pc_mat;
    
end

save([param.egmpath 'eigenmode_spec.mat'],'pcSpec','-v7.3');

%% pc representation with new sample
for n = 1:length(param.trainIndx)
    
    movieParam = paramAll(param.dpath,param.trainIndx(n));
    fprintf('collecting data from %s...\n',movieParam.fileName);
    load(sprintf('%s%s_scaled_reg_seg_step_%u.mat',param.segpath,...
        movieParam.fileName,param.timeStep));

    pcSpec = zeros(movieParam.numImages,num_mode);
    
    % take entire time windows
    for j = 1:size(bwReg,3)

        % registration
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],j));
        im = imrotate(imtranslate(im,[movieParam.imageSize(1)/2-hydraCent(j,1)...
            movieParam.imageSize(2)/2-hydraCent(j,2)]),90-hydraOri(j),'crop');
        im = im.*bwReg(:,:,j);
        im = mat2gray(im);
        im = scaleImage(im,outputsz,hydrasz/hydraLength(j));
        
        % pc representation
%         pc_mat(j,:) = reshape(im_final,1,[])*coeff(:,1:num_mode);
        pcSpec(j,:) = reshape(im_final,1,[])*coeff(:,1:num_mode)./sqrt(latent(1:num_mode)');

    end
    save([param.egmpath 'eigenmode_spec_' movieParam.fileName.mat'],'pcSpec','-v7.3');
    
end

%% SVM
% load annotation
movieParamMulti = paramMulti(param.dpath,param.fileIndx);
label = annoMulti(movieParamMulti,param.annopath,param.annotype,param.timeStep);

% write training and test data
savename = 'eigenmode_spec';
load([param.egmpath 'eigenmode_spec.mat']);
wei_str = mkLibSVMsample(pcSpec,param.egmsvm.percTrain,label,savename,param.egmsvmpath);

% new sample
for n = 1:length(paramm.testIndx)
    movieParam = paramAll(param.dpath,param.testIndx(n));
    load([param.egmpath 'eigenmode_spec_' movieParam.fileName '.mat']);
    annoAll = annoMulti({movieParam},param.annopath,param.annotype,param.timeStep);
    keepIndx = annoAll~=0;
    gnLibsvmFile(annoAll(keepIndx),pcSpec(keepIndx,:),[param.egmsvmpath ...
        savename '_' movieParam.fileName '.txt']);
end

% write bash script
writeSVMscript(param.egmsvm,wei_str,param.egmpath,param.egmsvmpath,savename);

% train SVM
try 
    status = system(sprintf('%srunSVM.sh',param.svmpath));
catch ME
    error('Error running libSVM');
end

% classify new samples
testnames = '';
for n = 1:length(param.testIndx)
    testnames = strcat(testnames,sprintf('"%s" ',fileinfo(param.testIndx(n))));
end
writeSVMTestScript(param.egmsvmpath,param.egmpath,savename,testnames);
try 
    status = system(sprintf('%ssvmClassifyIndv.sh',param.egmsvmpath));
catch ME
    error('Error running svm classification');
end

% get prediction results
pred = struct();
pred_score = struct();
[pred.train,pred_score.train] = saveSVMpred(param.fvpath,[svmname '_train']);
[pred,test,pred_score.test] = saveSVMpred(param.fvpath,[svmname '_test']);
for n = 1:length(param.testIndx)
    [pred.new{n},pred_score.new{n}] = saveSVMpred(param.egmpath,...
        [savename '_' fileinfo(param.testIndx(n))]);
end

% analyze result
svm_stats = struct();
load([param.egmsvmpath savename '_svm_data.mat']);
[svm_stats.prc(1),svm_stats.rec(1),svm_stats.acr(1),cmat.train] =...
    precisionrecall(pred.train,label(indxTrain));
[svm_stats.prc(2),svm_stats.rec(2),svm_stats.acr(2),cmat.test] =...
    precisionrecall(pred.test,label(indxTest));

