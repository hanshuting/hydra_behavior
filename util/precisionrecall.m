function [acr_all,prc,rec,acr,cmat_nor,cmat] = precisionrecall(predictedLabel,trueLabel,numClass)
% [acr_all,prc,rec,acr,cmat_nor,cmat] = precisionrecall(predictedLabel,trueLabel,numClass)
% calculate precision, recall, accuracy and confusion matrix from the given
% true label and predicted label

% labelsetpredicted = unique(predictedLabel);
labelsettrue = 1:numClass;

prc = zeros(length(labelsettrue),1);
rec = zeros(length(labelsettrue),1);
acr = zeros(length(labelsettrue),1);
cmat = calcConfusionMat(trueLabel,predictedLabel,labelsettrue);
% cmat = confusionmat(trueLabel,predictedLabel);
% if size(cmat,1)<numClass
%     cmat(end+1:end+numClass-size(cmat,1),:) = 0;
%     cmat(:,end+1:end+numClass-size(cmat,2)) = 0;
% end

for i = 1:length(labelsettrue)
        
    TP = cmat(i,i);
    FN = sum(cmat(i,:))-cmat(i,i);
    FP = sum(cmat(:,i))-cmat(i,i);
    TN = sum(cmat(:))-TP-FP-FN;
    
    prc(i) = TP/(TP+FP);
    rec(i) = TN/(TN+FP);
    acr(i) = (TP+TN)/(TP+TN+FP+FN);

end

acr_all = sum(predictedLabel==trueLabel)/length(trueLabel);

% normalize confusion matrix by row
cmat_nor = cmat./(sum(cmat,2)*ones(1,size(cmat,2)));

end