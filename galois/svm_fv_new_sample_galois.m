% generate libsvm format data for individual samples

% parameters
rng(1000)
fileind = [1,25,33,34];
%fileind = [1,33,34,55];
time_step = 25;
annoType = 5;
L = 15;
W = 2;
N = 32;
s = 1;
t = 1;
K = 256;
datestr = '20160315_spseg3';
dopca = 1;
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(time_step)];
filepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr '_K_' num2str(K) '_' datestr '/'];
savepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr '_K_' num2str(K) '_' datestr '/'];
annoPath = '/home/sh3276/work/data/annotations/';

% load pca coefficient
filestr = '_FV_';
if dopca
    filestr = '_drFV_';
    load([savepath infostr '_pcaCoeff.mat']);
end

% process files separately
for i = 1:length(fileind)
    
    movieParam = paramAll_galois(fileind(i));

    % load data
    load([filepath movieParam.fileName '_' infostr '_FVall.mat']);
    sample = FVall;
    %load([filepath movieParam.fileName '_' infostr '_hofFV.mat']);
    %load([filepath movieParam.fileName '_' infostr '_mbhxFV.mat']);
    %load([filepath movieParam.fileName '_' infostr '_mbhyFV.mat']);
    %sample = [hofFV,mbhxFV,mbhyFV]/4;

    % pca
    if dopca
        muData = mean(sample,1);
        sample = bsxfun(@minus,sample,muData)*coeff;
        sample = sample(:,1:pcaDim);
    end

    % load annotations
    annoAll = annoMulti({movieParam},annoPath,annoType,time_step);
    keepind = annoAll~=0;
    %annoAll = ones(size(sample,1),1); keepind = true(size(sample,1),1);

    % save to libsvm format file
    gnLibsvmFile(annoAll(keepind),sample(keepind,:),[savepath movieParam.fileName '_' infostr '_annoType' num2str(annoType) filestr 'all.txt']);

end
