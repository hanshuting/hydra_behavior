% script to calculate FVs using known GMM information
addpath(genpath('/home/sh3276/work/code/'));
addpath(genpath('/home/sh3276/software/inria_fisher_v1/yael_v371/matlab'));

%% set parameters
%fileIndx = [1,25,33,34];
fileIndx = 20:22; % ss
W = 5;
L = 15;
timeStep = 25;
s = 1;
t = 3;
N = 32;
K = 256;
intran = 0;
powern = 1;
datastr = '20160229_spseg';
savestr = '20160229_spseg_3';
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];
%filepath = '/home/sh3276/work/results/dt_results_assembled/min_var0.5/';
filepath = ['/home/sh3276/work/results/dt_results_assembled/registered/' infostr '_' datastr '/'];
savepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr '_K_' num2str(K) '_' savestr '/'];

%% calculate FVs
for i = 1:length(fileIndx)
    
    movieParam = paramAll_galois(fileIndx(i));
    fprintf('processing sample: %s\n', movieParam.fileName);
   trajFV = encodeIndivSpFV2(fileIndx(i),filepath,savepath,[infostr '_traj'],intran,powern);
    hofFV = encodeIndivSpFV2(fileIndx(i),filepath,savepath,[infostr '_hof'],intran,powern);
    hogFV = encodeIndivSpFV2(fileIndx(i),filepath,savepath,[infostr '_hog'],intran,powern);
%     mbhxFV = encodeIndivSpFV2(fileIndx(i),filepath,savepath,[infostr '_mbhx'],intran,powern);
%     mbhyFV = encodeIndivSpFV2(fileIndx(i),filepath,savepath,[infostr '_mbhy'],intran,powern);
    mbhFV = encodeIndivSpFV2(fileIndx(i),filepath,savepath,[infostr '_mbh'],intran,powern);

    % put together FV
    FVall = [trajFV,hofFV,hogFV,mbhFV]/4;
%    FVall = [trajFV,hofFV,hogFV,mbhxFV,mbhyFV]/5;
%    FVall = [hofFV,hogFV,mbhxFV,mbhyFV]/4;
    save([savepath movieParam.fileName '_' infostr '_FVall.mat'],'FVall','-v7.3');
    
end

