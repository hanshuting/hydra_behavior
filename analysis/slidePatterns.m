function [dists] = slidePatterns(m,n,step,tw,histFeatures,rawCenters,movieParam,tracksAll)

% slide a window through the data specified by movieParam and hydraParam
% and find the most similar cubes with the ones described by the given
% histogram features by comparing the histograms

% get tracking information
%tracksAll = processTracks(movieParam,hydraParam,m,n,step);

% initialize
%dists = zeros(size(histFeatures,1),floor(movieParam.numImages/step)-tw-1);
hists = zeros(floor(movieParam.numImages/step)-tw-1,size(histFeatures,2));

% slide window, calcualte all possible histograms
for i = 1:floor(movieParam.numImages/step)-tw-1
    
    % extract trajectories
    [~,twTracks] = extractTrackTw(tracksAll,m,n,tw,i);

    % calculate histogram feature for the given time window
    [twFlows,twFlowInd] = getFlows(twTracks,0);
    keepInd = (sum(twFlows==0,2)==0&sum(isnan(twFlows),2)==0);
    twFlows = twFlows(keepInd,:);
    twFlowInd = twFlowInd(keepInd,:);
    hists(i,:) = getCenterHist(twFlows,twFlowInd,ones(size(twFlows,1),1),rawCenters,m,n,'kcb_exp');

    % calculate histogram distance with the control histogram
    %distMat(j) = histChiSquare(twHist,histFeatures(i,:)); 
  
end

dists = chiSquare(histFeatures,hists);


end