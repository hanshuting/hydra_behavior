function [] = dt_mbhy_cdbk_yeti(video_size,trackLength,trackThresh,sampleStride)
% set parameters
fileInd = 1;

% initialization
rng(1000);
numCenters = 1000;
mbhy_all = {};

for i = fileInd
    
    movieParam = paramAllDT_yeti(i);
    fprintf('loading sample: %s\n', movieParam.fileName);
    
    savename = ['/vega/brain/users/sh3276/results/DT/' ...
        movieParam.fileName '_' num2str(video_size) 's_' num2str(trackThresh)...
        '_L_' num2str(trackLength) '_W_' num2str(sampleStride) '_'];

    load([savename 'mbhy.mat']);
    fprintf('file %u is loaded\n',i);

    % store results
    numSample = length(mbhyAll);
    mbhy_all(end+1:end+numSample) = mbhyAll;
    fprintf('file %u is done\n',i);    
     
end

mbhy_all = mbhy_all';
mbhyCenters = gnCdbk(mbhy_all,numCenters);
histMbhyCenters = assignMaskedCenters(mbhyAll,mbhyCenters,'exp');

save([savename 'mbhy_cdbk.mat'],'mbhyCenters','-v7.3');
save([savename 'histMbhy.mat'],'histMbhyCenters','-v7.3');

end