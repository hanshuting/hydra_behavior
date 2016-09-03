% script for encoding fisher vectors

addpath(genpath('/home/sh3276/work/code/'));
addpath(genpath('/home/sh3276/software/inria_fisher_v1/yael_v371/matlab'));

%% set parameters
% file parameters
%fileIndx = [1:5,7:11,13:28,30:31];
fileIndx = [1:5,7:11,13:24,26:28,30:32];
%fileIndx = 401:414;
%fileIndx = [238,239]
W = 2;
L = 15;
timeStep = 25;
s = 2;
t = 3;
N = 32;
K = 128; % number of GMM in FV
rho = 0.5; % power normalization order
ifverbose = 0;
ifcenter = 1; % center data in pca??
ci = 90;
datestr = '20160112_registered';
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];
%filepath = '/home/sh3276/work/results/dt_results_assembled/min_var0.5/';
filepath = ['/home/sh3276/work/results/dt_results_assembled/registered/'  infostr '_' datestr '/'];
savepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr '_K_' num2str(K) '_' datestr '/'];

% initialization
rng(1000);
hof_all = {};
hog_all = {};
mbhx_all = {};
mbhy_all = {};

%% -------------- HOF --------------
fprintf('HOF...\n');

% load samples
acm = zeros(length(fileIndx)+1,1);
for i = 1:length(fileIndx)

    movieParam = paramAll_galois(fileIndx(i));
    fprintf('loading sample: %s\n', movieParam.fileName);

    filename = [movieParam.fileName '_' infostr '_'];

    load([filepath filename 'hof.mat']);
    hofAll = cellfun(@double,hofAll,'uniformoutput',false);   

    % center data
%    meanDesc = cellfun(@(x) mean(x,1),hofAll,'uniformoutput',false);
%    hofCentered = cellfun(@(x,y) bsxfun(@minus,x,y),hofAll,meanDesc,'uniformoutput',false);
    meanDesc = mean(cell2mat(hofAll),1);
    hofCentered = cellfun(@(x) x-ones(size(x,1),1)*meanDesc,hofAll,'uniformoutput',false);
    
    % store results
    numSample = length(hofCentered);
    hof_all(end+1:end+numSample,:) = hofCentered;
    acm(i+1) = acm(i)+numSample;
    
end
numSample = length(hof_all);

