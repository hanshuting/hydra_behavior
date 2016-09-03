function [filePath,fileName,trackPath,numImages,fr] = fileinfoDT_galois(indx)

% a function that stores all path and file name information

switch indx
     case 1
        filePath = '/home/sh3276/work/data/';
        fileName = '20150218_light_1_5hz_resized';
        trackPath = '/home/sh3276/work/results/';
        numImages = 9022;
        fr = 5;
    case 2
        filePath = '/home/sh3276/work/data/';
        fileName = '20150218_light_2_5hz_resized';
        trackPath = '/home/sh3276/work/results/';
        numImages = 9000;
        fr = 5;
    case 3
        filePath = '/home/sh3276/work/data/';
        fileName = '20150311_EC_light';
        trackPath = '/home/sh3276/work/results/';
        numImages = 7074;
        fr = 5;
    case 4
        filePath = '/home/sh3276/work/data/';
        fileName = '20150410_1';
        trackPath = '/home/sh3276/work/results/';
        numImages = 7722;
        fr = 5;
    case 5
        filePath = '/home/sh3276/work/data/';
        fileName = '20150410_4';
        trackPath = '/home/sh3276/work/results/';
        numImages = 3762;
        fr = 5;
    case 6
        filePath = '/home/sh3276/work/data/';
        fileName = '20150410_6'; 
        trackPath = '/home/sh3276/work/results/';
        numImages = 7684;
        fr = 5;
    case 7
        filePath = '/home/sh3276/work/data/';
        fileName = '20150411_1'; 
        trackPath = '/home/sh3276/work/results/';
        numImages = 3500;
        fr = 5;
    case 8
        filePath = '/home/sh3276/work/data/';
        fileName = '20150411_4';
        trackPath = '/home/sh3276/work/results/';
        numImages = 8622;
        fr = 5;
    case 9
        filePath = '/home/sh3276/work/data/';
        fileName = '20150504_1';
        trackPath = '/home/sh3276/work/results/';
        numImages = 9500;
        fr = 5;
    case 10
        filePath = '/home/sh3276/work/data/';
        fileName = '20150504_2';
        trackPath = '/home/sh3276/work/results/';
        numImages = 9800;
        fr = 5;
    case 11
        filePath = '/home/sh3276/work/data/';
        fileName = '20150504_3';
        trackPath = '/home/sh3276/work/results/';
        numImages = 6100;
        fr = 5;
    case 12
        filePath = '/home/sh3276/work/data/';
        fileName = '20150504_4';
        trackPath = '/home/sh3276/work/results/';
        numImages = 9518;
        fr = 5;
    case 13
        filePath = '/home/sh3276/work/data/';
        fileName = '20150504_5'; % 9001
        trackPath = '/home/sh3276/work/results/';
        numImages = 9000;
        fr = 5;
    case 100
        filePath = '/home/sh3276/work/data/';
        fileName = '20141110_GFP_tracking_original_resized';
        trackPath = '/home/sh3276/work/results/';
        numImages = 2500;
        fr = 10;
    otherwise
        error('file does not exist!');
end

end