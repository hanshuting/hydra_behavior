% script for generating embedding map and for embed new samples
addpath(genpath('/home/sh3276/software/MotionMapper/'));
addpath(genpath('/home/sh3276/work/code/bow_hydra/'));

%% initialize parameters
parameters.distType = 'euc';
parameters = setRunParameters(parameters);

% data parameters
fileIndx = 301:324;
infostr = 'L_15_W_2_N_32_s_1_t_1_step_25';
K = 256;
dopca = 1;
datestr = '20160510_spseg3';
modelstr = '20160315_spseg3';
empath = '/home/sh3276/work/results/embedding/';
pcapath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr '_K_'...
    num2str(K) '_' modelstr '/'];
filepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr '_K_'...
    num2str(K) '_' datestr '/'];
savepath = ['/home/sh3276/work/results/embedding/' infostr '_K_'...
    num2str(K) '_' datestr '/'];

%% load data
load([empath infostr '_K_' num2str(K) '_' modelstr '_tsneTrain.mat']);

if dopca
    load([pcapath infostr '_pcaCoeff.mat']);
end

for i = 1:length(fileIndx)
    
    movieParam = paramAll_galois(fileIndx(i));
    fprintf('processing %s...\n',movieParam.fileName);
    
    load([filepath movieParam.fileName '_' infostr '_FVall.mat']);
    data = FVall;

    if dopca
        muData = mean(data,1);
        data = bsxfun(@minus,data,muData)*coeff;
        data = data(:,1:pcaDim);
    end

    % normalize data
    data = data-min(data,[],2)*ones(1,size(data,2));
    data = data./(sum(data,2)*ones(1,size(data,2)));

    [emData,~] = findEmbedding(data,dataTrain,emDataTrain,parameters);
    save([savepath movieParam.fileName '_embedding.mat'],'emData');
    
end

delete(gcp)


