% script to calculate FVs using known GMM information
addpath(genpath('/home/sh3276/work/code/'));
addpath(genpath('/home/sh3276/software/inria_fisher_v1/yael_v371/matlab'));

%% set parameters
%fileIndx = [33,34];
fileIndx = [25,33,34];
W = 2;
L = 15;
timeStep = 25;
s = 2;
t = 3;
N = 32;
K = 128;
datestr = '20160112_registered';
savestr = '20160112_registered';
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];
%filepath = '/home/sh3276/work/results/dt_results_assembled/min_var0.5/';
filepath = ['/home/sh3276/work/results/dt_results_assembled/registered/' infostr '_' datestr '/'];
savepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr '_K_' num2str(K) '_' savestr '/'];

%% calculate FVs
for i = 1:length(fileIndx)
    
    movieParam = paramAll_galois(fileIndx(i));
    fprintf('processing sample: %s\n', movieParam.fileName);
    hofFV = encodeIndivFV(fileIndx(i),9,filepath,savepath,[infostr '_hof']);
    hogFV = encodeIndivFV(fileIndx(i),8,filepath,savepath,[infostr '_hog']);
    mbhxFV = encodeIndivFV(fileIndx(i),8,filepath,savepath,[infostr '_mbhx']);
    mbhyFV = encodeIndivFV(fileIndx(i),8,filepath,savepath,[infostr '_mbhy']);
    
    % put together FV
    FVall = [hofFV,hogFV,mbhxFV,mbhyFV]/4;
%     FVall = [hofFV,hogFV]/2;
    save([savepath movieParam.fileName '_' infostr '_FVall.mat'],'FVall','-v7.3');
    
end

