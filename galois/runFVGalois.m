% script for encoding fisher vectors

addpath(genpath('/home/sh3276/work/code/'));
addpath(genpath('/home/sh3276/software/inria_fisher_v1/yael_v371/matlab'));

%% set parameters
% file parameters
%fileIndx = [1:5,7:11,13:28,30:31];
fileIndx = [1:5,7:11,13:24,26:28,30:32];
%fileIndx = 401:414;
%fileIndx = [238,239]
W = 5;
L = 15;
timeStep = 25;
s = 3;
t = 3;
N = 32;
K = 128; % number of GMM in FV
ci = 90;
datestr = '20160209_registered';
savestr = '20160210_registered_in';
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];
%filepath = '/home/sh3276/work/results/dt_results_assembled/min_var0.5/';
filepath = ['/home/sh3276/work/results/dt_results_assembled/registered/'  infostr '_' datestr '/'];
savepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr '_K_' num2str(K) '_' savestr '/'];

numPatch = s*s*t;

% initialization
rng(1000);

%% -------------- HOF --------------
fprintf('HOF...\n');

% fit GMM and encode FV
[coeff,w,mu,sigma,hofFV,eigval,acm] = encodeFV(fileIndx,K,9,numPatch,filepath,...
    [infostr '_hof']);

% save results
save([savepath infostr '_hofCoeff.mat'],'coeff','eigval','-v7.3'); 
save([savepath infostr '_hofFV.mat'],'hofFV','-v7.3');
save([savepath infostr '_hofGMM.mat'],'w','mu','sigma','-v7.3');

%% -------------- HOG --------------
fprintf('HOG...\n');

% fit GMM and encode FV
[coeff,w,mu,sigma,hogFV,eigval] = encodeFV(fileIndx,K,8,numPatch,filepath,...
    [infostr '_hog']);

% save results
save([savepath infostr '_hogCoeff.mat'],'coeff','eigval','-v7.3'); 
save([savepath infostr '_hogFV.mat'],'hogFV','-v7.3');
save([savepath infostr '_hogGMM.mat'],'w','mu','sigma','-v7.3');

%% -------------- MBHx --------------
fprintf('MBHx...\n');

% fit GMM and encode FV
[coeff,w,mu,sigma,mbhxFV,eigval] = encodeFV(fileIndx,K,8,numPatch,filepath,...
    [infostr '_mbhx']);

% save results
save([savepath infostr '_mbhxCoeff.mat'],'coeff','eigval','-v7.3'); 
save([savepath infostr '_mbhxFV.mat'],'mbhxFV','-v7.3');
save([savepath infostr '_mbhxGMM.mat'],'w','mu','sigma','-v7.3');

%% -------------- MBHy --------------
fprintf('MBHy...\n');

% fit GMM and encode FV
[coeff,w,mu,sigma,mbhyFV,eigval] = encodeFV(fileIndx,K,8,numPatch,filepath,...
    [infostr '_mbhy']);

% save results
save([savepath infostr '_mbhyCoeff.mat'],'coeff','eigval','-v7.3'); 
save([savepath infostr '_mbhyFV.mat'],'mbhyFV','-v7.3');
save([savepath infostr '_mbhyGMM.mat'],'w','mu','sigma','-v7.3');

%% put together data
% FVall = [hofFV,hogFV]/2;
FVall = [hofFV,hogFV,mbhxFV,mbhyFV]/4;
save([savepath infostr '_FVall.mat'],'FVall','acm','-v7.3');

% pca
[drFVall,coeff] = drHist(FVall,ci);
pcaDim = size(drFVall,2);
save([savepath infostr '_drFVall.mat'],'drFVall','acm','-v7.3');
save([savepath infostr '_pcaCoeff.mat'],'coeff','pcaDim','-v7.3');

