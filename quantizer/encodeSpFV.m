function [dataCoeff,w,mu,sigma,nFV,eigval,meanDesc,acm] = encodeSpFV(fileIndx,filepath,fvparam)
% Encode Fisher Vector with spatial temporal pyramids
% SYNOPSIS: [dataCoeff,w,mu,sigma,FV,acm] = encodeFV(fileIndx,K,lfeat,...
%   numPatch,filepath,namestr)
% INPUT:
%   fileIndx: see fileinfo.m
%   K: number of gaussian mixtures
%   lfeat: length of feature
%   numPatch: number of spatial temporal pyramids
%   filepath: input data path
%   namestr: input data str
%   intran: do intra-normalization (logical)
%   powern: do power-normalization (logical)
% OUTPUT:
%   dataCoeff: pca matrix
%   w, mu, sigma: estimated GMM parameters
%   nFV: fisher vector (normalized)
%   acm: file segmentation vector
% 
% Shuting Han, 2016

% parse input parameter structure
K = fvparam.K;
numPatch = fvparam.numPatch;
intran = fvparam.intran;
powern = fvparam.powern;
namestr = fvparam.namestr;
lfeat = fvparam.lfeat;

% load samples
D = round(lfeat/2);
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
    
    meanDesc = mean(reshape(data',lfeat,[])',1);
    dataCentered = data-repmat(meanDesc,size(data,1),numPatch);
    
    dataAll(end+1:end+size(dataCentered,1),:) = dataCentered;
%    dataAll(end+1:end+size(data,1),:) = data;
    
end

clear data

% get sample size in each file
fdimscum = cumsum(fdims)*numPatch;
fdimscum = [0,fdimscum];

% reshape data to be single features
dataAll = reshape(dataAll',lfeat,[])';
numSample = size(dataAll,1);

% keep 1/2 original dimensions with pca
fprintf('pca...\n');
nsub = 1e6;
if numSample > nsub
    subindx = randperm(numSample,nsub);
else
    subindx = true(numSample,1);
end
%meanDesc = mean(dataAll,1);
%dataAllCentered = dataAll-repmat(meanDesc,numSample,1);
%[~,dataCoeff,eigval] = yael_pca(dataAllCentered(subindx,:)',D,0,0);
%pcaData = single(dataAllCentered*dataCoeff)';
[~,dataCoeff,eigval] = yael_pca(dataAll(subindx,:)',D,0,0);
pcaData = single(dataAll*dataCoeff)';

% whitening
pcaData = diag(1./sqrt(eigval))*pcaData;

% fit GMM
fprintf('estimating GMM...\n');
nsub = K*1000;
subindx = randperm(numSample,nsub);
[w,mu,sigma] = yael_gmm(single(pcaData(:,subindx)),K);

% encode FVs
fprintf('encoding FVs...\n');
FVsz = 2*D*K+K-1;
FV = zeros(FVsz*numPatch,acm(end));
for j = 1:acm(end)
    for k = 1:numPatch
        FV((k-1)*FVsz+1:k*FVsz,j) = yael_fisher...
            (pcaData(:,fdimscum(j)+k:numPatch:fdimscum(j+1)),w,mu,sigma,'sigma','weights','nonorm');
    end
end

% intra-, power and L2 normalization
FV = FV';
nFV = FV;
if intran
    for i = 1:numPatch
        for j = 1:length(fileIndx)
            nFV(acm(j)+1:acm(j+1),(i-1)*FVsz+1:i*FVsz) = intra_normalization...
                (FV(acm(j)+1:acm(j+1),(i-1)*FVsz+1:i*FVsz),K,D);
        end
    end
    nFV = yael_fvecs_normalize(single(nFV'))';
end
if powern
    nFV = power_normalization(nFV,0.5);
    nFV = yael_fvecs_normalize(single(nFV'))';
end

end
