function [sigMotif] = motifDiscovery(seq,motifLength,cthresh,nshuff)
% this function find motifs with the given length in the given sequence,
% and search for significant motif patterns using shuffled data as a
% control
% INPUT:
%     seq: a N*1 cell array, each cell has a one-dimensional observation
%     pattern sequence
%     motifLength: the length of desired motifs
%     cthresh: minimum number of occurance of the significant motifs
%     nshuff: number of shuffling times
% OUTPUT:
%     sigMotif: significant motif patterns


% initialization
rng('default');
rng(1000); % reset random generator
numSeq = length(seq);

% generate all possible motifs from the given sequence
motifs = generateMotif(seq,motifLength);
numMotif = size(motifs,1);

% motif counts in true sequence
truecounts = countMotif(seq,motifs);

% distribution in shuffled data
shuffcounts = zeros(nshuff,numMotif);
for i = 1:nshuff
    shuffSeq = cell(size(seq));
    % go over all cells
    for j = 1:numSeq
        tmpar = seq{j};
        shuffSeq{j} = tmpar(randperm(length(tmpar)));
    end
    shuffcounts(i,:) = countMotif(shuffSeq,motifs);
end

% test significance (95%)
p = zeros(numMotif,1);
critval = zeros(numMotif,1);
for i = 1:numMotif
    if all(shuffcounts(:,i)==0)
        critval(i) = 0;
        p(i) = 1;
    else
        ccdist = fitdist(shuffcounts(:,i),'normal');
        critval(i) = icdf(ccdist,0.95);
        if critval(i) < truecounts(i)
            p(i)=1;
        end
    end
end
p = logical(p);
sigInd = p&truecounts>cthresh;

sigMotif = motifs(sigInd,:);

% plot
figure;plot(truecounts)
hold on;plot(critval,'r')
hold on;plot([0,numMotif],[5,5],':','color','r')
xlim([0 numMotif])
set(gcf,'color','w');
xlabel('motif index')
ylabel('count')
legend('true data','shuffled data','threshold')

end