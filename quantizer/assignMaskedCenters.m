function [hists,assignment] = assignMaskedCenters(data,centers,lengthObs,meth)
% SYNOPSIS:
%     [hists,assignment] = assignMaskedCenters(data,centers,lengthObs,meth)
% INPUT:
%     data: a N-by-S cell matrix, N is the number of samples, S is the 
%       number of spatial-temporal patches. Each cell contains a matrix for the 
%       time window where rows are observations
%     centeres: codebook centers
%     lengthObs: length of each observation to cluster. It could be a
%       number that can be divided by size(data,2), or size(data,2)
%     meth: calculation method, euc/exp/chi kernel
% OUTPUT:
%     hists: assigned histograms
%     assignment: a cell matrix with the same size as data, containing the
%       assignment to the codebook centers
% 
% Shuting Han, 2015

%% some parameters, initialization
dims = size(data);
numCenters = size(centers,1);
% softnum = round(numCenters/20);
softnum = 5;

% chi-square kernel
chiSquare = @(P,Q) nansum((ones(size(Q,1),1)*P-Q).^2./(2*(ones(size(Q,1),1)*P+Q)),2);

% find the codebook center closest to zero
% cdbk_norms = sqrt(sum(centers.^2,2));
% zero_indx = cdbk_norms==min(cdbk_norms);

hists = zeros(dims(1),numCenters*dims(2));
assignment = cell(size(data));
%% calculate histograms
% go through samples
numObs = [];
for i = 1:dims(1)
    
    for j = 1:dims(2)
    
        twData = double(data{i,j});

        % exclude NaN values
        twData = twData(sum(isnan(twData),2)==0,:);
        
        % check if the input observation length is correct
        if ~isempty(twData) && isempty(numObs)
            if mod(size(twData,2),lengthObs)~=0
                error('Wrong sample length');
            end
            numObs = size(twData,2)/lengthObs;
        end
        
        numSample = size(twData,1);
        twData = reshape(twData',lengthObs,[])';
        
        % assign empty descriptors to zero center
        if isempty(twData)
            twHist = ones(1,numCenters)/numCenters;
            assignment{i,j} = NaN(1,numObs);
        else
            
            % calculate distance with the user-specified method
            switch meth
                case 'euc'
                    dists = pdist2(twData,centers);
                case 'exp'
                    dists = exp(pdist2(twData,centers)/2);
                case 'chi'
                    dists = pdist2(twData,centers,@(P,Q)chiSquare(P,Q));
                otherwise
                    error('invalid calculation method');
            end
   
            % sort with ascending distance
            [dists,keepIndx] = sort(dists,2,'ascend');
   
            % assign to centers by 1/distance
            twHist = zeros(1,numCenters);
            encoded = zeros(numSample,numObs);
            for k = 1:numSample
                for kk = 1:numObs
                    sampleHist = (sum(dists((k-1)*numObs+kk,1:softnum),2)*...
                        ones(1,softnum))./(dists((k-1)*numObs+kk,1:softnum)+1e-5);
                    sampleHist = sampleHist/sum(sampleHist,2);
                    if any(isnan(sampleHist))
                        fprintf('NaN value occurs at dims %u, %u, %u\n',i,j,k);
                    end
                    twHist(keepIndx(k,1:softnum)) = twHist(keepIndx(k,1:softnum))+sampleHist;
                    encoded(k,kk) = keepIndx(k,1);
                end
            end
            
        end
        
        assignment{i,j} = encoded;
        
        % normalization
        twHist = twHist/sum(twHist);
        hists(i,(j-1)*numCenters+1:j*numCenters) = double(twHist/dims(2));
%         hists(i,(j-1)*numCenters+1:j*numCenters) = twHist;
        
    end
    
end


end