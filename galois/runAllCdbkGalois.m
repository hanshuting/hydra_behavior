%script for generating codebooks from DT results

% set parameters
fileIndx = [1:5,7:11,13:28,30:32];
%fileIndx = 202:222;
%fileIndx = [1:5,7:11,13,16,20:21,23:25,28:31];
%fileIndx = [238,239];
%fileIndx = 401:414;
sampleStride = 2;
trackLength = 15;
timeStep = 25;
s = 2;
t = 3;
N = 32;
datestr = '20160130_registered';
infostr = ['L_' num2str(trackLength) '_W_' num2str(sampleStride) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];
%filepath = '/home/sh3276/work/results/dt_results_assembled/min_var0.5/';
filepath = ['/home/sh3276/work/results/dt_results_assembled/registered/' infostr '_' datestr '/'];
savepath = ['/home/sh3276/work/results/dt_cdbk/min_var0.5/' infostr '_' datestr '/'];

%initialization
rng(1000);
%setSeed(0);
numCenters = 1000;
numBins = 8;
numBinsHof = 9;
desc_all = {};

infostr = ['L_' num2str(trackLength) '_W_' num2str(sampleStride) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];

% assemble samplle
for i = 1:length(fileIndx)
    
    movieParam = paramAll_galois(fileIndx(i));
    fprintf('loading sample: %s\n', movieParam.fileName);
    
    filename = [movieParam.fileName '_' infostr '_'];

    load([filepath filename 'desc.mat']);
    numSample = length(desc);
    desc_all(end+1:end+numSample,:) = desc;   
     
end

%generate codebook
fprintf('calculating codebook...\n');
descCenters = gnCdbk(desc_all,numBinsHof+numBins*3,numCenters);
save([savepath 'desc_cdbk_' infostr '.mat'],'descCenters','-v7.3');

