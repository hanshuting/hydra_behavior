function [counts] = countMotif(seq,motifs)
% count the occurance of each motif in the given sequence
% seq: cell array
% motif: a matrix with motifs in rows


numMotif = size(motifs,1);
lmotif = size(motifs,2);
counts = zeros(numMotif,1);

for i = 1:length(seq)
    
    tmpar = seq{i};
    dims = length(tmpar);
    
    for j = 1:dims-lmotif+1
        for k = 1:numMotif
            if all(tmpar(j:j+lmotif-1)==motifs(k,:))
                counts(k) = counts(k)+1;
            end
        end
    end
end


end