function [indx,dists] = findNeighbor(cc,pp,r)

% find the points given in pp that are within r distance to the given
% center cc and export in an ascending order

distsAll = pdist2(cc,pp);
indx = find(distsAll<r);
dists=distsAll(indx);
[dists,sortInd] = sort(dists,'ascend');
indx = indx(sortInd);

end