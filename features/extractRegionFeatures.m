function [rab,rregion,solidity] = extractRegionFeatures(regparam)

seg = regparam.segAll;
a = regparam.a;
b = regparam.b;

numRegions = 3;
numT = length(a);
rab = zeros(numT,1);
rregion = zeros(numT,numRegions);
solidity = zeros(numT,1);

for i = 1:numT
        
    % static features
    f_seg = seg(:,:,i);
    rab(i) = a(i)/b(i);
    rregion(i,:) = [sum(f_seg(:)==1),sum(f_seg(:)==2),sum(f_seg(:)==3)]/...
        sum(f_seg(:)~=0);
    rs = regionprops(double(f_seg==1|f_seg==2),'solidity');
    if isempty(rs)
        solidity(i) = NaN;
    else
        solidity(i) = struct2array(rs);
    end
    
end

end