% keep 1/2 original dimensions with pca
fprintf('pca...\n');
nsub = K*1000;
hofMat = cell2mat(hof_all);
hofMat(isnan(hofMat)) = 0;
[pcaHof,hofCoeff] = yael_pca(hofMat',round(9*s*s*t/2),ifcenter,ifverbose);
% [hofCoeff,pcaHof] = pca(hofMat);
% pcaHof = pcaHof(:,1:round(9*s*s*t/2))';
save([savepath infostr '_hofCoeff.mat'],'hofCoeff','-v7.3'); 

% fit GMM
fprintf('estimating GMM...\n');
% use a subsample to estimate GMM
subindx = randperm(size(pcaHof,2),nsub);
[w,mu,sigma] = yael_gmm(single(pcaHof(:,subindx)),K);

% encode FVs
fprintf('encoding FVs...\n');
fdims = cellfun('size',hof_all,1);
fdimscum = cumsum(fdims);
fdimscum = [0;fdimscum];
hofFV = zeros(2*size(pcaHof,1)*K+K-1,numSample);
for j = 1:numSample
    if all(pcaHof(:)==0)
        fprintf('at sample %u: all zeros\n',j);
    end
    hofFV(:,j) = yael_fisher(pcaHof(:,fdimscum(j)+1:fdimscum(j+1)),w,mu,sigma,'sigma','weights','nonorm');
end

% power and L2 normalization
hofFV = power_normalization(hofFV',rho)';
hofFV = yael_fvecs_normalize(single(hofFV));
hofFV = hofFV';

% save features
save([savepath infostr '_hofFV.mat'],'hofFV','-v7.3');
save([savepath infostr '_hofGMM.mat'],'w','mu','sigma','-v7.3');

%% -------------- HOG --------------
fprintf('HOG...\n');

% load samples
acm = zeros(length(fileIndx)+1,1);
for i = 1:length(fileIndx)

    movieParam = paramAll_galois(fileIndx(i));
    fprintf('loading sample: %s\n', movieParam.fileName);

    filename = [movieParam.fileName '_' infostr '_'];

    load([filepath filename 'hog.mat']);
    hogAll = cellfun(@double,hogAll,'uniformoutput',false);
    
    % center data
%    meanDesc = cellfun(@(x) mean(x,1),hogAll,'uniformoutput',false);
%    hogCentered = cellfun(@(x,y) bsxfun(@minus,x,y),hogAll,meanDesc,'uniformoutput',false);
    meanDesc = mean(cell2mat(hogAll),1);
    hogCentered = cellfun(@(x) x-ones(size(x,1),1)*meanDesc,hogAll,'uniformoutput',false);
    
    % store results
    numSample = length(hogAll);
    hog_all(end+1:end+numSample,:) = hogCentered;
    acm(i+1) = acm(i)+numSample;
    
end
numSample = length(hog_all);

% keep 1/2 original dimensions with pca
fprintf('pca...\n');
nsub = K*1000;
hogMat = cell2mat(hog_all);
hogMat(isnan(hogMat)) = 0;
[pcaHog,hogCoeff] = yael_pca(hogMat',round(8*s*s*t/2),ifcenter,ifverbose);
% [hogCoeff,pcaHog] = pca(hogMat);
% pcaHog = pcaHog(:,1:round(8*s*s*t/2))';
save([savepath infostr '_hogCoeff.mat'],'hogCoeff','-v7.3');

% fit GMM
fprintf('estimating GMM...\n');
% use a subsample to estimate GMM
subindx = randperm(size(pcaHog,2),nsub);
[w,mu,sigma] = yael_gmm(single(pcaHog(:,subindx)),K);

% encode FVs
fprintf('encoding FVs...\n');
fdims = cellfun('size',hog_all,1);
fdimscum = cumsum(fdims);
fdimscum = [0;fdimscum];
hogFV = zeros(size(pcaHog,1)*K*2+K-1,numSample);
for j = 1:numSample
    hogFV(:,j) = yael_fisher(pcaHog(:,fdimscum(j)+1:fdimscum(j+1)),w,mu,sigma,'sigma','weights','nonorm');
end

% power and L2 normalization
hogFV = power_normalization(hogFV',rho)';
hogFV = yael_fvecs_normalize(single(hogFV));
hogFV = hogFV';

% save features and parameters
save([savepath infostr '_hogFV.mat'],'hogFV','-v7.3');
save([savepath infostr '_hogGMM.mat'],'w','mu','sigma','-v7.3');

%% -------------- MBHx --------------
fprintf('MBHx...\n');

% load samples
acm = zeros(length(fileIndx)+1,1);
for i = 1:length(fileIndx)

    movieParam = paramAll_galois(fileIndx(i));
    fprintf('loading sample: %s\n', movieParam.fileName);

    filename = [movieParam.fileName '_' infostr '_'];

    load([filepath filename 'mbhx.mat']);
    mbhxAll = cellfun(@double,mbhxAll,'uniformoutput',false);

    % center data
%    meanDesc = cellfun(@(x) mean(x,1),mbhxAll,'uniformoutput',false);
%    mbhxCentered = cellfun(@(x,y) bsxfun(@minus,x,y),mbhxAll,meanDesc,'uniformoutput',false);
    meanDesc = mean(cell2mat(mbhxAll),1);
    mbhxCentered = cellfun(@(x) x-ones(size(x,1),1)*meanDesc,mbhxAll,'uniformoutput',false);

    % store results
    numSample = length(mbhxAll);
    mbhx_all(end+1:end+numSample,:) = mbhxCentered;
    acm(i+1) = acm(i)+numSample;
    
end
numSample = length(mbhx_all);

% keep 1/2 original dimensions with pca
fprintf('pca...\n');
nsub = K*1000;
mbhxMat = cell2mat(mbhx_all);
mbhxMat(isnan(mbhxMat)) = 0;
[pcaMbhx,mbhxCoeff] = yael_pca(mbhxMat',round(8*s*s*t/2),ifcenter,ifverbose);
% [mbhxCoeff,pcaMbhx] = pca(mbhxMat);
% pcaMbhx = pcaMbhx(:,1:round(8*s*s*t/2))';
save([savepath infostr '_mbhxCoeff.mat'],'mbhxCoeff','-v7.3');

% fit GMM
fprintf('estimating GMM...\n');
% use a subsample to estimate GMM
subindx = randperm(size(pcaMbhx,2),nsub);
[w,mu,sigma] = yael_gmm(single(pcaMbhx(:,subindx)),K);

% encode FVs
fprintf('encoding FVs...\n');
fdims = cellfun('size',mbhx_all,1);
fdimscum = cumsum(fdims);
fdimscum = [0;fdimscum];
mbhxFV = zeros(size(pcaMbhx,1)*K*2+K-1,numSample);
for j = 1:numSample
    mbhxFV(:,j) = yael_fisher(pcaMbhx(:,fdimscum(j)+1:fdimscum(j+1)),w,mu,sigma,'sigma','weights','nonorm');
end

% power and L2 normalization
mbhxFV = power_normalization(mbhxFV',rho)';
mbhxFV = yael_fvecs_normalize(single(mbhxFV));
mbhxFV = mbhxFV';

% save features
save([savepath infostr '_mbhxFV.mat'],'mbhxFV','-v7.3');
save([savepath infostr '_mbhxGMM.mat'],'w','mu','sigma','-v7.3');

%% -------------- MBHy --------------
fprintf('MBHy...\n');

% load samples
acm = zeros(length(fileIndx)+1,1);
for i = 1:length(fileIndx)

    movieParam = paramAll_galois(fileIndx(i));
    fprintf('loading sample: %s\n', movieParam.fileName);

    filename = [movieParam.fileName '_' infostr '_'];

    load([filepath filename 'mbhy.mat']);
    mbhyAll = cellfun(@double,mbhyAll,'uniformoutput',false);

    % center data
    meanDesc = mean(cell2mat(mbhyAll),1);
    mbhyCentered = cellfun(@(x) x-ones(size(x,1),1)*meanDesc,mbhyAll,'uniformoutput',false);
    
    % store results
    numSample = length(mbhyAll);
    mbhy_all(end+1:end+numSample,:) = mbhyCentered;
    acm(i+1) = acm(i)+numSample;
    
end
numSample = length(mbhy_all);

% keep 1/2 original dimensions with pca
fprintf('pca...\n');
nsub = K*1000;
mbhyMat = cell2mat(mbhy_all);
mbhyMat(isnan(mbhyMat)) = 0;
[pcaMbhy,mbhyCoeff] = yael_pca(mbhyMat',round(8*s*s*t/2),ifcenter,ifverbose);
% [mbhyCoeff,pcaMbhy] = pca(mbhyMat);
% pcaMbhy = pcaMbhy(:,1:round(8*s*s*t/2))';
save([savepath infostr '_mbhyCoeff.mat'],'mbhyCoeff','-v7.3');

% fit GMM
fprintf('estimating GMM...\n');
% use a subsample to estimate GMM
subindx = randperm(size(pcaMbhy,2),nsub);
[w,mu,sigma] = yael_gmm(single(pcaMbhy(:,subindx)),K);

% encode FVs
fprintf('encoding FVs...\n');
fdims = cellfun('size',mbhy_all,1);
fdimscum = cumsum(fdims);
fdimscum = [0;fdimscum];
mbhyFV = zeros(size(pcaMbhy,1)*K*2+K-1,numSample);
for j = 1:numSample
    mbhyFV(:,j) = yael_fisher(pcaMbhy(:,fdimscum(j)+1:fdimscum(j+1)),w,mu,sigma,'sigma','weights','nonorm');
end

% power and L2 normalization
mbhyFV = power_normalization(mbhyFV',rho)';
mbhyFV = yael_fvecs_normalize(single(mbhyFV));
mbhyFV = mbhyFV';

% save features
save([savepath infostr '_mbhyFV.mat'],'mbhyFV','-v7.3');
save([savepath infostr '_mbhyGMM.mat'],'w','mu','sigma','-v7.3');

%% put together data
FVall = [hofFV,hogFV,mbhxFV,mbhyFV]/4;
save([savepath infostr '_FVall.mat'],'FVall','acm','-v7.3');

% pca
[drFVall,coeff] = drHist(FVall,ci);
pcaDim = size(drFVall,2);
save([savepath infostr '_drFVall.mat'],'drFVall','acm','-v7.3');
save([savepath infostr '_pcaCoeff.mat'],'coeff','pcaDim','-v7.3');

