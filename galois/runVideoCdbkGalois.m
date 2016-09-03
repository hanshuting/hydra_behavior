% script for generating codebooks from DT results

%% set parameters
fileIndx = [1:5,7:11,13:28,30:32];
%fileIndx = 401:414;
sampleStride = 5;
trackLength = 15;
timeStep = 50;
s=2;
t=3;
N=32;
datestr = '20151216_gfp_2';
infostr = ['L_' num2str(trackLength) '_W_' num2str(sampleStride) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];
filepath = ['/home/sh3276/work/results/dt_analysis/min_var0.5/' infostr '_' datestr '/'];
savepath = ['/home/sh3276/work/results/dt_vcdbk/min_var0.5/' infostr '_' datestr '/'];

% initialization
rng(1000);
numCenters = 1000;

infostr = ['L_' num2str(trackLength) '_W_' num2str(sampleStride) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];

%% load data
load([filepath infostr '_histAll.mat']);
data = histAll;

%% calculate codebook
fprintf('calculating codebook...\n');
vCenters = gnCdbk({data},size(data,2),numCenters);
save([savepath infostr '_vcdbk.mat'],'vCenters','-v7.3');

%% assign histograms
histVideoAll = zeros(length(fileIndx),size(vCenters,1));

for i = 1:length(fileIndx)
    fprintf('assigning sample %u...\n', i);
    histVideoAll(i,:) = assignMaskedCenters({data(acm(i)+1:acm(i+1),:)},vCenters,size(data,2),'exp');
end

save([savepath infostr '_vhsit.mat'],'histVideoAll','-v7.3');
