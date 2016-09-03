function [dataCoeff,w,mu,sigma,FV,eigval,acm] = encodeFV(fileIndx,K,lfeat,numPatch,...
    filepath,namestr)
% Encode Fisher Vector
% SYNOPSIS: [dataCoeff,w,mu,sigma,FV,acm] = encodeFV(fileIndx,K,lfeat,...
%   numPatch,filepath,namestr)
% INPUT:
%   fileIndx: see fileinfo.m
%   K: number of gaussian mixtures
%   lfeat: length of feature
%   numPatch: number of spatial temporal pyramids
%   filepath: input data path
%   namestr: input data str
% OUTPUT:
%   dataCoeff: pca matrix
%   w, mu, sigma: estimated GMM parameters
%   FV: fisher vector
%   acm: file segmentation vector
% 
% Shuting Han, 2016

D = round(numPatch*lfeat/2);

% load samples
dataAll = [];
acm = zeros(length(fileIndx)+1,1);
fdims = [];
for i = 1:length(fileIndx)

    movieParam = paramAll_galois(fileIndx(i));
    fprintf('loading sample: %s\n', movieParam.fileName);

    data = load([filepath movieParam.fileName '_' namestr '.mat']);
    data = struct2cell(data);
    data = data{1};
    data = cellfun(@double,data,'uniformoutput',false);
    
    numSample = cellfun('size',data(:,1),1);
    fdims(end+1:end+length(numSample)) = numSample;
    acm(i+1) = acm(i)+length(numSample);
    
    data = cell2mat(data);
    data(isnan(data)) = 1/lfeat;
    
    meanDesc = mean(data,1);
    dataCentered = data-repmat(meanDesc,size(data,1),1);
    
    dataAll(end+1:end+size(dataCentered,1),:) = dataCentered;
    
end

% get sample size in each file
fdimscum = cumsum(fdims);
fdimscum = [0,fdimscum];
numSample = size(dataAll,1);

% keep 1/2 original dimensions with pca
fprintf('pca...\n');
nsub = 1e6;
if numSample > nsub
    subindx = randperm(numSample,nsub);
else
    subindx = true(numSample,1);
end
meanDesc = mean(dataAll,1);
dataAllCentered = dataAll-repmat(meanDesc,numSample,1);
[~,dataCoeff,eigval] = yael_pca(dataAllCentered(subindx,:)',D,0,0);
pcaData = single(dataAllCentered*dataCoeff)';

% whitening
pcaData = diag(1./sqrt(eigval))*pcaData;

% fit GMM
fprintf('estimating GMM...\n');
nsub = K*1000;
subindx = randperm(size(dataAll,1),nsub);
[w,mu,sigma] = yael_gmm(single(pcaData(:,subindx)),K);

% encode FVs
fprintf('encoding FVs...\n');
FV = zeros(2*size(pcaData,1)*K+K-1,acm(end));
for j = 1:acm(end)
    FV(:,j) = yael_fisher(pcaData(:,fdimscum(j)+1:fdimscum(j+1)),w,mu,sigma,'sigma','weights','nonorm');
end

% intra-, power and L2 normalization
FV = FV';
FV = intra_normalization(FV,K,D);
FV = power_normalization(FV,0.5);
FV = yael_fvecs_normalize(single(FV'))';

end
