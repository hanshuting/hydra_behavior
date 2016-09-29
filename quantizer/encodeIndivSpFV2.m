function [nFV] = encodeIndivSpFV2(fileIndx,filepath,fvparam)
% encode fisher vector for individual feature files

% parse input parameter structure
intran = fvparam.intran;
powern = fvparam.powern;
namestr = fvparam.namestr;
lfeat = fvparam.lfeat;
gmmpath = fvparam.gmmpath;

% load data
fname = fileinfo(fileIndx);
gmm = load([gmmpath namestr 'GMM.mat']);
load([gmmpath namestr 'Coeff.mat']);
data = load([filepath fname '_' namestr '.mat']);
data = struct2cell(data);
data = data{1};
data = cellfun(@double,data,'uniformoutput',false);
numPatch = size(data,2);
numSample = cellfun('size',data,1);
fdims = reshape(numSample',1,[])';

crData = cell(size(data));
meanDesc = nanmean(cell2mat(data(:)),1);
for j = 1:numPatch
    datamat = cell2mat(data(:,j));
    datamat(isnan(datamat)) = 1/lfeat;
%     dataCentered = datamat-repmat(meanDesc,size(datamat,1),1);
    dataCentered = datamat-repmat(mean(datamat,1),size(datamat,1),1);
    crData(:,j) = mat2cell(dataCentered,numSample(:,j),lfeat);
end

numSample = size(crData,1);
data = cell2mat(reshape(crData',1,[])');

% get cell size
fdimscum = cumsum(fdims);
fdimscum = [0;fdimscum];

% pca and whitening
pcaData = single(data*coeff)';
pcaData = diag(1./sqrt(eigval))*pcaData;

% calculate FV
D = size(pcaData,1);
K = size(gmm.mu,2);
FVsz = D*K*2+K-1;
FV = zeros(FVsz*numPatch,numSample);
for i = 1:numSample
    for k = 1:numPatch
        FV((k-1)*FVsz+1:k*FVsz,i) = yael_fisher...
            (pcaData(:,fdimscum((i-1)*numPatch+k)+1:...
            fdimscum((i-1)*numPatch+k+1)),...
            gmm.w,gmm.mu,gmm.sigma,'sigma','weights','nonorm');
    end
end

% intra-, power and L2 normalization
FV = FV';
nFV = FV;
if intran
    for i = 1:numPatch
        nFV(:,(i-1)*FVsz+1:i*FVsz) = intra_normalization(FV(:,(i-1)*FVsz+1:i*FVsz),K,D);
    end
    nFV = yael_fvecs_normalize(single(nFV'))';
end
if powern
    nFV = power_normalization(nFV,0.5);
    nFV = yael_fvecs_normalize(single(nFV'))';
end

end
