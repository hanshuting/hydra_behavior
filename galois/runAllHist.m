% script for calculating histograms from DT results

%% set parameters
fileIndx = [1:5,7:11,13:28,30:34];
%fileIndx = [1:5,7:11,13,16,20:21,23:25,28:33];
%fileIndx = [32,33];
%fileIndx = 401:414;
sampleStride = 2;
trackLength = 15;
timeStep = 25;
s = 2;
t = 3;
N = 32;
ci = 90;
%numBins = 8*s*s*t;
%numBinsHof = 9*s*s*t;
numBins = 8;
numBinsHof = 9;
datestr = '20160130_registered';
infostr = ['L_' num2str(trackLength) '_W_' num2str(sampleStride) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];
filepath = '/home/sh3276/work/results/dt_results_assembled/min_var0.5/';
cdbkpath = ['/home/sh3276/work/results/dt_cdbk/min_var0.5/' infostr '_' datestr '/'];
savepath = ['/home/sh3276/work/results/dt_hists/min_var0.5/' infostr '_' datestr '/'] ;

%% load codebooks
load([cdbkpath 'desc_cdbk_' infostr '.mat']);

%% calculate histograms
histAll = [];
acm = zeros(length(fileIndx)+1,1);
for i = 1:length(fileIndx)
    
    movieParam = paramAll_galois(fileIndx(i));
    fprintf('processing sample: %s\n', movieParam.fileName);
    
%     filename = [movieParam.fileName '_' num2str(videoSize) 's_' num2str(trackThresh)...
%         '_L_' num2str(trackLength) '_W_' num2str(sampleStride) '_'];
    filename = [movieParam.fileName '_' infostr '_'];

    % assign to histograms
    load([filepath filename '_desc.mat']);
    histDesc = assignMaskedCenters(desc,descCenters,numBinsHof+numBins*3,'exp');
    save([savepath filename 'histDesc.mat'],'histDesc','-v7.3'); 

    acm(i+1) = acm(i)+size(histDesc,1);
    histAll(end+1:end+size(histDesc,1),:) = histDesc;
    
end

save([savepath infostr '_histAll.mat'],'histAll','acm','-v7.3');

% pca
[drHistAll,coeff] = drHist(histAll,ci);
pcaDim = size(drHistAll,2);

save([savepath infostr '_drHist.mat'],'drHistAll','acm','-v7.3');
save([savepath infostr '_pcaCoeff.mat'],'coeff','pcaDim','-v7.3');
