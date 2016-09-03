function [] = dt_hog_cdbk_yeti(video_size,trackLength,trackThresh,sampleStride)

% set parameters
fileInd = 1;

% initialization
rng(1000);
numCenters = 1000;
hog_all = {};

for i = fileInd
    
    movieParam = paramAllDT_yeti(i);
    fprintf('loading sample: %s\n', movieParam.fileName);
    
    savename = ['/vega/brain/users/sh3276/results/DT/' ...
        movieParam.fileName '_' num2str(video_size) 's_' num2str(trackThresh)...
        '_L_' num2str(trackLength) '_W_' num2str(sampleStride) '_'];
    
    load([savename 'hog.mat']);
    fprintf('file %u is loaded\n',i);

    % store results
    numSample = length(hogAll);
    hog_all(end+1:end+numSample) = hogAll;
    fprintf('file %u is done\n',i);    
     
end

hog_all = hog_all';
hogCenters = gnCdbk(hog_all,numCenters);
histHogCenters = assignMaskedCenters(hogAll,hogCenters,'exp');

save([savename 'hog_cdbk.mat'],'hogCenters','-v7.3');
save([savename 'histHog.mat'],'histHogCenters','-v7.3');

end