% MAIN ANALYSIS SCRIPT

% reset random generator
rng(1000);

%% set path
addpath(genpath('/home/sh3276/work/code/'));
addpath(genpath('/home/sh3276/software/inria_fisher_v1/yael_v371/matlab'));

%% setup parameters
param = struct();

% file information
param.fileIndx = [1:5,7:11,13:24,26:28,30:32];
param.testIndx = [];
param.datastr = '20160209_registered';
param.savestr = '20160223';
param.infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];
param.filepath = ['/home/sh3276/work/results/dt_results_assembled/registered/'  infostr '_' datastr '/'];
param.savepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr '_K_' num2str(K) '_' savestr '/'];

% DT parameters
param.dt.W = 5;
param.dt.L = 15;
param.dt.timeStep = 25;
param.dt.s = 3;
param.dt.t = 3;
param.dt.N = 32;
param.dt.numPatch = s*s*t;

% FV parameters
param.K = 128;
param.ci = 90;
param.intran = 0;
param.powern = 1;

%% 






