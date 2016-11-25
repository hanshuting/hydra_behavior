function [intcorr,lag] = xcorr_intersect(a,b,maxlag)
% [intcorr,lag] = xcorr_intersect(a,b,maxlen)
% calculate intersection ratio of two vectors with a moving window

% check inputs
if nargin < 3
    maxlag = Inf;
end
if min(size(a))~=1 || min(size(b))~=1
    error('Inputs must be vectors');
elseif abs(round(maxlag))~=maxlag
    error('maxlen must be positive integers');
end

% make sure they're both column vectors
a = reshape(a,[],1);
b = reshape(b,[],1);

% calculate moving window size
mw = min(max(length(a),length(b)),maxlag);

% place the shorter one first, pad with zeros
[~,sarr] = min([length(a),length(b)]);
sarr = sarr(1);
ipt = cell(2,1);
ipt{1} = a;
ipt{2} = b;
ipt = ipt([sarr,setdiff(1:2,sarr)]);
ipt{1} = [ipt{1};zeros(mw-length(ipt{1}),1)];

intcorr = zeros(mw,1);
for n = 1:mw
    intcorr(n) = sum(ipt{1}(1:n)==ipt{2}(end-n+1:end))/n;
end
lag = (1:mw)-mw/2;

end