
%fileind = [1:5,7:11,13:28,30:32];
fileIndx = [1:5,7:11,13:24,26:28,30:32];
%fileind = [1:5,7:11,13,16,20:21,23:25,28:33];
%fileind = 401:414;
%fileind = [238,239];
sampleStride = 5;
trackLength = 15;
timeStep = 25;
s = 3;
t = 3;
N = 32;
ci = 90;
intran = 1;
powern = 0;
datestr = '20160209_registered';
savestr = '20160216_registered';
infostr = ['L_' num2str(trackLength) '_W_' num2str(sampleStride) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];
filepath = ['/home/sh3276/work/results/dt_hists/min_var0.5/' infostr '_' datestr '/'];
savepath = ['/home/sh3276/work/results/dt_analysis/min_var0.5/' infostr '_' savestr '/'];

histHofAll = [];
histHogAll = [];
histMbhxAll = [];
histMbhyAll = [];

acm = zeros(length(fileIndx)+1,1);
for i = 1:length(fileIndx)
    
    movieParam = paramAll_galois(fileIndx(i));
    
    load([filepath movieParam.fileName '_' infostr '_histHof.mat']);
    histHof(isnan(histHof)) = 1/9;
    histHofAll(end+1:end+size(histHof,1),:) = histHof;
    
    load([filepath movieParam.fileName '_' infostr '_histHog.mat']);
    histHog(isnan(histHog)) = 1/8;
    histHogAll(end+1:end+size(histHog,1),:) = histHog;
    
    load([filepath movieParam.fileName '_' infostr '_histMbhx.mat']);
    histMbhx(isnan(histMbhx)) = 1/8;
    histMbhxAll(end+1:end+size(histMbhx,1),:) = histMbhx;
    
    load([filepath movieParam.fileName '_' infostr '_histMbhy.mat']);
    histMbhy(isnan(histMbhy)) = 1/8;
    histMbhyAll(end+1:end+size(histMbhy,1),:) = histMbhy;
    
    acm(i+1) = size(histHofAll,1);
    
end

clear histHof histHog histMbhx histMbhy

% power normalization
histAll = [histHofAll,histHogAll,histMbhxAll,histMbhyAll]/4;
%histAll = [histHofAll,histHogAll]/2;
if powern
    histAll = power_normalization(histAll,0.5);
    histAll = normalize_data(histAll);
    %histAll = histAll./((sum(histAll,2))*ones(1,size(histAll,2)));
end
if intran
    descdims = [size(histHofAll,2),size(histHogAll,2),size(histMbhxAll,2),size(histMbhyAll,2)];
    descdims = [0,cumsum(descdims)];
    for i = 1:length(fileIndx)
        for j = 1:4
            normdesc = sqrt(sum(histAll(acm(i)+1:acm(i+1),descdims(j)+1:descdims(j+1)).^2,1));
            histAll(acm(i)+1:acm(i+1),descdims(j)+1:descdims(j+1)) = ...
                histAll(acm(i)+1:acm(i+1),descdims(j)+1:descdims(j+1))./...
                (ones(acm(i+1)-acm(i),1)*normdesc);
        end
    end
    histAll(isnan(histAll)) = 0;
end
save([savepath infostr '_histAll.mat'],'histHofAll','histHogAll','histMbhxAll','histMbhyAll','histAll','acm','-v7.3');

% pca
[drHistAll,coeff] = drHist(histAll,ci);
pcaDim = size(drHistAll,2);

save([savepath infostr '_drHist.mat'],'drHistAll','acm','-v7.3');
save([savepath infostr '_pcaCoeff.mat'],'coeff','pcaDim','-v7.3');
