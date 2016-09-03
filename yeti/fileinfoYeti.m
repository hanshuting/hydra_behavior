function [filePath,fileName,numImages,fr] = fileinfoYeti(indx)

% a function that stores all path and file name information

switch indx
    case 1
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150218_light_1_5hz_resized'; %9000
        numImages = 9000;
        fr = 5;
    case 2
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150218_light_2_5hz_resized'; %9000
        numImages = 9000;
        fr = 5;
    case 3
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150311_EC_light'; %7074
        numImages = 7000;
        fr = 5;
    case 4
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150410_1'; %7722
        numImages = 7500;
        fr = 5;
    case 5
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150410_4'; %3762
        numImages = 3500;
        fr = 5;
    case 6
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150410_6'; %7684
        numImages = 7500;
        fr = 5;
    case 7
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150411_1'; % 3500
        numImages = 3500;
        fr = 5;
    case 8
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150411_4'; % 8622
        numImages = 8500;    
        fr = 5;
    case 9
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150504_1'; % 9500
        numImages = 9500;
        fr = 5;
    case 10
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150504_2'; % 9800
        numImages = 9800;
        fr = 5;
    case 11
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150504_3'; % 6100
        numImages = 6000;
        fr = 5;
    case 12
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150504_4'; % 9518
        numImages = 9500;
        fr = 5;
    case 13
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150504_5'; % 9001
        numImages = 9000;
        fr = 5;
    case 14
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150813_1_floating';
        numImages = 7263;
        fr = 5;
    case 15
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150813_2_feeding';
        numImages = 6001;
        fr = 5;
    case 16
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150813_3_feeding';
        numImages = 7493;
        fr = 5;
    case 17
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150813_4_feeding';
        numImages = 5862;
        fr = 5;
    case 18
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150813_5';
        numImages = 1902;
        fr = 5;
    case 19
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150813_6_somersaulting_feeding';
        numImages = 8098;
        fr = 5;
    case 20
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150814_1_somersaulting';
        numImages = 2783;
        fr = 5;
    case 21
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20150814_2_somersaulting';
        numImages = 4562;
        fr = 5;
    case 22
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20141218_somersaulting';
        numImages = 4658;
        fr = 5;
    case 23
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151107_1';
        numImages = 8899;
        fr = 5;
    case 24
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151107_2';
        numImages = 4900;
        fr = 5;
    case 25
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151107_3';
        numImages = 7059;
        fr = 5;
    case 26
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151109_1';
        numImages = 9801;
        fr = 5;
    case 27
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151109_2';
        numImages = 7962;
        fr = 5;
    case 28
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151109_3';
        numImages = 8812;
        fr = 5;
    case 29
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151109_4';
        numImages = 9543;
        fr = 5;
    case 30
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151110_1';
        numImages = 9726;
        fr = 5;
    case 31
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151110_2';
        numImages = 7766;
        fr = 5;
    case 32
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151110_3';
        numImages = 9810;
        fr = 5;
    case 33
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151111_1';
        numImages = 8393;
        fr = 5;
    case 34
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151111_2';
        numImages = 5915;
        fr = 5;
        % ------------- 20151124 red light imaging ------------------%
    case 301
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_1';
        numImages = 8172;
        fr = 5;
    case 302
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_2';
        numImages = 8172;
        fr = 5;
    case 303
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_3';
        numImages = 8172;
        fr = 5;
    case 304
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_4';
        numImages = 8172;
        fr = 5;
    case 305
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_5';
        numImages = 8172;
        fr = 5;
    case 306
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_6';
        numImages = 8172;
        fr = 5;
    case 307
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_7';
        numImages = 8172;
        fr = 5;
    case 308
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_8';
        numImages = 8172;
        fr = 5;
    case 309
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_9';
        numImages = 8172;
        fr = 5;
    case 310
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_10';
        numImages = 8172;
        fr = 5;
    case 311
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_11';
        numImages = 8172;
        fr = 5;
    case 312
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_12';
        numImages = 8172;
        fr = 5;
    case 313
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_13';
        numImages = 8172;
        fr = 5;
    case 314
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_14';
        numImages = 8172;
        fr = 5;
    case 315
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_15';
        numImages = 8172;
        fr = 5;
    case 316
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_16';
        numImages = 8172;
        fr = 5;
    case 317
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_17';
        numImages = 8172;
        fr = 5;
    case 318
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_18';
        numImages = 8172;
        fr = 5;
    case 319
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_19';
        numImages = 8172;
        fr = 5;
    case 320
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_20';
        numImages = 8172;
        fr = 5;
    case 321
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_21';
        numImages = 8172;
        fr = 5;
    case 322
        filePath = '/vega/brain/users/sh3276/data/20151124_red_imaging/';
        fileName = '20151124_red_imaging_22';
        numImages = 3104;
        fr = 5;
    % ------------------------ GFP dataset ------------------------%
    case 401
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_1';
        numImages = 6178;
        fr = 10;
    case 402
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_2';
        numImages = 5479;
        fr = 10;
    case 403
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_3';
        numImages = 6007;
        fr = 10;
    case 404
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_4';
        numImages = 4559;
        fr = 10;
    case 405
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_5';
        numImages = 5541;
        fr = 10;
    case 406
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_6';
        numImages = 5232;
        fr = 10;
    case 407
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_7';
        numImages = 5887;
        fr = 10;
    case 408
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_8';
        numImages = 6001;
        fr = 10;
    case 409
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_9';
        numImages = 5785;
        fr = 10;
    case 410
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_10';
        numImages = 5141;
        fr = 10;
    case 411
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_11';
        numImages = 5494;
        fr = 10;
    case 412
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_12';
        numImages = 5986;
        fr = 10;
    case 413
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_13';
        numImages = 5378;
        fr = 10;
    case 414
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_14';
        numImages = 2570;
        fr = 10;
    case 415
        filePath = '/vega/brain/users/sh3276/data/';
        fileName = '20151203_GFP_15';
        numImages = 3500;
        fr = 10;
    otherwise
        error('file does not exist');
end

end