function [] = hog_cdbk_galois(fileind)

% initialization
rng(1000);
numCenters = 1000;
hog_all = {};

% set parameters
video_size = 5; % in seconds
trackThresh = 0.5;
trackLength = 10;
sampleStride = 5;

filepath = '/home/sh3276/work/results/dt_results_assembled/';
infostr = ['_' num2str(video_size)...
        's_' num2str(trackThresh) '_L_' num2str(trackLength) '_W_' num2str(sampleStride)];

for i = 1:length(fileind)
    
    movieParam = paramAllDT_galois(fileind(i));
    time_step = movieParam.fr*video_size;
    
    fprintf('loading sample %s...\n',movieParam.fileName);
    load([filepath movieParam.fileName infostr '_hog.mat']);
    
    % store results
    numSample = length(hogAll);
    hog_all(end+1:end+numSample) = hogAll;
   
end

% calculate codebook
fprintf('calculating codebook...\n');
hogCenters = gnCdbk(hog_all,numCenters);
hogCenters = hogCenters(sum(isnan(hogCenters),2)==0,:);

fprintf('saving results...\n');
save(['/home/sh3276/work/results/dt_cdbk/hog_cdbk_step_' num2str(time_step) '.mat'],'hogCenters','-v7.3');

fprintf('done\n');
    
end