function [histOnCenters] = assignToCenters(hists,numBins,calcMeth,inputCenters)

% assign histograms to the given codebook centers

% number of time windows
numTw = size(hists,1);

% number of cubes per time window
numCubes = size(hists,2)/numBins;

% extract all HOFs
all_HOF=reshape(hists',numBins,[])';

numCluster = size(inputCenters,1); % in case of empty centers

% number of nearest centers to take into account in histograms
softnum = round(numCluster/10);

% initialization
histOnCenters = zeros(numTw,numCluster);

% calculate pairwise distance between all samples and centers
switch calcMeth
    % euclidean kernel
    case 'euc'
        dists = pdist2(all_HOF,inputCenters);
    % exponential kernel
    case 'exp'
        dists = 1./exp(-pdist2(all_HOF,inputCenters)/2);
    % chi-square kernel (for histograms)
    case 'chi'
        chi_square = @(P,Q) nansum((ones(size(Q,1),1)*P-Q).^2./(2*(ones(size(Q,1),1)*P+Q)),2);
        dists = pdist2(all_HOF,inputCenters,@(P,Q)chi_square(P,Q));
        %dists = chiSquare(all_HOF,hofCenters);     
    otherwise
         error('error in assignHofCenters: calculation method invalid'); 
end

% sort by distance
[dists,keepInd] = sort(dists,2,'ascend');

% soft quantization
for i = 1:numTw
    for j = 1:numCubes
        % assign by weight (1/distance)
        tmp = (sum(dists((i-1)*numCubes+j,1:softnum),2)*ones(1,softnum))./dists((i-1)*numCubes+j,1:softnum);
        tmp = tmp/(sum(tmp,2));
        histOnCenters(i,keepInd((i-1)*numCubes+j,1:softnum)) = histOnCenters(keepInd((i-1)*numCubes+j,1:softnum))+tmp;
    end
    % normalization
    histOnCenters(i,:) = histOnCenters(i,:)./(sum(histOnCenters(i,:),2)*ones(1,numCluster));
end


end