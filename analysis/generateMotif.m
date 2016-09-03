function [motifs] = generateMotif(seq,lmotif)
% find all possible motifs with length lmotif in the given sequence
% seq: a cell array
% lmotif: positive integer, larger than 1

motifs = zeros(1,lmotif);
for i = 1:length(seq)
    tmpar = seq{i};
    dims = length(tmpar);
    for j = 1:dims-lmotif+1
        if ~ismember(tmpar(j:j+lmotif-1),motifs,'rows')
            motifs(end+1,:) = tmpar(j:j+lmotif-1);
        end
    end
end

motifs = motifs(2:end,:);

end