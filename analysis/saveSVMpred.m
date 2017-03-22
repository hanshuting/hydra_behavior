function [pred,score,softpred] = saveSVMpred(filepath,filename)
% save libsvm format prediction results to mat format

% file to load
fload = [filepath filename '_pred.txt'];

% load result, get label order
predictionresult = dlmread(fload,' ',1,0);
fid = fopen(fload);
labelstr = textscan(fid,'%s',1,'delimiter','\n');
labelstr = labelstr{1}{1};
labelset = str2num(labelstr(8:end));
[~,indx] = sort(labelset,'ascend');

% save result
pred = predictionresult(:,1);
score = predictionresult(:,2:end);
score = score(:,indx);
% save([filepath filename '_pred.mat'],'pred','score');

% soft prediction
% keep at most 3 predictions
if size(score,2)>=3
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
else
    softpred = score;
end




end