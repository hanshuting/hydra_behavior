function [pprecision,precall,acr,cmat] = precisionrecall(predictedLabel,trueLabel)
% calculate precision, recall, accuracy and confusion matrix from the given
% true label and predicted label

% labelsetpredicted = unique(predictedLabel);
labelsettrue = unique(trueLabel);

pprecision = zeros(length(labelsettrue),1);
precall = zeros(length(labelsettrue),1);
acr = zeros(length(labelsettrue),1);
cmat = confusionmat(trueLabel,predictedLabel);

for i = 1:length(labelsettrue)
%     for j = 1:length(labelsetpredicted)
        
    TP = cmat(i,i);
    FN = sum(cmat(i,:))-cmat(i,i);
    FP = sum(cmat(:,i))-cmat(i,i);
    TN = sum(cmat(:))-TP-FP-FN;
    
    pprecision(i) = TP/(TP+FP);
    precall(i) = TN/(TN+FP);
    acr(i) = (TP+TN)/(TP+TN+FP+FN);
    
%         TP = sum(trueLabel==labelsettrue(i)&...
%             predictedLabel==labelsetpredicted(j));
%         FP = sum(trueLabel~=labelsettrue(i)&...
%             predictedLabel==labelsetpredicted(j));
%         TN = sum(trueLabel~=labelsettrue(i)&...
%             predictedLabel~=labelsetpredicted(j));
%         FN = sum(trueLabel==labelsettrue(i)&...
%             predictedLabel~=labelsetpredicted(j));
%         
%         cmat(i,j) = TP;
%         
%         if labelsettrue(i)==labelsetpredicted(j)
%             pprecision(i) = TP/(TP+FP);
%             precall(i) = TN/(TN+FP);
%             acr(i) = (TP+TN)/(TP+TN+FP+FN);
%         end
        
%     end
end

% figure;set(gcf,'color','w');
% imagesc(cmat);colorbar;title('confusion matrix');



end