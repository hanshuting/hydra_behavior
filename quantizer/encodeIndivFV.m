function [FV] = encodeIndivFV(fileIndx,lfeat,filepath,savepath,namestr)
% encode fisher vector for individual feature files

% load data
movieParam = paramAll_galois(fileIndx);
gmm = load([savepath namestr 'GMM.mat']);
load([savepath namestr 'Coeff.mat']);
data = load([filepath movieParam.fileName '_' namestr '.mat']);
data = struct2cell(data);
data = data{1};
data = cellfun(@double,data,'uniformoutput',false);

% get cell size
numSample = size(data,1);
fdims = cellfun('size',data(:,1),1);
fdimscum = cumsum(fdims);
fdimscum = [0;fdimscum];

% center data
data = cell2mat(data);
data(isnan(data)) = 1/lfeat;
meanDesc = mean(data,1);
dataCentered = data-repmat(meanDesc,size(data,1),1);

% pca
pcaData = single(dataCentered*coeff)';
pcaData = diag(1./sqrt(eigval))*pcaData;

% calculate FV
D = size(pcaData,1);
K = size(gmm.mu,2);
FV = zeros(D*K*2+K-1,numSample);
for i = 1:numSample
    FV(:,i) = yael_fisher(pcaData(:,fdimscum(i)+1:fdimscum(i+1)),gmm.w,gmm.mu,...
        gmm.sigma,'sigma','weights','nonorm');
end

% intra-, power and L2 normalization
FV = FV';
FV = intra_normalization(FV,K,D);
FV = power_normalization(FV,0.5);
FV = yael_fvecs_normalize(single(FV'))';

end