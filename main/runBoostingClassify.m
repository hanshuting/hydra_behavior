% script for classification with ensemble methods
% given data "sample", "label", "indxTraining", "indxTest"

%% generate training and test samples
dataTrain = sample(indxTraining,:);
labelTrain = label(indxTraining);
dataTest = sample(indxTest,:);
labelTest = label(indxTest);

%% train RUSBoost ensemble classifiers
numLearners = 1000;
templ = templateTree('MaxNumSplits',5);
tic;
ens = fitensemble(dataTrain,labelTrain,'RUSBoost',numLearners,...
    templ,'LearnRate',0.1,'nprint',100);
toc;

%% train subspace ensemble classifiers
numLearners = 500;
templ = templateTree('MinLeafSize',5);
tic;
ens = fitensemble(dataTrain,labelTrain,'subspace',numLearners,'KNN','nprint',100);
toc;

%% classification error with tree number
figure;
plot(loss(ens,dataTest,labelTest,'mode','cumulative'));
grid on;
xlabel('Number of trees');
ylabel('Test classification error');

%% prediction
tic;
predictedTest = predict(ens,dataTest);
toc;
accuracy = sum(predictedTest==labelTest)/length(labelTest);

%% cross validation - slow for boosting
cv = fitensemble(X,Y,'RUSBoost',numLearners,'Tree','kfold',5);
figure;
plot(loss(ens,dataTest,labelTest,'mode','cumulative'));
hold on;
plot(kfoldLoss(cv,'mode','cumulative'),'r.');
hold off;
xlabel('Number of trees');
ylabel('Classification error');
legend('Test','Cross-validation','Location','NE');



