function [ndata] = intra_normalization(data,K,D)
% This function performs intra-normalization for FV with weight, mu and
% sigma statistics. Each FV is arranged as [weight, mu, sigma], with 
% dimensions [K, KD, KD]; in mu and sigma, features are arranged by their
% GMM index: [D, D, …, D].
% Shuting Han, 2016

ndata = zeros(size(data));

% normalize weight block
normw = sqrt(sum(data(:,1:K-1).^2,1));
ndata(:,1:K-1) = data(:,1:K-1)./(ones(size(data,1),1)*normw);

% normalize mu block
normmu = reshape(data(:,K:K+K*D-1),[],K);
normmu = repmat(sqrt(sum(normmu.^2,1)),D,1);
normmu = normmu(:)';
ndata(:,K:K+K*D-1) = data(:,K:K+K*D-1)./(ones(size(data,1),1)*normmu);

% normalize sigma block
norms = reshape(data(:,K+K*D:K+2*K*D-1),[],K);
norms = repmat(sqrt(sum(norms.^2,1)),D,1);
norms = norms(:)';
ndata(:,K+K*D:K+2*K*D-1) = data(:,K+K*D:K+2*K*D-1)./(ones(size(data,1),1)*norms);

% replace NaN
ndata(isnan(ndata)) = 0;

end