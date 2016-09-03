function [] = dt_mbhx_cdbk_yeti(video_size,trackLength,trackThresh,sampleStride)
% set parameters
fileInd = 1;

% initialization
rng(1000);
numCenters = 1000;
mbhx_all = {};

for i = fileInd
    
    movieParam = paramAllDT_yeti(i);
    fprintf('loading sample: %s\n', movieParam.fileName);
    
    savename = ['/vega/brain/users/sh3276/results/DT/' ...
        movieParam.fileName '_' num2str(video_size) 's_' num2str(trackThresh)...
        '_L_' num2str(trackLength) '_W_' num2str(sampleStride) '_'];
    
    load([savename 'mbhx.mat']);
    fprintf('file %u is loaded\n',i);

    % store results
    numSample = length(mbhxAll);
    mbhx_all(end+1:end+numSample) = mbhxAll;
    fprintf('file %u is done\n',i);    
     
end

mbhx_all = mbhx_all';
mbhxCenters = gnCdbk(mbhx_all,numCenters);
histMbhxCenters = assignMaskedCenters(mbhxAll,mbhxCenters,'exp');

save([savename 'mbhx_cdbk.mat'],'mbhxCenters','-v7.3');
save([savename 'histMbhx.mat'],'histMbhxCenters','-v7.3');

end