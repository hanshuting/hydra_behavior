function [sm_pred] = smooth_prediction(pred,tw)
% smooth prediction by taking the mode of predicted values in the given
% time window 

tw_half = round((tw-1)/2);
sm_pred = zeros(size(pred));
T = length(pred);

for n = 1:T
    tstart = max([1,n-tw_half]);
    tend = min([n+tw_half,T]);
    sm_pred(n) = mode(pred(tstart:tend));
end

end