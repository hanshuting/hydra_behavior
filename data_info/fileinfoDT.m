function [filePath,fileName,trackPath,trackName,numImages,fr] = fileinfoDT(indx)

% a function that stores all path and file name information

switch indx
    case 1
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150218_light_1_5hz_resized';
        trackPath = 'C:\Shuting\Data\freely_moving\individual_samples\DT_features\20150218_light_1_5hz_resized\';
        trackName = '20150218_light_1_5hz_resized';
        numImages = 9022;
        fr = 5;
    case 101
        filePath = 'C:\Shuting\Data\GFP_coverslips\individual_samples\';
        fileName = '20141110_GFP_tracking_original_resized';
        trackPath = 'C:\Shuting\Data\GFP_coverslips\individual_samples\DT_features\20141110_GFP_tracking_original_resized\';
        trackName = '20141110_GFP_tracking_original';
        numImages = 2500;
        fr = 10;
    otherwise
        error('file does not exist!');
end

end