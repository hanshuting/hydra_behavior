function [fileName,numImages,fr,sz] = fileinfo(indx)

% a function that stores all path and file name information

switch indx
    case 1
        fileName = '20150218_light_1_5hz_resized';
        numImages = 9022;
        fr = 5;
        sz = [300,300];
    case 2
        fileName = '20150218_light_2_5hz_resized';
        numImages = 9019;
        fr = 5;
        sz = [300,300];
    case 3
        fileName = '20150311_EC_light';
        numImages = 7074;
        fr = 5;
        sz = [300,300];
    case 4
        fileName = '20150410_1';
        numImages = 7722;
        fr = 5;
        sz = [300,300];
    case 5
        fileName = '20150410_4';
        numImages = 3762;
        fr = 5;
        sz = [300,300];
    case 6
        fileName = '20150410_6';
        numImages = 7684;
        fr = 5;
        sz = [300,300];
    case 7
        fileName = '20150411_1';
        numImages = 3501;
        fr = 5;
        sz = [300,300];
    case 8
        fileName = '20150411_4';
        numImages = 7474;
        fr = 5;
        sz = [216,250];
    case 9
        fileName = '20150504_1';
        numImages = 9501;
        fr = 5;
        sz = [300,300];
    case 10
        fileName = '20150504_2';
        numImages = 9801;
        fr = 5;
        sz = [300,300];
    case 11
        fileName = '20150504_3';
        numImages = 6101;
        fr = 5;
        sz = [300,300];
    case 12
        fileName = '20150504_4';
        numImages = 9518;
        fr = 5;
        sz = [300,300];
    case 13
        fileName = '20150504_5';
        numImages = 9001;
        fr = 5;
        sz = [300,300];
    case 14
        fileName = '20150813_1_floating';
        numImages = 7263;
        fr = 5;
        sz = [322,322];
    case 15
        fileName = '20150813_2_feeding';
        numImages = 6000; % 6001
        fr = 5;
        sz = [259,259];
    case 16
        fileName = '20150813_3_feeding';
        numImages = 7493;
        fr = 5;
        sz = [314,314];
    case 17
        fileName = '20150813_4_feeding';
        numImages = 5862;
        fr = 5;
        sz = [302,300];
    case 18
        fileName = '20150813_5';
        numImages = 1900; % 1902
        fr = 5;
        sz = [308,300];
    case 19
        fileName = '20150813_6_somersaulting_feeding';
        numImages = 8098;
        fr = 5;
        sz = [279,350];
    case 20
        fileName = '20150814_1_somersaulting';
        numImages = 2783;
        fr = 5;
        sz = [324,300];
    case 21
        fileName = '20150814_2_somersaulting';
        numImages = 4562;
        fr = 5;
        sz = [325,350];
    case 22
        fileName = '20141218_somersaulting';
        numImages = 4658;
        fr = 5;
        sz = [262,362];
    case 23
        fileName = '20151107_1';
        numImages = 8899;
        fr = 5;
        sz = [300,300];
    case 24
        fileName = '20151107_2';
        numImages = 4900;
        fr = 5;
        sz = [298,300];
    case 25
        fileName = '20151107_3';
        numImages = 7059;
        fr = 5;
        sz = [300,300];
    case 26
        fileName = '20151109_1';
        numImages = 9801;
        fr = 5;
        sz = [300,300];
    case 27
        fileName = '20151109_2';
        numImages = 7962;
        fr = 5;
        sz = [300,300];
    case 28
        fileName = '20151109_3';
        numImages = 8812;
        fr = 5;
        sz = [300,300];
    case 29
        fileName = '20151109_4';
        numImages = 9543;
        fr = 5;
        sz = [300,300];
    case 30
        fileName = '20151110_1';
        numImages = 9726;
        fr = 5;
        sz = [300,300];
    case 31
        fileName = '20151110_2';
        numImages = 7766;
        fr = 5;
        sz = [300,300];
    case 32
        fileName = '20151110_3';
        numImages = 9810;
        fr = 5;
        sz = [300,300];
    case 33
        fileName = '20151111_1';
        numImages = 8393;
        fr = 5;
        sz = [300,300];
    case 34
        fileName = '20151111_2';
        numImages = 5915;
        fr = 5;
        sz = [293,293];
    case 35
        fileName = '20160317_g6s_1';
        numImages = 8437;
        fr = 5;
        sz = [212,212];
    case 36
        fileName = '20160317_g6s_2';
        numImages = 12427;
        fr = 5;
        sz = [246,367];
    case 37
        fileName = '20160317_g6s_3';
        numImages = 7770;
        fr = 5;
        sz = [284,284];
    case 38
        fileName = '20160317_g6s_4';
        numImages = 8686;
        fr = 5;
        sz = [176,176];
    case 39
        fileName = '20160317_g6s_5';
        numImages = 7708;
        fr = 5;
        sz = [287,300];
    case 40
        fileName = '20160317_g6s_6';
        numImages = 7593;
        fr = 5;
        sz = [293,300];
    case 41
        fileName = '20160317_g6s_7';
        numImages = 7770;
        fr = 5;
        sz = [280,300];
    case 42
        fileName = '20160317_g6s_8';
        numImages = 7770;
        fr = 5;
        sz = [296,300];
    case 43
        fileName = '20160317_g6s_9';
        numImages = 7554;
        fr = 5;
        sz = [254,320];
    case 44
        fileName = '20160321_1_gsm';
        numImages = 3705;
        fr = 5;
        sz = [337,290];
    case 45
        fileName = '20160321_2_gsm';
        numImages = 5025;
        fr = 5;
        sz = [188,263];
    case 46
        fileName = '20160321_3_gsm';
        numImages = 4853;
        fr = 5;
        sz = [194,211];
    case 47
        fileName = '20160321_4_gsm';
        numImages = 6022;
        fr = 5;
        sz = [254,281];
    case 48
        fileName = '20160321_5_gsm';
        numImages = 4658;
        fr = 5;
        sz = [205,241];
    case 49
        fileName = '20160321_6_gsm';
        numImages = 4832;
        fr = 5;
        sz = [253,251];
    case 50
        fileName = '20160321_7_gsm';
        numImages = 4768;
        fr = 5;
        sz = [223,237];
    case 51
        fileName = '20160321_8_gsm';
        numImages = 4803;
        fr = 5;
        sz = [267,280];
    case 52
        fileName = '20160321_9_gsm';
        numImages = 4761;
        fr = 5;
        sz = [297,254];
    case 53
        fileName = '20160321_10_gsm';
        numImages = 5219;
        fr = 5;
        sz = [273,270];
    case 54
        fileName = '20160321_11_gsm';
        numImages = 4660;
        fr = 5;
        sz = [309,300];
    case 55
        fileName = '20160321_12_gsm';
        numImages = 4260;
        fr = 5;
        sz = [228,244];
    case 56
        fileName = '20160321_13_gsm';
        numImages = 11062;
        fr = 5;
        sz = [254,260];
    % ------------- GCaMP6s neural data ------------------%
    case 201
        fileName = '20160111_1';
        numImages = 1000;
        fr = 10;
        sz = [];
    case 202
        fileName = '20160111_2';
        numImages = 18094;
        fr = 10;
        sz = [422, 422];
    case 203
        fileName = '20160111_2_gsm';
        numImages = 6605;
        fr = 10;
        sz = [401, 401];
    case 204
        fileName = '20160111_3';
        numImages = 17181;
        fr = 10;
        sz = [394, 394];
    case 205
        fileName = '20160111_3_gsm';
        numImages = 6165;
        fr = 10;
        sz = [341, 341];
    case 206
        fileName = '20160111_4';
        numImages = 17438;
        fr = 10;
        sz = [435, 435];
    case 207
        fileName = '20160111_4_gsm';
        numImages = 5188;
        fr = 10;
        sz = [512, 512];
    case 208
        fileName = '20160112_1';
        numImages = 18855;
        fr = 10;
        sz = [275, 275];
    case 209
        fileName = '20160112_1_gsm';
        numImages = 8252;
        fr = 10;
        sz = [300, 300];
    case 210
        fileName = '20160112_2';
        numImages = 9056;
        fr = 10;
        sz = [370, 370];
    case 211
        fileName = '20160112_2_gsm';
        numImages = 3841;
        fr = 10;
        sz = [279, 279];
    case 212
        fileName = '20160112_3';
        numImages = 9298;
        fr = 10;
        sz = [362, 362];
    case 213
        fileName = '20160112_3_gsm';
        numImages = 3969;
        fr = 10;
        sz = [342, 342];
    case 214
        fileName = '20160112_4';
        numImages = 9348;
        fr = 10;
        sz = [512, 512];
    case 215
        fileName = '20160112_4_gsm';
        numImages = 3940;
        fr = 10;
        sz = [434, 434];
    case 216
        fileName = '20160114_1';
        numImages = 4314;
        fr = 10;
        sz = [382, 382];
    case 217
        fileName = '20160114_1_gsm';
        numImages = 1829;
        fr = 10;
        sz = [345, 345];
    case 218
        fileName = '20160114_2';
        numImages = 7082;
        fr = 10;
        sz = [459, 459];
    case 219
        fileName = '20160114_2_gsm';
        numImages = 4178;
        fr = 10;
        sz = [339, 339];
    case 220
        fileName = '20160114_3';
        numImages = 8770;
        fr = 10;
        sz = [454, 445];
    case 221
        fileName = '20160114_4';
        numImages = 6158;
        fr = 10;
        sz = [446, 446];
    case 222
        fileName = '20160115_1';
        numImages = 9655;
        fr = 10;
        sz = [324, 324];
    case 223
        fileName = '20160118_1';
        numImages = 6886;
        fr = 10;
        sz = [395, 395];
    case 224
        fileName = '20160118_1_gsm';
        numImages = 1560;
        fr = 10;
        sz = [391, 391];
    case 225
        fileName = '20160118_2';
        numImages = 4380;
        fr = 10;
        sz = [411, 411];
    case 226
        fileName = '20160118_2_gsm';
        numImages = 4817;
        fr = 10;
        sz = [524, 524];
    case 227
        fileName = '20160118_4';
        numImages = 1700;
        fr = 10;
        sz = [458, 392];
    case 228
        fileName = '20160118_5';
        numImages = 8346;
        fr = 10;
        sz = [371, 314];
    case 229
        fileName = '20160118_5_gsm';
        numImages = 4934;
        fr = 10;
        sz = [354, 236];
    case 230
        fileName = '20160118_6';
        numImages = 7241;
        fr = 10;
        sz = [353, 353];
    case 231
        fileName = '20160118_6_gsm';
        numImages = 4323;
        fr = 10;
        sz = [258, 258];
    case 232
        fileName = '20160118_7';
        numImages = 9430;
        fr = 10;
        sz = [417, 417];
    case 233
        fileName = '20160118_7_gsm';
        numImages = 4528;
        fr = 10;
        sz = [532, 399];
    case 234
        fileName = '20160118_8';
        numImages = 7914;
        fr = 10;
        sz = [452, 396];
    case 235
        fileName = '20160118_8_gsm';
        numImages = 4111;
        fr = 10;
        sz = [340, 289];
    case 236
        fileName = '20160118_9';
        numImages = 7734;
        fr = 10;
        sz = [392, 348];
    case 237
        fileName = '20160118_9_gsm';
        numImages = 4689;
        fr = 10;
        sz = [420, 265];
    case 238
        fileName = '20160118_10';
        numImages = 6289;
        fr = 10;
        sz = [380, 275];
    case 239
        fileName = '20160118_10_gsm';
        numImages = 3899;
        fr = 10;
        sz = [518, 467];
    case 240
        fileName = '20160120_1';
        numImages = 7112;
        fr = 10;
        sz = [512, 512];
    case 241
        fileName = '20160120_1_gsm';
        numImages = 4476;
        fr = 10;
        sz = [394, 375];
    case 242
        fileName = '20160120_2';
        numImages = 5850;
        fr = 10;
        sz = [378, 334];
    case 243
        fileName = '20160120_2_gsm';
        numImages = 3010;
        fr = 10;
        sz = [502, 455];
    case 244
        fileName = '20160120_3';
        numImages = 6124;
        fr = 10;
        sz = [579, 516];
    case 245
        fileName = '20160120_3_gsm';
        numImages = 2879;
        fr = 10;
        sz = [520, 468];
    case 246
        fileName = '20160120_4';
        numImages = 6640;
        fr = 10;
        sz = [512, 512];
    case 247
        fileName = '20160120_4_gsm';
        numImages = 3919;
        fr = 10;
        sz = [434, 447];
    case 248
        fileName = '20160120_5';
        numImages = 6416;
        fr = 10;
        sz = [446, 504];
    case 249
        fileName = '20160120_5_gsm';
        numImages = 2954;
        fr = 10;
        sz = [575, 636];
    case 250
        fileName = '20160120_6';
        numImages = 6331;
        fr = 10;
        sz = [439, 392];
    case 251
        fileName = '20160120_6_gsm';
        numImages = 3474;
        fr = 10;
        sz = [460, 492];
    case 252
        fileName = '20160120_7';
        numImages = 6270;
        fr = 10;
        sz = [382, 505];
    case 253
        fileName = '20160120_7_gsm';
        numImages = 3017;
        fr = 10;
        sz = [452, 399];
    % ------------- light/dark data ------------------%
     case 301
        fileName = '20160105_1_dark';
        numImages = 12029;
        fr = 5;
        sz = [234,234];
    case 302
        fileName = '20160105_1_light';
        numImages = 11236;
        fr = 5;
        sz = [301,301];
    case 303
        fileName = '20160105_2_dark';
        numImages = 10610;
        fr = 5;
        sz = [322,322];
    case 304
        fileName = '20160105_2_light';
        numImages = 11153;
        fr = 5;
        sz = [333,333];
    case 305
        fileName = '20160105_3_dark';
        numImages = 10098;
        fr = 5;
        sz = [392,392];
    case 306
        fileName = '20160105_3_light';
        numImages = 11121;
        fr = 5;
        sz = [369,369];
    case 307
        fileName = '20160106_1_dark';
        numImages = 9260;
        fr = 5;
        sz = [308,308];
    case 308
        fileName = '20160106_1_light';
        numImages = 9460;
        fr = 5;
        sz = [251,251];
    case 309
        fileName = '20160106_2_dark';
        numImages = 8010;
        fr = 5;
        sz = [246,246];
    case 310
        fileName = '20160106_2_light';
        numImages = 10884;
        fr = 5;
        sz = [287,287];
    case 311
        fileName = '20160106_3_dark';
        numImages = 8505;
        fr = 5;
        sz = [329,329];
    case 312
        fileName = '20160106_3_light';
        numImages = 11129;
        fr = 5;
        sz = [409,409];
    case 313
        fileName = '20160112_1_dark';
        numImages = 9548;
        fr = 5;
        sz = [300,300];
    case 314
        fileName = '20160112_1_light';
        numImages = 6171;
        fr = 5;
        sz = [342,342];
    case 315
        fileName = '20160112_2_dark';
        numImages = 8402;
        fr = 5;
        sz = [299,299];
    case 316
        fileName = '20160112_2_light';
        numImages = 8656;
        fr = 5;
        sz = [279,279];
    case 317
        fileName = '20160112_3_dark';
        numImages = 8224;
        fr = 5;
        sz = [323,323];
    case 318
        fileName = '20160112_3_light';
        numImages = 5500;
        fr = 5;
        sz = [417,417];
    case 319
        fileName = '20160113_1_dark';
        numImages = 10470;
        fr = 5;
        sz = [214,214];
    case 320
        fileName = '20160113_1_light';
        numImages = 9019;
        fr = 5;
        sz = [216,216];
    case 321
        fileName = '20160113_2_dark';
        numImages = 8567;
        fr = 5;
        sz = [239,239];
    case 322
        fileName = '20160113_2_light';
        numImages = 12904;
        fr = 5;
        sz = [200,200];
    case 323
        fileName = '20160113_3_dark';
        numImages = 8726;
        fr = 5;
        sz = [294,294];
    case 324
        fileName = '20160113_3_light';
        numImages = 9944;
        fr = 5;
        sz = [313,313];
    % ------------------------ GFP dataset ------------------------%
    case 401
        fileName = '20151203_GFP_1';
        numImages = 6178;
        fr = 10;
        sz = [512,512];
    case 402
        fileName = '20151203_GFP_2';
        numImages = 5479;
        fr = 10;
        sz = [512,512];
    case 403
        fileName = '20151203_GFP_3';
        numImages = 6007;
        fr = 10;
        sz = [512,512];
    case 404
        fileName = '20151203_GFP_4';
        numImages = 4559;
        fr = 10;
        sz = [512,512];
    case 405
        fileName = '20151203_GFP_5';
        numImages = 5541;
        fr = 10;
        sz = [512,512];
    case 406
        fileName = '20151203_GFP_6';
        numImages = 5232;
        fr = 10;
        sz = [512,512];
    case 407
        fileName = '20151203_GFP_7';
        numImages = 5887;
        fr = 10;
        sz = [512,512];
    case 408
        fileName = '20151203_GFP_8';
        numImages = 6001;
        fr = 10;
        sz = [512,512];
    case 409
        fileName = '20151203_GFP_9';
        numImages = 5785;
        fr = 10;
        sz = [512,512];
    case 410
        fileName = '20151203_GFP_10';
        numImages = 5141;
        fr = 10;
        sz = [512,512];
    case 411
        fileName = '20151203_GFP_11';
        numImages = 5494;
        fr = 10;
        sz = [512,512];
    case 412
        fileName = '20151203_GFP_12';
        numImages = 5986;
        fr = 10;
        sz = [512,512];
    case 413
        fileName = '20151203_GFP_13';
        numImages = 5378;
        fr = 10;
        sz = [512,512];
    case 414
        fileName = '20151203_GFP_14';
        numImages = 2570;
        fr = 10;
        sz = [512,512];
    case 415
        fileName = '20151203_GFP_15';
        numImages = 3500;
        fr = 10;
        sz = [512,512];
    case 416
        fileName = '20160229_gfp_1';
        numImages = 14704;
        fr = 10;
        sz = [382,381];
    case 417
        fileName = '20160229_gfp_2';
        numImages = 10358;
        fr = 10;
        sz = [437,428];
    case 418
        fileName = '20160229_gfp_3';
        numImages = 13708;
        fr = 10;
        sz = [355,350];
    case 419
        fileName = '20160229_gfp_4';
        numImages = 15704;
        fr = 10;
        sz = [398,416];
    case 420
        fileName = '20160229_gfp_5';
        numImages = 8772;
        fr = 10;
        sz = [456,440];
    case 421
        fileName = '20160229_gfp_6';
        numImages = 4000;
        fr = 10;
        sz = [457,446];
    case 422
        fileName = '20160229_gfp_7';
        numImages = 9679;
        fr = 10;
        sz = [452,453];
    case 423
        fileName = '20160303_gfp_1';
        numImages = 7999;
        fr = 10;
        sz = [412,424];
    case 424
        fileName = '20160303_gfp_2';
        numImages = 12662;
        fr = 10;
        sz = [400,400];
    case 425
        fileName = '20160303_gfp_3';
        numImages = 16310;
        fr = 10;
        sz = [352,300];
    case 426
        fileName = '20160303_gfp_4';
        numImages = 2874;
        fr = 10;
        sz = [510,371];
    case 427
        fileName = '20160303_gfp_5';
        numImages = 13347;
        fr = 10;
        sz = [411,413];
    case 428
        fileName = '20160303_gfp_6';
        numImages = 8256;
        fr = 10;
        sz = [298,368];
    case 429
        fileName = '20160303_gfp_7';
        numImages = 6636;
        fr = 10;
        sz = [381,405];
    case 430
        fileName = '20160303_gfp_8';
        numImages = 8904;
        fr = 10;
        sz = [394,367];
    case 431
        fileName = '20160303_gfp_9';
        numImages = 6400;
        fr = 10;
        sz = [416,394];
    case 432
        fileName = '20160303_gfp_10';
        numImages = 3500;
        fr = 10;
        sz = [410,417];
    otherwise
        error('file does not exist');
end

end
