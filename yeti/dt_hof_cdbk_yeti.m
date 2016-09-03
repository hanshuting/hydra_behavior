function [] = dt_hof_cdbk_yeti(video_size,trackLength,trackThresh,sampleStride)

% set parameters
fileInd = 1;

% initialization
rng(1000);
numCenters = 1000;
hof_all = {};

for i = fileInd
    
    movieParam = paramAllDT_yeti(i);
    fprintf('loading sample: %s\n', movieParam.fileName);
    
    savename = ['/vega/brain/users/sh3276/results/DT/' ...
        movieParam.fileName '_' num2str(video_size) 's_' num2str(trackThresh)...
        '_L_' num2str(trackLength) '_W_' num2str(sampleStride) '_'];

    load([savename 'hof.mat']);
    fprintf('file %u is loaded\n',i);

    % store results
    numSample = length(hofAll);
    hof_all(end+1:end+numSample) = hofAll;
    fprintf('file %u is done\n',i);    
     
end


hof_all = hof_all';
hofCenters = gnCdbk(hof_all,numCenters);
histHofCenters = assignMaskedCenters(hofAll,hofCenters,'exp');

save([savename 'hof_cdbk.mat'],'hofCenters','-v7.3');
save([savename 'histHof.mat'],'histHofCenters','-v7.3');

end