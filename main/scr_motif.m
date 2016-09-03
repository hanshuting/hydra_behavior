
fileInd = [1,2,3,4,5,7,8,9,10,11,13];
movieParamMulti = paramMulti(fileInd);

time_step = 5;
annoRaw = annoMulti(movieParamMulti,time_step,0);
annoAll = mergeAnno(annoRaw,1);

% generate data
anDataDt = cell(length(fileInd),1);
acm = zeros(length(fileInd)+1,1);
for i = 1:length(fileInd)
    acm(i+1) = acm(i)+floor(movieParamMulti{i}.numImages/time_step);
    tmpar = annoAll(acm(i)+1:acm(i+1));
    tmpar(tmpar==0) = numClass;
    tmpar = tmpar';
    anDataDt{i} = tmpar([1,diff(tmpar)]~=0);
end

%%
motifLength = 5;
motifs = generateMotif(anDataDt,motifLength);
numMotif = size(motifs,1);

% motif counts in true sequence
truecounts = countMotif(anDataDt,motifs);

% distribution in shuffled data
nshuff = 1000;
shuffcounts = zeros(nshuff,numMotif);
for i = 1:nshuff
    shuffData = cell(size(anDataDt));
    % go over all cells
    for j = 1:size(anDataDt,1)
        tmpar = anDataDt{j};
        shuffData{j} = tmpar(randperm(length(tmpar)));
    end
    shuffcounts(i,:) = countMotif(shuffData,motifs);
end

% test significance
p = zeros(numMotif,1);
critval = zeros(numMotif,1);
for i = 1:numMotif
    ccdist = fitdist(shuffcounts(:,i),'normal');
    %m(i) = mean(ccdist);
    critval(i) = icdf(ccdist,0.95);
    if critval(i) < truecounts(i)
        p(i)=1;
    end
end
p = logical(p);
sigInd = p&truecounts>5;

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

