% train svm on svm posteriors
rng(1000)

%% parameters
fileIndx = [1:5,7:11,13:24,26:28,30:32];
testIndx = [1,25,33,34];
timeStep = 25;
annoType = 5;
L = 15;
W = 5;
N = 32;
s = 1;
t = 3;
K = 256;
datestr = '20160229_spseg_3';
dopca = 1;
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s)...
    '_t_' num2str(t) '_step_' num2str(timeStep)];
filepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr '_K_' ...
    num2str(K) '_' datestr '/'];
savepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr '_K_' ...
    num2str(K) '_' datestr '/'];
annoPath = '/home/sh3276/work/data/annotations/';

%% load svm scores
% svm data
load([filepath infostr '_drFVall_annoType' num2str(annoType) '_svm_data.mat']);
numClass = length(unique(label));
[s,labelset] = system(sprintf('less %s%s_drFVall_annoType%s.model| grep label\n',...
    filepath,infostr,num2str(annoType)));
labelset = cell2mat(textscan(labelset(7:end),'%u'));
[~,labelIndx] = sort(labelset);

%% training predictions
filename = [infostr '_drFVall_annoType' num2str(annoType) '_training'];
predictionresult = dlmread([filepath filename '_prediction.txt'],' ',1,0);
predictedTest = predictionresult(:,1);
scoresTest = predictionresult(:,2:end);
scoresSorted = scoresTest(:,labelIndx);
save([filepath filename '_prediction.mat'],'predictedTest','scoresTest',...
    'scoresSorted','labelset');
gnLibsvmFile(label(indxTraining),scoresSorted,[filepath filename '_psvm.txt']);

%% test predictions
filename = [infostr '_drFVall_annoType' num2str(annoType) '_test'];
predictionresult = dlmread([filepath filename '_prediction.txt'],' ',1,0);
predictedTest = predictionresult(:,1);
scoresTest = predictionresult(:,2:end);
scoresSorted = scoresTest(:,labelIndx);
save([filepath filename '_prediction.mat'],'predictedTest','scoresTest',...
    'scoresSorted');
gnLibsvmFile(label(indxTest),scoresSorted,[filepath filename '_psvm.txt']);

%% save new sample predictions
for i = 1:length(testIndx)
    movieParam = paramAll_galois(testIndx(i));
    filename = [movieParam.fileName '_' infostr '_annoType5_drFV_all'];
    predictionresult = dlmread([filepath filename '_prediction.txt'],' ',1,0);
    predictedTest = predictionresult(:,1);
    scoresTest = predictionresult(:,2:end);
    scoresSorted = scoresTest(:,labelIndx);
    save([filepath filename '_prediction.mat'],'predictedTest','scoresTest','scoresSorted');
    
    annoRaw = annoMulti({movieParam},annoPath,timeStep,0);
    annoAll = mergeAnno(annoRaw,annoType);
    gnLibsvmFile(annoAll(annoAll~=0),scoresSorted,[filepath ...
         filename '_psvm.txt']);
end

