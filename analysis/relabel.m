function [new_label] = relabel(label, seq)

% seq: seq(i)=j, i in previous label corresponds to j in new label

inds = zeros(size(label,1),size(seq,2));
for i = 1:size(seq,2)
    inds(:,i) = label==i;
end

inds = logical(inds);

new_label = zeros(size(label));
for i = 1:size(seq,2)
   new_label(inds(:,i)) = seq(i);
end


end