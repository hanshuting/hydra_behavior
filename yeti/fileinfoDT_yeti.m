function [filePath,fileName,trackPath,trackName,numImages,fr] = fileinfoDT_yeti(indx)

% a function that stores all path and file name information

switch indx
    case 1
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150218_light_1_5hz_resized';
        trackPath = '/vega/brain/users/sh3276/results/DT/20150218_light_1_5hz_resized/';
        trackName = '20150218_light_1_5hz_resized';
        numImages = 9022;
        fr = 5;
    case 101
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20141110_GFP_tracking_original_resized';
        trackPath = '/vega/brain/users/sh3276/results/DT/20141110_GFP_tracking_original_resized/';
        trackName = '20141110_GFP_tracking_original_resized';
        numImages = 2500;
        fr = 10;
    otherwise
        error('file does not exist!');
end

end
