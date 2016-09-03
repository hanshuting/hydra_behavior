% this script trains a HMM model on the given discrete behavior label
% sequences

%% train discrete HMM on annotations
% initialization
setSeed(0);
fileInd = [1:5,6:22];
movieParamMulti = paramMulti(fileInd);
nrestarts = 5;
nHidStates = 7;
time_step = 5;
numSample = length(fileInd);

% load annotations
annoRaw = annoMulti(movieParamMulti,time_step,0);
annoAll = mergeAnno(annoRaw,1);
numClass = length(unique(annoAll));

% put annotation labels together
anData = cell(numSample,1);
anDataDt = cell(numSample,1);
acm = zeros(numSample+1,1);
for i = 1:numSample
    acm(i+1) = acm(i)+floor(movieParamMulti{i}.numImages/time_step);
    tmpar = annoAll(acm(i)+1:acm(i+1));
    tmpar(tmpar==0) = numClass;
    tmpar = tmpar';
    anData{i} = tmpar;
    anDataDt{i} = tmpar([1,diff(tmpar)]~=0);
end

% train annotation model
modelAnno = hmmFit(anData, nHidStates, 'discrete', ...
    'convTol', 1e-5, 'nRandomRestarts', nrestarts, 'verbose', false);
modelAnnoDt = hmmFit(anDataDt, nHidStates, 'discrete', ...
    'convTol', 1e-5, 'nRandomRestarts', nrestarts, 'verbose', false);

%% direct calculation of transition matrix

labelset = unique(annoAll(annoAll~=0)); % exclude 0 class
Tmat = zeros(length(labelset),length(labelset));
for i = 1:numSample
    tmpar = anDataDt{i};
    for j = 1:length(tmpar)-1
        currentlabel = find(labelset==tmpar(j));
        nextlabel = find(labelset==tmpar(j+1));
        Tmat(currentlabel,nextlabel) = Tmat(currentlabel,nextlabel)+1;
    end
end

% plot
adjmat = Tmat>0;
% generate node names and colors
nodenames = {'S','E','TS','BS','BD','C','TC','SS','F'};
% generate edges: lighter colors stand for smaller values
edgecolor = cell(sum(adjmat(:)),3);
count = 0;
for i = 1:size(Tmat,1)
    for j = 1:size(Tmat,2)
        if adjmat(i,j)~=0
            count = count+1;
            edgecolor{count,1} = nodenames{i};
            edgecolor{count,2} = nodenames{j};
            edgecolor{count,3} = [1,1,1]-Tmat(i,j)/max(Tmat(:))*[0.9,0.9,0.5];
        end
    end
end
graphViz4Matlab('-adjMat',Tmat>0,'-layout',Circlelayout,'-edgeColors',...
    edgecolor,'-nodeLabels',nodenames);

% conditional transition matrix
CTmat = Tmat./(sum(Tmat,2)*ones(1,size(Tmat,2)));
adjmat = CTmat>0;
nodenames = {'S','E','TS','BS','BD','C','TC','SS','F'};
edgecolor = cell(sum(adjmat(:)),3);
count = 0;
for i = 1:size(Tmat,1)
    for j = 1:size(Tmat,2)
        if adjmat(i,j)~=0
            count = count+1;
            edgecolor{count,1} = nodenames{i};
            edgecolor{count,2} = nodenames{j};
            edgecolor{count,3} = [1,1,1]-CTmat(i,j)*[0.9,0.9,0.5];
        end
    end
end
graphViz4Matlab('-adjMat',CTmat>0,'-layout',Circlelayout,'-edgeColors',...
    edgecolor,'-nodeLabels',nodenames);

%% full conditional transition matrix
labelsetFull = unique(annoRaw(annoRaw~=1000)); % exclude 0 class
TmatFull = zeros(length(labelsetFull),length(labelsetFull));
for i = 1:length(fileInd)
    tmpar = annoRaw(acm(i)+1:acm(i+1));
    tmpar(tmpar==0) = numClass;
    tmpar = tmpar';
    tmpar = tmpar([1,diff(tmpar)]~=0);
    for j = 1:length(tmpar)-1
        currentlabel = find(labelsetFull==tmpar(j));
        nextlabel = find(labelsetFull==tmpar(j+1));
        TmatFull(currentlabel,nextlabel) = TmatFull(currentlabel,nextlabel)+1;
    end
end

CTmatFull = TmatFull./(sum(TmatFull,2)*ones(1,size(TmatFull,2)));

% plot
adjmat = CTmatFull>0;
edgecolor = cell(sum(adjmat(:)),3);
nodenamesFull = {'S','Sc','St','Sb','Sf','ESTs','EBs','Es','ETt','ETs','Rt',...
    'Rs','BD','rBD','SWBt','SWBs','SWTs','SD','SWTt','SWBb','CSTt','CSTs',...
    'CBs','Cs','Ct','CBt','SSEs','SSSs','SSUD','SSB','Bbd','Cbd','Ftw','Fbf','Fmo'};
count = 0;
for i = 1:size(CTmatFull,1)
    for j = 1:size(CTmatFull,2)
        if adjmat(i,j)~=0
            count = count+1;
            edgecolor{count,1} = nodenamesFull{i};
            edgecolor{count,2} = nodenamesFull{j};
            edgecolor{count,3} = [1,1,1]-CTmatFull(i,j)*[0.9,0.9,0.5];
        end
    end
end
graphViz4Matlab('-adjMat',CTmatFull>0,'-layout',Circlelayout,'-edgeColors',...
    edgecolor,'-nodeLabels',nodenamesFull);

%% visualize A and T
modeltoplot = modelAnnoDt;

figure;
set(gcf,'color','w','Position',[600 600 1200 400]);
subplot(1,2,1);
imagesc(modeltoplot.A);title('Transition probability');colorbar;
xlabel('hidden state');ylabel('hidden state');
subplot(1,2,2);
imagesc(modeltoplot.emission.T);title('Emission probability');colorbar;
xlabel('observation state');ylabel('hidden state');

%% plot diagram
pthresh = 0.01;
pmat = [modeltoplot.A,modeltoplot.emission.T];
pmat(end+1:size(pmat,2),:) = 0;
pmat(pmat<pthresh) = 0;
adjmat = double(pmat~=0);
dims = size(adjmat,1);

% generate node names and colors
nodenames = cell(1,dims);
nodecolors = cell(1,dims);
for i = 1:dims
    if i <= nHidStates
        nodenames{i} = ['H' num2str(i)];
        nodecolors{i} = [0.9,0.95,1]-pmat(i,i)*[0.6,0.4,0.2];
    else
        nodenames{i} = ['O' num2str(i-nHidStates)];
        nodecolors{i} = [0.95,0.9,0.7];
    end
end

% generate edges: lighter colors stand for smaller values
edgecolor = cell(sum(adjmat(:)),3);
count = 0;
for i = 1:dims
    for j = 1:dims
        if adjmat(i,j)~=0
            count = count+1;
            edgecolor{count,1} = nodenames{i};
            edgecolor{count,2} = nodenames{j};
            edgecolor{count,3} = [1,1,1]-pmat(i,j)*[0.9,0.9,0.5];
        end
    end
end

graphViz4Matlab('-adjMat',adjmat,'-layout',Circlelayout,'-edgeColors',...
    edgecolor,'-nodeLabels',nodenames,'-nodeColors',nodecolors);
