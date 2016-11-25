function [softpred] = makeSoftPred(score)

softpred = zeros(size(score,1),3);

% sort by probability estimation
[scoreSorted,classSorted] = sort(score,2,'descend');
softpred(:,1) = classSorted(:,1);

% keep more than one prediction if within 2 fold difference
maxfold = 2;
softIndx2 = scoreSorted(:,1)./scoreSorted(:,2)<maxfold;
softpred(:,2) = classSorted(:,2).*softIndx2;
softIndx3 = scoreSorted(:,2)./scoreSorted(:,3)<maxfold;
softpred(:,3) = classSorted(:,3).*softIndx2.*softIndx3;
softpred(softpred==0) = NaN;

end