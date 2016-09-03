
% initialize
setSeed(1000);
fileIndx = 1:13;
% timeStep = 5;
numBins = 8;
filepath = 'C:\Shuting\Data\DT_results\dt_results_assembled\';
cdbkpath = 'C:\Shuting\Data\DT_results\cdbk_20151102\';
savepath = 'C:\Shuting\Data\DT_results\hists_20151102\';

%% load codebooks
fprintf('loading codebooke...\n');
load([cdbkpath 'hof_cdbk.mat']);
load([cdbkpath 'hog_cdbk.mat']);
load([cdbkpath 'mbhx_cdbk.mat']);
load([cdbkpath 'mbhy_cdbk.mat']);

%% calculate histograms
for i = fileIndx

    movieParam = paramAll(i);

    fprintf('loading sample: %s\n', movieParam.fileName);
    load([filepath movieParam.fileName '_5s_0.5_L_10_W_5_hof.mat']);
    load([filepath movieParam.fileName '_5s_0.5_L_10_W_5_hog.mat']);
    load([filepath movieParam.fileName '_5s_0.5_L_10_W_5_mbhx.mat']);
    load([filepath movieParam.fileName '_5s_0.5_L_10_W_5_mbhy.mat']);

    fprintf('calculating histogram...\n');
    histHof = assignMaskedCenters(hofAll,hofCenters,numBins,'exp');
    histHog = assignMaskedCenters(hogAll,hogCenters,numBins+1,'exp');
    histMbhx = assignMaskedCenters(mbhxAll,mbhxCenters,numBins,'exp');
    histMbhy = assignMaskedCenters(mbhyAll,mbhyCenters,numBins,'exp');
    
    %% save result
    fprintf('saving result...\n');
    save([savepath movieParam.fileName '_results_histHof.mat'],'histHof','-v7.3');
    save([savepath movieParam.fileName '_results_histHog.mat'],'histHog','-v7.3');
    save([savepath movieParam.fileName '_results_histMbhx.mat'],'histMbhx','-v7.3');
    save([savepath movieParam.fileName '_results_histMbhy.mat'],'histMbhy','-v7.3');

end



