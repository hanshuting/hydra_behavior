% MAIN ANALYSIS SCRIPT FOR VALIDATING TRAINING SIZE

% reset random generator
rng(1000);

%% set path
addpath(genpath('/home/sh3276/work/code/hydra_behavior'));
addpath(genpath('/home/sh3276/software/inria_fisher_v1/yael_v371/matlab'));
addpath(genpath('/home/sh3276/work/code/other_sources/'))

%% setup parameters
srcstr = '20161019';
parampath = '/home/sh3276/work/results/param/';
load([parampath 'expt_param_' srcstr '.mat']);

% file information
param.trainIndxAll = param.trainIndx;
param.trainSize = [10,20,30,40];
param.numRep = 10;

param.datastr = '20170120';
param.srcstr = srcstr;

param.dpathbase = '/home/sh3276/work/data';
param.pbase = '/home/sh3276/work/results';
param.dpath = sprintf('%s/bkg_subtracted/',param.dpathbase);
param.dtmatpath = sprintf('%s/dt/%s/mat/',param.pbase,param.srcstr);
param.fvpath = sprintf('%s/fv/%s/',param.pbase,param.datastr);
param.svmpath = sprintf('%s/svm/%s/',param.pbase,param.datastr);
param.tsnepath = sprintf('%s/tsne/%s/',param.pbase,param.datastr);
param.annopath = sprintf('%s/annotations/',param.dpathbase);
param.parampath = sprintf('%s/param/',param.pbase);

%% check if all directories exist
if exist(param.dpath,'dir')~=7
    error('Incorrect data path')
end
if exist(param.annopath,'dir')~=7
    error('Incorrect annotation path')
end
if exist(param.dtmatpath,'dir')~=7
    error('Incorrect dt mat path')
end
if exist(param.fvpath,'dir')~=7
    fprintf('creating directory %s...\n',param.fvpath);
    mkdir(param.fvpath);
end
if exist(param.svmpath,'dir')~=7
    fprintf('creating directory %s...\n',param.svmpath);
    mkdir(param.svmpath);
end
if exist(param.tsnepath,'dir')~=7
    fprintf('creating directory %s...\n',param.tsnepath);
    mkdir(param.tsnepath);
end
if exist(param.parampath,'dir')~=7
    fprintf('creating directory %s...\n',param.parampath);
    mkdir(param.parampath);
end

