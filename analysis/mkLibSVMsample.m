function [wei_str] = mkLibSVMsample(sample,percTrain,annoAll,savename,savepath)


% exclude 0 class
keepind = annoAll~=0;
numCubes = sum(keepind);
sample = sample(keepind,:);
label = annoAll(keepind);
labelset = unique(label);

% generate training and testing samples
numClass = length(labelset);
indx = randperm(numCubes);
numTraining = round(percTrain*numCubes);
numTest = numCubes-numTraining;
indxTrain = indx(1:numTraining)';
indxTest = indx(numTraining+1:end)';

figure;set(gcf,'color','w');
subplot(1,2,1);hist(label(indxTrain),[min(label):max(label)]+0.5);
title('training sample distribution');
xlabel('class');ylabel('number of samples');
subplot(1,2,2);hist(label(indxTest),[min(label):max(label)]+0.5);
title('testing sample distribution');
xlabel('class');ylabel('number of samples');

% save to files
fprintf('writing libSVM format data...\n');
%gnLibsvmFile(label,sample,[filepath filename '_annoType' num2str(annoType) '_all.txt']);
gnLibsvmFile(label(indxTrain),sample(indxTrain,:),[savepath savename '_train.txt']);
gnLibsvmFile(label(indxTest),sample(indxTest,:),[savepath savename '_test.txt']);
save([savepath savename '_svm_data.mat'],'label','sample','indxTrain','indxTest');

wei_str = [];
w = zeros(numClass,1);
for n = 1:numClass
    w(n) = numTraining/sum(label(indxTrain)==labelset(n));
    wei_str = [wei_str ' -w' num2str(labelset(n)) ' ' num2str(w(n))];
end
wei_str = wei_str(2:end);
fprintf('%s\n',wei_str);

end