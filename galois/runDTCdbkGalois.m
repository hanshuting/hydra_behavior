% script for generating codebooks from DT results

%% set parameters
fileIndx = [1:5,7:11,13:28,30:32];
%fileIndx = 202:253;
%fileIndx = [1:5,7:11,13,16,20:21,23:25,28:31];
%fileIndx = [238,239];
%fileIndx = 401:414;
sampleStride = 2;
trackLength = 15;
timeStep = 25;
s = 2;
t = 3;
N = 32;
datestr = '20160112_registered';
infostr = ['L_' num2str(trackLength) '_W_' num2str(sampleStride) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];
%filepath = '/home/sh3276/work/results/dt_results_assembled/min_var0.5/';
filepath = ['/home/sh3276/work/results/dt_results_assembled/registered/' infostr '_' datestr '/'];
savepath = ['/home/sh3276/work/results/dt_cdbk/min_var0.5/' infostr '_' datestr '/'];

% initialization
rng(1000);
%setSeed(0);
numCenters = 1000;
%numBins = 8*s*s*t;
%numBinsHof = 9*s*s*t;
numBins = 8;
numBinsHof = 9;
hof_all = {};
hog_all = {};
mbhx_all = {};
mbhy_all = {};

infostr = ['L_' num2str(trackLength) '_W_' num2str(sampleStride) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];


%% HOF
fprintf('HOF...\n');

% load samples
for i = 1:length(fileIndx)
    
    movieParam = paramAll_galois(fileIndx(i));
    fprintf('loading sample: %s\n', movieParam.fileName);
    
    filename = [movieParam.fileName '_' infostr '_'];

    load([filepath filename 'hof.mat']);

    % store results
    numSample = length(hofAll);
    hof_all(end+1:end+numSample,:) = hofAll;   
     
end

% generate codebook
fprintf('calculating codebook...\n');
%hof_all = hof_all';
hofCenters = gnCdbk(hof_all,numBinsHof,numCenters);
save([savepath 'hof_cdbk_' infostr '.mat'],'hofCenters','-v7.3');

%% HOG
fprintf('HOG...\n');

% load samples
for i = 1:length(fileIndx)
    
    movieParam = paramAll_galois(fileIndx(i));
    fprintf('loading sample: %s\n', movieParam.fileName);
    
    filename = [movieParam.fileName '_' infostr '_'];

    load([filepath filename 'hog.mat']);

    % store results
    numSample = length(hogAll);
    hog_all(end+1:end+numSample,:) = hogAll;   
     
end

% generate codebook
fprintf('calculating codebook...\n');
%hog_all = hog_all';
hogCenters = gnCdbk(hog_all,numBins,numCenters);
save([savepath 'hog_cdbk_' infostr '.mat'],'hogCenters','-v7.3');

%% MBHx
fprintf('MBHx...\n');

% load samples
for i = 1:length(fileIndx)
    
    movieParam = paramAll_galois(fileIndx(i));
    fprintf('loading sample: %s\n', movieParam.fileName);
    
    filename = [movieParam.fileName '_' infostr '_'];

    load([filepath filename 'mbhx.mat']);

    % store results
    numSample = length(mbhxAll);
    mbhx_all(end+1:end+numSample,:) = mbhxAll;   
     
end

% generate codebook
fprintf('calculating codebook...\n');
%mbhx_all = mbhx_all';
mbhxCenters = gnCdbk(mbhx_all,numBins,numCenters);
save([savepath 'mbhx_cdbk_' infostr '.mat'],'mbhxCenters','-v7.3');

%% MBHy
fprintf('MBHy...\n');

% load samples
for i = 1:length(fileIndx)
    
    movieParam = paramAll_galois(fileIndx(i));
    fprintf('loading sample: %s\n', movieParam.fileName);
    
    filename = [movieParam.fileName '_' infostr '_'];

    load([filepath filename 'mbhy.mat']);

    % store results
    numSample = length(mbhyAll);
    mbhy_all(end+1:end+numSample,:) = mbhyAll;   
     
end

% generate codebook
fprintf('calculating codebook...\n');
%mbhy_all = mbhy_all';
mbhyCenters = gnCdbk(mbhy_all,numBins,numCenters);
save([savepath 'mbhy_cdbk_' infostr '.mat'],'mbhyCenters','-v7.3');
