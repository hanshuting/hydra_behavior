function [nFV] = encodeIndivSpFV(fileIndx,lfeat,filepath,gmmpath,namestr,...
    intran, powern)
% encode fisher vector for individual feature files

% load data
movieParam = paramAll_galois(fileIndx);
gmm = load([gmmpath namestr 'GMM.mat']);
load([gmmpath namestr 'Coeff.mat']);
data = load([filepath movieParam.fileName '_' namestr '.mat']);
data = struct2cell(data);
data = data{1};
data = cellfun(@double,data,'uniformoutput',false);
numPatch = size(data,2);

% get cell size
numSample = size(data,1);
fdims = cellfun('size',data(:,1),1);
fdimscum = cumsum(fdims)*numPatch;
fdimscum = [0;fdimscum];

% center data
data = cell2mat(data);
data(isnan(data)) = 1/lfeat;
%meanDesc = mean(data,1);
%data = data-repmat(meanDesc,size(data,1),1);

% reshape data
data = reshape(data',lfeat,[])';
meanDesc = mean(data,1);
dataCentered = data-repmat(meanDesc,size(data,1),1);

% pca and whitening
pcaData = single(dataCentered*coeff)';
pcaData = diag(1./sqrt(eigval))*pcaData;

% calculate FV
D = size(pcaData,1);
K = size(gmm.mu,2);
FVsz = D*K*2+K-1;
FV = zeros(FVsz*numPatch,numSample);
for i = 1:numSample
    for k = 1:numPatch
        FV((k-1)*FVsz+1:k*FVsz,i) = yael_fisher...
            (pcaData(:,fdimscum(i)+k:numPatch:fdimscum(i+1)),gmm.w,gmm.mu,...
            gmm.sigma,'sigma','weights','nonorm');
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
