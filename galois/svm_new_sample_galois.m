% svm_single_sample
rng(1000)
%fileind = [33,34];
fileind = [25,33,34];
time_step = 25;
annoType = 5;
L = 15;
W = 5;
N = 32;
s = 3;
t = 3;
powern = 0;
intran = 1;
datestr = '20160209_registered';
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(time_step)];
filepath = ['/home/sh3276/work/results/dt_hists/min_var0.5/' infostr '_' datestr '/'];
savepath = ['/home/sh3276/work/results/dt_analysis/min_var0.5/' infostr '_' datestr '/'];
annoPath = '/home/sh3276/work/data/annotations/';

% load pca coefficient
load([savepath infostr '_pcaCoeff.mat']);

for i = 1:length(fileind)
    
    movieParam = paramAll_galois(fileind(i));

    % load data
    load([filepath movieParam.fileName '_' infostr '_histHof.mat']);
    load([filepath movieParam.fileName '_' infostr '_histHog.mat']);
    load([filepath movieParam.fileName '_' infostr '_histMbhx.mat']);
    load([filepath movieParam.fileName '_' infostr '_histMbhy.mat']);

    % exclude NaN
    histHof(isnan(histHof)) = 1/9;
    histHog(isnan(histHog)) = 1/8;
    histMbhx(isnan(histMbhx)) = 1/8;
    histMbhy(isnan(histMbhy)) = 1/8;
    histAll = [histHof,histHog,histMbhx,histMbhy]/4;

    % power normalization
    if powern
        histAll = power_normalization(histAll,0.5);
        histAll = histAll./((sum(histAll,2))*ones(1,size(histAll,2)));
    end
    
    % intra normalization
    if intran
        descdims = [size(histHof,2),size(histHog,2),size(histMbhx,2),size(histMbhy,2)];
        descdims = [0,cumsum(descdims)];
        for k = 1:4
            normdesc = sqrt(sum(histAll(:,descdims(k)+1:descdims(k+1)).^2,1));
            histAll(:,descdims(k)+1:descdims(k+1)) = ...
                histAll(:,descdims(k)+1:descdims(k+1))./...
                (ones(size(histAll,1),1)*normdesc);
        end
        histAll(isnan(histAll)) = 0;
    end
    
    % pca
    muHist = mean(histAll,1);
    drHistAll = bsxfun(@minus,histAll,muHist)*coeff;
    drHistAll = drHistAll(:,1:pcaDim);

    % load annotations
    annoRaw = annoMulti({movieParam},annoPath,time_step,0);
    annoAll = mergeAnno(annoRaw,annoType); 
    keepind = annoAll~=0;

    % save to libsvm format file
    gnLibsvmFile(annoAll(keepind),drHistAll(keepind,:),[savepath movieParam.fileName '_' infostr '_annoType' num2str(annoType) '_all.txt']);

end
