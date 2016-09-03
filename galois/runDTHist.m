% script for calculating histograms from DT results

%% set parameters
fileIndx = [1:5,7:11,13:28,30:34];
%fileIndx = 202:253;
%fileIndx = 301:324;
%fileIndx = [1:5,7:11,13,16,20:21,23:25,28:33];
%fileIndx = [32,33];
%fileIndx = 401:414;
sampleStride = 2;
trackLength = 15;
timeStep = 25;
s = 2;
t = 3;
N = 32;
%numBins = 8*s*s*t;
%numBinsHof = 9*s*s*t;
numBins = 8;
numBinsHof = 9;
datestr = '20160112_registered';
infostr = ['L_' num2str(trackLength) '_W_' num2str(sampleStride) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];
%filepath = '/home/sh3276/work/results/dt_results_assembled/min_var0.5/';
filepath = ['/home/sh3276/work/results/dt_results_assembled/registered/' infostr '_' datestr '/'];
cdbkpath = ['/home/sh3276/work/results/dt_cdbk/min_var0.5/' infostr '_' datestr '/'];
savepath = ['/home/sh3276/work/results/dt_hists/min_var0.5/' infostr '_' datestr '/'] ;

%% load codebooks
load([cdbkpath 'hof_cdbk_' infostr '.mat']);
load([cdbkpath 'hog_cdbk_' infostr '.mat']);
load([cdbkpath 'mbhx_cdbk_' infostr '.mat']);
load([cdbkpath 'mbhy_cdbk_' infostr '.mat']);

%% calculate histograms
for i = 1:length(fileIndx)
    
    movieParam = paramAll_galois(fileIndx(i));
    fprintf('processing sample: %s\n', movieParam.fileName);
    
%     filename = [movieParam.fileName '_' num2str(videoSize) 's_' num2str(trackThresh)...
%         '_L_' num2str(trackLength) '_W_' num2str(sampleStride) '_'];
    filename = [movieParam.fileName '_' infostr '_'];

    % HOF
    fprintf('calculating HOF...\n');
    load([filepath filename 'hof.mat']);
    histHof = assignMaskedCenters(hofAll,hofCenters,numBinsHof,'exp');
    save([savepath filename 'histHof.mat'],'histHof','-v7.3');
    
    % HOG
    fprintf('calculating HOG...\n');
    load([filepath filename 'hog.mat']);
    histHog = assignMaskedCenters(hogAll,hogCenters,numBins,'exp');
    save([savepath filename 'histHog.mat'],'histHog','-v7.3');
    
    % MBHx
    fprintf('calculating MBHx...\n');
    load([filepath filename 'mbhx.mat']);
    histMbhx = assignMaskedCenters(mbhxAll,mbhxCenters,numBins,'exp');
    save([savepath filename 'histMbhx.mat'],'histMbhx','-v7.3');
    
    % MBHy
    fprintf('calculating MBHy...\n');
    load([filepath filename 'mbhy.mat']);
    histMbhy = assignMaskedCenters(mbhyAll,mbhyCenters,numBins,'exp');
    save([savepath filename 'histMbhy.mat'],'histMbhy','-v7.3');
    

end
