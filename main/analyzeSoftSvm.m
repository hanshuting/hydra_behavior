% script for analyzing soft classification results
% assume that variable sample, label, indxTest, indxTraining,
% predictedTest, scoresTest has been loaded

%% label order from the model file (grep label)
labelset = [2 7 3 1 4 5 6]';

%% generate soft predictions
% keep at most 3 predictions
softPrediction = zeros(size(scoresTest,1),3);

% sort by probability estimation
[scoreSorted,classSorted] = sort(scoresTest,2,'descend');
softPrediction(:,1) = labelset(classSorted(:,1));

% keep more than one prediction if within 2 fold difference
maxfold = 2;
softIndx2 = scoreSorted(:,1)./scoreSorted(:,2)<maxfold;
softPrediction(:,2) = labelset(classSorted(:,2)).*softIndx2;
softIndx3 = scoreSorted(:,2)./scoreSorted(:,3)<maxfold;
softPrediction(:,3) = labelset(classSorted(:,3)).*softIndx2.*softIndx3;
softPrediction(softPrediction==0) = NaN;

%% accuracy and confusion matrix
trueLabel = label(indxTest);
numClass = length(unique(labelset));

% overall acuracy
acrSoft = sum(trueLabel==softPrediction(:,1)|trueLabel==softPrediction(:,2)|...
    trueLabel==softPrediction(:,3))/length(trueLabel);

% % confusion matrix
% cmat = zeros(numClass,numClass);
% for i = 1:numClass
%     for j = 1:numClass
%         cmat(i,j) = sum((trueLabel==i&softTest(:,1)==j)+...
%             (trueLabel==i&softTest(:,2)==j)+...
%             (trueLabel==i&softTest(:,3)==j));
%     end
% end
% 
% % visualize
% plotcmat(cmat);

%% use soft svm to describe somersaulting
% read annotation
fileind = 20;
annoType = 5;
timeStep = 25;
movieParam = paramAll(fileind);
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
annoRaw = annoMulti({movieParam},annoPath,timeStep,0);
annoAll = mergeAnno(annoRaw,4); % this scheme has a detaild ss description

% find somersaulting clips - manual check here
% ssind = find(annoAll==7|annoAll==8|annoAll==9);

% take out time window
sstw = floor(900/timeStep):floor(2100/timeStep); % file 20
%sstw = floor(2000/timeStep):floor(4562/timeStep); % file 21
%sstw = floor(1500/timeStep):floor(end/timeStep); % file 22
sspredict = softPrediction(sstw,:);

% make sentence
sspredict_word = cell(size(sspredict));
for i = 1:size(sspredict,1)
    for j = 1:size(sspredict,2)
        if ~isnan(sspredict(i,j))
            sspredict_word{i,j} = annoInfo(annoType,sspredict(i,j));
        end
    end
end

% print sentence
for i = 1:size(sspredict,1)
    fprintf('%s',sspredict_word{i,1});
    for j = 2:size(sspredict,2)
        if ~isnan(sspredict(i,j))
            fprintf('/%s',sspredict_word{i,j});
        end
    end
    if i~=size(sspredict,1)
        fprintf(' -> \n');
    else
        fprintf('\n');
    end
end


% visualize
makeAnnotatedMovie(sstw,sspredict,annoType,movieParam,timeStep,0.1,1);

