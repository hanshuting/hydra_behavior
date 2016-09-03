function [] = assign_mbhy_galois(arrayID)

% set parameters
rng(1000);
fileind = 1:13;
video_size = 5; % in seconds
trackThresh = 0.5;
trackLength = 10;
sampleStride = 5;

filepath = '/home/sh3276/work/results/dt_results_assembled/';
cdbkpath = '/home/sh3276/work/results/dt_cdbk/';
savepath = '/home/sh3276/work/results/dt_hists/';
infostr = ['_' num2str(video_size)...
    's_' num2str(trackThresh) '_L_' num2str(trackLength) '_W_' num2str(sampleStride)];

% file information
i = fileind(arrayID);    
movieParam = paramAll_galois(i);
time_step = movieParam.fr*video_size;

% load file
fprintf('loading sample: %s\n', movieParam.fileName);
load([filepath movieParam.fileName infostr '_mbhy.mat']);

% load codebook
fprintf('loading codebooke...\n');
load([cdbkpath 'mbhy_cdbk_step_' num2str(time_step) '.mat']);

% calculate histogram
fprintf('calculating histogram...\n');
histMbhy = assignMaskedCenters(mbhyAll,mbhyCenters,'exp');

% save result
save([savepath movieParam.fileName 'results_histMbhy_step_' num2str(time_step) '.mat'],'histMbhy','-v7.3');
    
end