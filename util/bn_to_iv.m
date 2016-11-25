function [iv] = bn_to_iv(bn)
% convert binary type vector to interval data
% Shuting Han, 2016

bn = logical(bn);

vec = diff(bn);
if bn(1)==1
    vec(1) = 1;
end
if bn(end)==1
    vec(end) = -1;
end

iv = reshape(find(vec==1),[],1);
iv(:,2) = reshape(find(vec==-1),[],1);

end