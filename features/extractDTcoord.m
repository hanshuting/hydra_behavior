function [coordAll] = extractDTcoord(movieParam,filepath,L,W,N,nxy,nt)
% Extract dense trajectory features from DT output file
% SYNOPSIS:
%     [hofAll,hogAll,mbhxAll,mbhyAll] = extractDT(fileindx,timeStep)
% INPUT:
%     fileIndx: index of the file to be processed, one at a time (see fileinfo.m)
%     filepath: path of input files
%     timeStep: output time window size
%     nolen: maximum non-overlapping length of trajectory in a time window
% OUTPUT:
%     hofAll: a N-by-1 cell array, each cell contains the matrix of HOF
%       features in the time window. N is the number of total time windows
%     hogAll: a N-by-1 cell array with HOG features
%     mbhxAll: a N-by-1 cell array with MBHx features
%     mbhyAll: a N-by-1 cell array with MBHy features
% 
% Shuting Han, 2015

% DT parameters
sTraj = 2*L;
sCoord = 2*L;
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_'...
    num2str(nxy) '_t_' num2str(nt)];

% read file
dt_features = dlmread([filepath movieParam.fileName '_' infostr '.txt'],'\t',2,0);

% extract coordinates
T = movieParam.numImages-1;
coordAll = cell(T,1);
for i = 1:T
    coordAll{i} = dt_features(dt_features(:,1)==i+1,11+sTraj:10+sTraj+sCoord);
end

end