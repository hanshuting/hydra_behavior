% script for doing temporal smoothing with HMM

%% assume that we've loaded a dataset with variables "label", "scoresTest", "acm"
labelset = [3 7 1 4 6 2 5]';

%% ------------ strategy 1: train up k HMM classifiers-------------%
annoType = 5;
timeStep = 25;
fileind = [1:5,7:11,13:24,26:28,30:32];
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';

% modify number of frames
movieParamMulti = paramMulti(fileind);
for i = 1:length(fileind)
    movieParamMulti{i}.numImages = (acm(i+1)-acm(i))*timeStep;
end

% generate annotations
annoRaw = annoMulti(movieParamMulti,annoPath,timeStep,0);
label = mergeAnno(annoRaw,annoType);

%% generate training data

% % keep only top three possible states
% maxfold = 1.5;
% dims = size(scoresTest);
% softMask = zeros(dims(1)*dims(2),1);
% [scoreSorted,classSorted] = sort(scoresTest,2,'descend');
% softIndx2 = scoreSorted(:,1)./scoreSorted(:,2)<maxfold;
% softIndx3 = scoreSorted(:,2)./scoreSorted(:,3)<maxfold;
% softMask(sub2ind(dims,(1:dims(1))',classSorted(:,1))) = 1;
% softMask(sub2ind(dims,find(softIndx2),classSorted(softIndx2,2))) = 1;
% softMask(sub2ind(dims,find(softIndx3),classSorted(softIndx3,3))) = 1;
% softMask = reshape(softMask,dims(1),dims(2));
% softScoresTrain = scoresTest.*softMask;
% softScoresTrain(softScoresTrain==0) = 0.001;

% initialize
twTrain = 3;
numSample = length(acm)-1;
numClass = length(labelset);
dataTrain = cell(numClass,1);

% process each sample individually
for i = 1:numSample
    
%     numTrain = round(0.9*(acm(i+1)-acm(i)));
    numTrain = acm(i+1)-acm(i);
    
    % find consequtive sequences
    seqs = findseq(label(acm(i)+1:acm(i)+numTrain));
    
    % use sequences longer than twTrain for HMM training
    for j = 1:numClass
        crSeqs = seqs(seqs(:,1)==j & seqs(:,4)>=twTrain,:);
        if ~isempty(crSeqs)
            for k = 1:size(crSeqs,1)
                crData = dataTrain{j,1};
                crData{end+1} = scoresTest(crSeqs(k,2)+acm(i):crSeqs(k,3)+acm(i),:)';
%                 crData{end+1} = softScoresTrain(crSeqs(k,2)+acm(i):crSeqs(k,3)+acm(i),:)';
                dataTrain{j,1} = crData;
            end
        end
    end
        
end

% transpose data
dataTrain = cellfun(@transpose,dataTrain,'uniformoutput',false);

%% fit model
% parameters
setSeed(0);
nstates = 1;
models = cell(numClass,1);

% fit a classifier for each class
for i = 1:numClass
    
    % random initialization
    pi0 = normalise(rand(nstates,1));
    transmat0 = mkStochastic(rand(nstates,nstates));

    % fit model
    fitArgs = {'pi0',pi0,'trans0',transmat0,'nRandomRestarts',3};
    models{i} = hmmFit(dataTrain{i,:},nstates,'gauss',fitArgs{:});
    
end

%% predict
% assume a new dataset with variable "scoresTest" and "predictedTest" has
% been loaded

% load true labels
fileind = 33;
annoType = 3;
timeStep = 15;
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
movieParam = paramAll(fileind);
annoRaw = annoMulti({movieParam},annoPath,timeStep,0);
annoAll = mergeAnno(annoRaw,annoType);
keepind = annoAll~=0;
testAcr = sum(annoAll(keepind)==predictedTest(keepind))/sum(keepind); 

% keep only top three possible states
maxfold = 2;
dims = size(scoresTest);
softMask = zeros(dims(1)*dims(2),1);
[scoreSorted,classSorted] = sort(scoresTest,2,'descend');
softMask(sub2ind(dims,(1:dims(1))',classSorted(:,1))) = 1;
softIndxPrev = ones(dims(1),1);
for i = 1:dims(2)-1
    softIndx = scoreSorted(:,i)./scoreSorted(:,i+1)<maxfold;
    softIndxPrev = softIndxPrev*softIndx;
    softMask(sub2ind(dims,find(softIndx),classSorted(softIndx,i+1))) = 1;
end
softMask = reshape(softMask,dims(1),dims(2));
softScores = scoresTest.*softMask;
softScores(softScores==0) = NaN;

% slide a window, calculate likelihood at each time point
windowsz = 10;
hmmPredicted = zeros(size(scoresTest,1)-windowsz,1);
loglik = zeros(size(scoresTest));
for i = 1:size(scoresTest,1)-windowsz;
    for j = 1:numClass
        loglik(i,j) = hmmLogprob(models{j},{scoresTest(i:i+windowsz,:)'});
    end
%     hmmPredicted(i) = labelset(loglik(i,:)==max(loglik(i,:)));
end
[~,hmmPredicted] = nanmax(loglik.*softScores,[],2);
hmmPredicted = labelset(hmmPredicted);

% accuracy after smoothing
hmmAcr = sum(annoAll(keepind(1:end-windowsz))==hmmPredicted(keepind...
    (1:end-windowsz)))/length(hmmPredicted(keepind(1:end-windowsz)));

% plot
figure;set(gcf,'color','w')
plot(annoAll,'k');
hold on;plot(predictedTest,'b','linestyle',':');
plot(hmmPredicted,'r','linestyle',':')
legend('true','SVM prediction','HMM smoothed')

%% ----------------- strategy 2: global transition matrix----------------%

%% generate training sample
% set parameters
savepath = 'C:\Shuting\Data\yeti\classification\svm_m_2_n_2_step_5_20151115\';
labelset = [4 5 3 2 1 9 6 8 7];

% generate training sample
numSample = length(acm)-1;
numClass = length(labelset);
dataTrain = cell(numSample,1);
labelTrain = cell(numSample,1);

% process each sample individually
for i = 1:numSample
    
    numTrain = round(0.9*(acm(i+1)-acm(i)));
    crData = zeros(numClass,numTrain);
    % correct output order
    for j = 1:numClass
        crData(j,:) = scoresTest(acm(i)+1:acm(i)+numTrain,labelset(j))';
    end
    dataTrain{i} = crData;
    labelTrain{i} = reshape(label(acm(i)+1:acm(i)+numTrain),1,[]);
end

% estimate transition matrix
modelAll = hmmFitFullyObs(labelTrain,dataTrain,'gauss');

% save model
save([savepath '_hmm_transmat.mat'],'modelAll');

%% smooth predictions
% assume another dataset with variable "scoresTest" and "predictedTest" has been loaded
tol = 0.1;
A = modelAll.A;
[~,initState] = max(A(:,predictedTest(1)));
predictedCur = [initState;predictedTest];

% iterate until convergence - convergence not guaranteed
while true
    
    predictedPrev = predictedCur;
    probEst = zeros(size(scoresTest));
    
    % correct order
    for i = 1:length(labelset)
        probEst(:,i) = scoresTest(:,labelset(i))*...
            A(predictedPrev(i),predictedPrev(i+1));
    end
    
    % update estimation
    [~,predictedCur] = max(probEst,[],2);
    predictedCur = [initState;predictedCur];
    
    % stop if converges
    resd = sum(predictedCur~=predictedPrev)/length(predictedPrev);
    fprintf('%f\n',resd);
    if resd < tol
        break;
    end
    
end

%% ----------- strategy 3: trans mat on labels + SVM prob -------------- %%

labelset = [3 7 1 4 6 2 5]';
%% generate training sample
% load annotations
annoType = 5;
timeStep = 25;
fileind = [1:5,7:11,13:24,26:28,30:32];
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
movieParamMulti = paramMulti(fileind);
for i = 1:length(fileind)
    movieParamMulti{i}.numImages = (acm(i+1)-acm(i))*timeStep;
end
annoRaw = annoMulti(movieParamMulti,annoPath,timeStep,0);
label = mergeAnno(annoRaw,annoType);

% initialize
numSample = length(acm)-1;
numClass = length(labelset);
labelTrain = cell(numSample,1);

% process each sample individually
for i = 1:numSample
    crLabel = label(acm(i)+1:acm(i+1));
    crLabel = crLabel(crLabel~=0);
    labelTrain{i} = reshape(crLabel,1,[]);
end

%% fit model
setSeed(0);
nstates = numClass;

% priors
pi0 = normalise(rand(nstates,1));
transmat0 = mkStochastic(rand(nstates,nstates));

% fit model
fitArgs = {'pi0',pi0,'trans0',transmat0,'nRandomRestarts',3};
model = hmmFit(labelTrain,nstates,'discrete',fitArgs{:});

%% predict
% load ground truth
fileind = 33;
annoType = 5;
timeStep = 25;
annoPath = 'C:\Shuting\Data\freely_moving\individual_samples\annotations\';
movieParam = paramAll(fileind);
annoRaw = annoMulti({movieParam},annoPath,timeStep,0);
annoAll = mergeAnno(annoRaw,annoType);
keepind = annoAll~=0;
testAcr = sum(annoAll(keepind)==predictedTest(keepind))/sum(keepind); 

% order scores
[~,seqord] = sort(labelset);
scoresOrdered = scoresTest(:,seqord);

% make soft prediction
maxfold = 3;
maxprd = 5;
softPrediction = zeros(size(scoresOrdered,1),maxprd);
[scoreSorted,classSorted] = sort(scoresOrdered,2,'descend');
softPrediction(:,1) = classSorted(:,1);
softIndxPrev = ones(size(scoreSorted,1),1);
for i = 2:maxprd
    softIndx = scoreSorted(:,i-1)./scoreSorted(:,i)<maxfold;
    softPrediction(:,i) = classSorted(:,i).*softIndx.*softIndxPrev;
    softIndxPrev = softIndxPrev.*softIndx;
end
softPrediction(softPrediction==0) = NaN;

% take the prediction from the first 5 svm results
startseqlen = 3;
windowsz = 3;

% initialize
logprob = zeros(size(scoresTest,1)-startseqlen,size(scoresTest,2));
updPredict = zeros(size(predictedTest));
updPredict(1:startseqlen) = predictedTest(1:startseqlen);
updPredict = reshape(updPredict,1,[]);

% hmm predictions
[grid1,grid2,grid3] = ndgrid(1:length(labelset),1:length(labelset),1:length(labelset));
testseq = [grid1(:),grid2(:),grid3(:)];
% [grid1,grid2,grid3,grid4,grid5] = ndgrid(1:length(labelset),1:length(labelset),...
%     1:length(labelset),1:length(labelset),1:length(labelset));
% testseq = [grid1(:),grid2(:),grid3(:),grid4(:),grid5(:)];
predmat = nan(size(scoresTest,1)-startseqlen,size(scoresTest,1));
for i = 1:size(scoresTest,1)-startseqlen
    probseq = zeros(size(testseq,1),1);
    startindx = startseqlen+i;
    endindx = min(startseqlen+i+windowsz-1,size(scoresTest,1));
    for j = 1:size(testseq,1)
        [~,probseq(j)] = hmmInferNodes(model,testseq(j,:));
        pathindx = sub2ind(size(scoresOrdered),(startseqlen+i:endindx)',testseq(j,1:endindx-startindx+1)');
        probseq(j) = exp(probseq(j))*prod(scoresOrdered(pathindx));
    end
    [~,maxindx] = max(probseq);
    predmat(i,startindx:endindx) = testseq(maxindx(1),1:endindx-startindx+1);
%     updPredict(i+startseqlen) = testseq(maxindx(1),1);
%     for j = 1:size(scoresTest,2)
%         [~,logprob(i,j)] = hmmInferNodes(model,...
%             [updPredict(max(1,i+startseqlen-windowsz):i+startseqlen-1),j]);
%     end
%     softprd = softPrediction(i+startseqlen,:);
%     softprd = softprd(~isnan(softprd));
% %     [~,updPredict(i+startseqlen)] = max(logprob(i,softprd));
%     [~,updPredict(i+startseqlen)] = max(exp(logprob(i,softprd)).*scoresOrdered(i,softprd));
%     updPredict(i+startseqlen) = softprd(updPredict(i+startseqlen));
end

% take the most frequent prediction
updPredict(startseqlen+1:end) = mode(predmat,2);

% if no value occured twice, take the label with best svm prob
predcell = mat2cell(predmat,size(predmat,1),ones(size(predmat,2),1));
upred = cellfun(@unique,predcell,'UniformOutput',false);
nanindx = cellfun(@isnan,upred,'UniformOutput',false);
upred = cellfun(@(data,nanindx) data(~nanindx),upred,nanindx,'UniformOutput',false);
nonuniques = find(cellfun(@length,upred)==3);
for i = 1:length(nonuniques)
    [~,updPredict(nonuniques(i))] = max(scoresOrdered(nonuniques(i),upred{nonuniques(i)}));
end

% accuracy after smoothing
hmmAcr = sum(annoAll(keepind)==updPredict(keepind)')/sum(keepind);

% plot
figure;set(gcf,'color','w')
plot(annoAll,'k');
hold on;plot(predictedTest,'b','linestyle',':');
plot(updPredict,'r','linestyle',':')
legend('true','SVM prediction','HMM smoothed')
box off
xlabel('frame');ylabel('behavior state')

