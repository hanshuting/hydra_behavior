function [acr_all,prc,rec,acr,cmat] = precisionrecall(predictedLabel,trueLabel,numClass)
% calculate precision, recall, accuracy and confusion matrix from the given
% true label and predicted label

% labelsetpredicted = unique(predictedLabel);
labelsettrue = 1:numClass;

prc = zeros(length(labelsettrue),1);
rec = zeros(length(labelsettrue),1);
acr = zeros(length(labelsettrue),1);
cmat = confusionmat(trueLabel,predictedLabel);

for i = 1:length(labelsettrue)
%     for j = 1:length(labelsetpredicted)
        
    TP = cmat(i,i);
    FN = sum(cmat(i,:))-cmat(i,i);
    FP = sum(cmat(:,i))-cmat(i,i);
    TN = sum(cmat(:))-TP-FP-FN;
    
    prc(i) = TP/(TP+FP);
    rec(i) = TN/(TN+FP);
    acr(i) = (TP+TN)/(TP+TN+FP+FN);

end

acr_all = sum(predictedLabel==trueLabel)/length(trueLabel);

end