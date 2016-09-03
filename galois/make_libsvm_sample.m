% svm_single_sample
rng(1000)
%fileind = [33,34];
%fileind = [32,33];
fileind = [301:306];
time_step = 25;
annoType = 3;
L = 15;
W = 2;
N = 32;
s = 1;
t = 3;
datestr = '20160105';
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(time_step)];
filepath = ['/home/sh3276/work/results/dt_hists/min_var0.5/' infostr '_' datestr '/'];
savepath = ['/home/sh3276/work/results/dt_analysis/min_var0.5/' infostr '_' datestr '/'];
annoPath = '/home/sh3276/work/data/annotations/';

% load pca coefficient
load([savepath infostr '_pcaCoeff.mat']);

for i = 1:length(fileind)
    
    movieParam = paramAll_galois(fileind(i));

    % load data
    load([filepath movieParam.fileName '_' infostr '_histHof.mat']);
    load([filepath movieParam.fileName '_' infostr '_histHog.mat']);
    load([filepath movieParam.fileName '_' infostr '_histMbhx.mat']);
    load([filepath movieParam.fileName '_' infostr '_histMbhy.mat']);
    histAll = [histHof,histHog,histMbhx,histMbhy]/4;

    % power normalization
    histAll = power_normalization(histAll,0.5);
    histAll = histAll./((sum(histAll,2))*ones(1,size(histAll,2)));

    % pca
    muHist = mean(histAll,1);
    drHistAll = bsxfun(@minus,histAll,muHist)*coeff;
    drHistAll = drHistAll(:,1:pcaDim);

    % save to libsvm format file
    gnLibsvmFile(ones(size(drHistAll,1),1),drHistAll,[savepath movieParam.fileName '_' infostr '_annoType' num2str(annoType) '_all.txt']);

end
