function [dataCoeff,w,mu,sigma,nFV,eigval,acm] = encodeSpFV2(fileIndx,...
    filepath,fvparam)
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
dataAll = [];
acm = zeros(length(fileIndx)+1,1);
fdims = [];
for i = 1:length(fileIndx)

    fname = fileinfo(fileIndx(i));
    fprintf('loading sample: %s\n', fname);

    data = load([filepath fname '_' namestr '.mat']);
    data = struct2cell(data);
    data = data{1};
    data = cellfun(@double,data,'uniformoutput',false);
    
    if i==1
        lfeat = size(data{1,1},2);
        numPatch = size(data,2);
    end
    
    numSample = cellfun('size',data,1);
    fdims(end+1:end+length(numSample(:))) = reshape(numSample',1,[])';
    acm(i+1) = acm(i)+size(numSample,1);
    
    crData = cell(size(data));
%     meanDesc = nanmean(cell2mat(data(:)),1);
    for j = 1:numPatch
        datamat = cell2mat(data(:,j));
        datamat(isnan(datamat)) = 1/lfeat;
%         dataCentered = datamat-repmat(meanDesc,size(datamat,1),1);
        dataCentered = datamat-repmat(mean(datamat,1),size(datamat,1),1);
        crData(:,j) = mat2cell(dataCentered,numSample(:,j),lfeat);
    end
    
    dataAll(end+1:end+sum(numSample(:)),:) = cell2mat(reshape(crData',1,[])');
end

D = round(lfeat/2);
numSample = size(dataAll,1);

% get sample size in each file
fdimscum = cumsum(fdims);
fdimscum = [0,fdimscum];

% keep 1/2 original dimensions with pca
fprintf('pca...\n');
nsub = 1e6;
if numSample > nsub
    subindx = randperm(numSample,nsub);
else
    subindx = true(numSample,1);
end
% meanDesc = mean(dataAll,1);
% dataAllCentered = dataAll-repmat(meanDesc,numSample,1);
% [~,dataCoeff,eigval] = yael_pca(dataAllCentered(subindx,:)',D,0,0);
% pcaData = single(dataAllCentered*dataCoeff)';
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
    for k = 1:numPatch % check here
        FV((k-1)*FVsz+1:k*FVsz,j) = yael_fisher...
            (pcaData(:,fdimscum((j-1)*numPatch+k)+1:...
            fdimscum((j-1)*numPatch+k+1)),...
            w,mu,sigma,'sigma','weights','nonorm');
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