%% train with a subset
for R = 1:param.numRep
for N = 1:length(param.trainSize)
    
    fprintf('Training with %u samples...\n',param.trainSize(N));
    param.trainIndx = param.trainIndxAll(randperm(length(param.trainIndxAll),param.trainSize(N)));

    % save parameters to file
    dispStructNested(param,[],[param.parampath 'expt_param_' param.datastr '.txt']);
    save([param.parampath 'expt_param_' param.datastr '_train_' ...
        num2str(param.trainSize(N)) '_rep_' num2str(R) '.mat'],'param');

    %% run Fisher Vector on features
    % ---------- training FV ---------- %
    for n = 1:length(param.fv.featstr)

        fprintf([param.fv.featstr{n} '...\n']);
        fvparam = param.fv;
        fvparam.featstr = param.fv.featstr{n};
        fvparam.namestr = [param.infostr '_' fvparam.featstr];
        fvparam.lfeat = param.fv.featlen(n);
        fprintf('%s...\n',fvparam.featstr);

        % fit GMM and encode FV
        eval(sprintf(['[coeff,w,mu,sigma,%sFV,eigval,acm] = encodeSpFV2(param.trainIndx,' ...
            'param.dtmatpath,fvparam);'],fvparam.featstr));

        % save results
        save([param.fvpath param.infostr '_' fvparam.featstr 'Coeff.mat'],'coeff','eigval','-v7.3'); 
        eval(sprintf(['save([param.fvpath param.infostr ''_'' fvparam.featstr ''FV.mat''],'...
            '''%sFV'',''-v7.3'');'],fvparam.featstr));
        save([param.fvpath param.infostr '_' fvparam.featstr 'GMM.mat'],'w','mu','sigma','-v7.3');

    end

    % put together data, do pca
    FVall = [hofFV,hogFV,mbhxFV,mbhyFV]/4;
    [drFVall,coeff] = drHist(FVall,param.fv.ci);
    pcaDim = size(drFVall,2);
    save([param.fvpath param.infostr '_FVall.mat'],'FVall','acm','-v7.3');
    save([param.fvpath param.infostr '_drFVall.mat'],'drFVall','acm','-v7.3');
    save([param.fvpath param.infostr '_pcaCoeff.mat'],'coeff','pcaDim','-v7.3');

    % ---------- test FV ---------- %
    for n = 1:length(param.testIndx)

        movieParam = paramAll(param.dpath,param.testIndx(n));
        fprintf('processing sample: %s\n', movieParam.fileName);

        for ii = 1:length(param.fv.featstr)
            fvparam = param.fv;
            fvparam.gmmpath = param.fvpath;
            fvparam.featstr = param.fv.featstr{ii};
            fvparam.namestr = [param.infostr '_' fvparam.featstr];
            fvparam.lfeat = param.fv.featlen(ii);
            fprintf('%s...\n',fvparam.featstr);
            eval(sprintf('%sFV = encodeIndivSpFV2(param.testIndx(n),param.dtmatpath,fvparam);',...
                fvparam.featstr));
        end

        % put together FV, do pca
        FVall = [hofFV,hogFV,mbhxFV,mbhyFV]/4;
        muData = mean(FVall,1);
        drFVall = bsxfun(@minus,FVall,muData)*coeff;
        drFVall = drFVall(:,1:pcaDim);
        save([param.fvpath movieParam.fileName '_' param.infostr '_FVall.mat'],'FVall','-v7.3');
        save([param.fvpath movieParam.fileName '_' param.infostr '_drFVall.mat'],'drFVall','-v7.3');

    end

    %% generate SVM samples
    % training data
    sample = load([param.fvpath param.infostr '_drFVall.mat']);
    acm = sample.acm;
    sample = sample.drFVall;

    % load annotations
    movieParamMulti = paramMulti(param.dpath,param.trainIndx);
    for n = 1:length(param.trainIndx)
        movieParamMulti{n}.numImages = (acm(n+1)-acm(n))*param.timeStep;
    end
    annoAll = annoMulti(movieParamMulti,param.annopath,param.annotype,param.timeStep);

    % write data
    param.svm.name = [param.infostr '_drFVall_annoType' num2str(param.annotype)];
    wei_str = mkLibSVMsample(sample,param.svm.percTrain,annoAll,param.svm.name,param.svmpath);

    % test sample
    for n = 1:length(param.testIndx)

        movieParam = paramAll(param.dpath,param.testIndx(n));
        sample = load([param.fvpath movieParam.fileName '_' param.infostr '_drFVall.mat']);
        sample = sample.drFVall;
        annoAll = annoMulti({movieParam},param.annopath,param.annotype,param.timeStep);
        keepIndx = annoAll~=0;

        % write to libsvm format file
        gnLibsvmFile(annoAll(keepIndx),sample(keepIndx,:),[param.svmpath ...
            param.svm.name '_' movieParam.fileName '.txt']);

    end

    %% SVM
    % train SVM
    writeSVMscript(param.svm,wei_str,param.svmpath,param.svm.name);
    try 
        system(sprintf('chmod +x %srunSVM.sh',param.svmpath));
        status = system(sprintf('bash %srunSVM.sh',param.svmpath));
    catch ME
        error('Error running libSVM');
    end

    % predict test samples
    testnames = '';
    for n = 1:length(param.testIndx)
        testnames = [testnames sprintf('"%s" ',fileinfo(param.testIndx(n)))];
    end
    testnames = testnames(1:end-1);
    writeSVMTestScript(param.svm.src,param.svmpath,param.svmpath,param.svm.name,testnames);
    try 
        status = system(sprintf('bash %ssvmClassifyIndv.sh',param.svmpath));
    catch ME
        error('Error running svm classification');
    end

    % save prediction result to mat files
    load([param.svmpath param.svm.name '_svm_data.mat']);
    pred = struct();
    pred_score = struct();
    anno.train = label(indxTrain);
    anno.test = label(indxTest);
    [pred.train,pred_score.train,pred.train_soft] = saveSVMpred(param.svmpath,[param.svm.name '_train']);
    [pred.test,pred_score.test,pred.test_soft] = saveSVMpred(param.svmpath,[param.svm.name '_test']);
    for n = 1:length(param.testIndx)
        movieParam = paramAll(param.dpath,param.testIndx(n));
        annoAll = annoMulti({movieParam},param.annopath,param.annotype,param.timeStep);
        anno.new{n} = annoAll(annoAll~=0);
        [pred.new{n},pred_score.new{n},pred.new_soft{n}] = saveSVMpred(param.svmpath,...
            [param.svm.name '_' fileinfo(param.testIndx(n))]);
    end

    save([param.svmpath 'annotype' num2str(param.annotype) '_mat_results_train_' ...
        num2str(param.trainSize(N)) '_rep_' num2str(R) '.mat'],'pred','pred_score','anno','-v7.3');

    %% SVM analysis
    % confusion matrix and stats
    load([param.svmpath 'annotype' num2str(param.annotype) '_mat_results_train_' ...
            num2str(param.trainSize(N)) '_rep_' num2str(R) '.mat']);

    numClass = max(anno.train);
    svm_stats = struct();
    cmat = struct();

    [svm_stats.acr_all.train,svm_stats.prc.train,svm_stats.rec.train,...
        svm_stats.acr.train,cmat.train] = precisionrecall(pred.train,anno.train,numClass);
    [svm_stats.acr_all.test,svm_stats.prc.test,svm_stats.rec.test,...
        svm_stats.acr.test,cmat.test] = precisionrecall(pred.test,anno.test,numClass);
    for n = 1:length(param.testIndx)
        movieParam = paramAll(param.dpath,param.testIndx(n));
        annoAll = annoMulti({movieParam},param.annopath,param.annotype,param.timeStep);
        anno.new{n} = annoAll(annoAll~=0);
        [svm_stats.acr_all.new(n),svm_stats.prc.new{n},svm_stats.rec.new{n},...
            svm_stats.acr.new{n},cmat.new{n}] = precisionrecall(pred.new{n},anno.new{n},numClass);
    end

    [svm_stats.acr_all.new_all,svm_stats.prc.new_all,svm_stats.rec.new_all,...
        svm_stats.acr.new_all,cmat.new_all] = precisionrecall...
        (cell2mat(pred.new'),cell2mat(anno.new'),numClass);

    % soft
    % [svm_stats.acr_all.train_soft,svm_stats.prc.train_soft,svm_stats.rec.train_soft,...
    %     svm_stats.acr.train_soft,cmat.train_soft] = precisionrecall(pred.train_soft,...
    %     anno.train_soft,numClass);
    % [svm_stats.acr_all.test,svm_stats.prc.test,svm_stats.rec.test,...
    %     svm_stats.acr.test,cmat.test] = precisionrecall(pred.test,anno.test,numClass);
    % for n = 1:length(param.testIndx)
    %     movieParam = paramAll(param.dpath,param.testIndx(n));
    %     annoAll = annoMulti({movieParam},param.annopath,param.annotype,param.timeStep);
    %     anno.new{n} = annoAll(annoAll~=0);
    %     [svm_stats.acr_all.new(n),svm_stats.prc.new{n},svm_stats.rec.new{n},...
    %         svm_stats.acr.new{n},cmat.new{n}] = precisionrecall(pred.new{n},anno.new{n},numClass);
    % end

    svm_stats.acr_all.train_soft = sum(anno.train==pred.train_soft(:,1)|...
        anno.train==pred.train_soft(:,2)|anno.train==pred.train_soft(:,3))/length(anno.train);
    svm_stats.acr_all.test_soft = sum(anno.test==pred.test_soft(:,1)|...
        anno.test==pred.test_soft(:,2)|anno.test==pred.test_soft(:,3))/length(anno.test);
    for n = 1:length(param.testIndx)
        svm_stats.acr_all.new_soft(n) = sum(anno.new{n}==pred.new_soft{n}(:,1)|...
            anno.new{n}==pred.new_soft{n}(:,2)|anno.new{n}==pred.new_soft{n}(:,3))/length(anno.new{n});
    end
    sp = cell2mat(pred.new_soft');
    an = cell2mat(anno.new');
    svm_stats.acr_all.new_all_soft = sum(an==sp(:,1)|an==sp(:,2)|an==sp(:,3))/length(an);


    % save results
    save([param.svmpath 'annotype' num2str(param.annotype) '_stats_train_' ...
            num2str(param.trainSize(N)) '_rep_' num2str(R) '.mat'],'svm_stats','cmat','-v7.3');


end
end

%% analyze results
full_result = load(sprintf('%s/svm/%s/annotype%u_stats.mat',param.pbase,...
    param.srcstr,param.annotype));
acr_all = struct;
acr = struct;
num_md = length(param.trainSize);
for N = 1:num_md
    for R = 1:param.numRep
        ld = load([param.svmpath 'annotype' num2str(param.annotype) '_stats_train_' ...
            num2str(param.trainSize(N)) '_rep_' num2str(R) '.mat']);
        acr_all.train(N,R) = ld.svm_stats.acr_all.train;
        acr_all.test(N,R) = ld.svm_stats.acr_all.test;
        acr_all.new(N,R) = ld.svm_stats.acr_all.new_all;
        acr.train(N,R,:) = ld.svm_stats.acr.train;
        acr.test(N,R,:) = ld.svm_stats.acr.test;
        acr.new(N,R,:) = ld.svm_stats.acr.new_all;
    end
end
acr_all.train(end+1,:) = repmat(full_result.svm_stats.acr_all.train,1,R);
acr_all.test(end+1,:) = repmat(full_result.svm_stats.acr_all.test,1,R);
acr_all.new(end+1,:) = repmat(full_result.svm_stats.acr_all.new_all,1,R);
acr.train(N+1,:,:) = repmat(full_result.svm_stats.acr.train,1,R,1);
acr.test(N+1,:,:) = repmat(full_result.svm_stats.acr.test,1,R,1);
acr.new(N+1,:,:) = repmat(full_result.svm_stats.acr.new_all,1,R,1);

% plot overall accuracy
figure;
subplot(1,3,1)
plot(1:num_md+1,acr_all.train);
subplot(1,3,2)
plot(1:num_md+1,acr_all.test);
subplot(1,3,3)
plot(1:num_md+1,acr_all.new);

% plot accuracy of individual classes
cc = jet(num_md+1);
cc = max(cc-0.3,0);
figure;
for m = 1:numClass
    subplot(3,numClass,m);
    plot(1:num_md+1,acr.train(:,m))
    subplot(3,numClass,m+numClass);
    plot(1:num_md+1,acr.test(:,m))
    subplot(3,numClass,m+numClass*2);
    plot(1:num_md+1,acr.new(:,m))
end



