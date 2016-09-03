function [spDescriptor] = assignSpatialDescriptor(descriptor,spInd)
% [spDescriptor] = assignSpatialDescriptor(descriptor,keepInd,spInd)
% generate spatio-temporal descriptors using spInd

tt = size(descriptor,1);
numPatch = max(spInd{1});
spDescriptor = cell(tt,numPatch);

for i = 1:tt
    tw_d = descriptor{i};
%     tw_ki = keepInd{i};
%     tw_ki = true(size(spInd{i}));
    tw_spind = spInd{i};
    for k = 1:numPatch
        tw_patch = tw_d(tw_spind==k,:);
        spDescriptor{i,k} = tw_patch;
    end
end
    

end