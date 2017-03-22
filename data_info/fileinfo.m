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
        numImages = 1000;%4260;
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
    case 325
        fileName = '20161008_1_dark';
        numImages = 11031;
        fr = 5;
        sz = [172,162];
    case 326
        fileName = '20161008_1_light';
        numImages = 10331;
        fr = 5;
        sz = [188,182];
    case 327
        fileName = '20161008_2_dark';
        numImages = 11230;
        fr = 5;
        sz = [306,207];
    case 328
        fileName = '20161008_2_light';
        numImages = 7100;
        fr = 5;
        sz = [256,256];
    case 329
        fileName = '20161010_1_dark';
        numImages = 9610;
        fr = 5;
        sz = [317,320];
    case 330
        fileName = '20161010_1_light';
        numImages = 10883;
        fr = 5;
        sz = [277,288];
    case 331
        fileName = '20161010_2_dark';
        numImages = 9586;
        fr = 5;
        sz = [285,276];
    case 332
        fileName = '20161010_2_light';
        numImages = 12560;
        fr = 5;
        sz = [238,351];
    case 333
        fileName = '20161014_1_dark';
        numImages = 10198;
        fr = 5;
        sz = [286,303];
    case 334
        fileName = '20161014_1_light';
        numImages = 10203;
        fr = 5;
        sz = [251,254];
    case 335
        fileName = '20161014_2_dark';
        numImages = 12012;
        fr = 5;
        sz = [287,304];
    case 336
        fileName = '20161014_2_light';
        numImages = 9678;
        fr = 5;
        sz = [376,386];
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
    % -------------------- Medium swap expt --------------------%  
    % colony in solitary medium
    case 501
        fileName = 'medium1_AEPinSolMed06202016';
        numImages = 8791;
        fr = 5;
        sz = [221,177];
    case 502
        fileName = 'medium2_AEPinSolmed06212016';
        numImages = 11249;
        fr = 5;
        sz = [287,227];
    case 503
        fileName = 'medium3_ColinSolmed06222016';
        numImages = 9029;
        fr = 5;
        sz = [240,176];
    case 504
        fileName = 'medium4_ColinSolmed06232016';
        numImages = 9730;
        fr = 5;
        sz = [390,320];
    % colony in colony medium
    case 505
        fileName = 'control1_AEPmedium06092016';
        numImages = 8424;
        fr = 5;
        sz = [275,265];
    case 506
        fileName = 'control2_AEPmedium06092016';
        numImages = 9048;
        fr = 5;
        sz = [405,395];
    case 507
        fileName = 'control3_AEPmedium06092016';
        numImages = 10051;
        fr = 5;
        sz = [373,490];
    case 508
        fileName = 'control4_AEPmedium06142016';
        numImages = 8879;
        fr = 5;
        sz = [220,196];
    % solitary in solitary medium
    case 509
        fileName = 'control1_GCaMPmedium06202016';
        numImages = 8585;
        fr = 5;
        sz = [126,175];
    case 510
        fileName = 'control2_GCaMPmedium06212016';
        numImages = 9625;
        fr = 5;
        sz = [170,183];
    case 511
        fileName = 'control3_GCaMPSolitarymed06222016';
        numImages = 11811;
        fr = 5;
        sz = [159,135];
    case 512
        fileName = 'control4_GCaMPSolitarymed06222016';
        numImages = 9239;
        fr = 5;
        sz = [148,194];
    % solitary in colony medium
    case 513
        fileName = 'medium1_GCaMPinColMed06202016';
        numImages = 9070;
        fr = 5;
        sz = [184,173];
    case 514
        fileName = 'medium2_GCaMPinColmed06212016';
        numImages = 10527;
        fr = 5;
        sz = [353,376];
    case 515
        fileName = 'medium3_SolinColmed06222016';
        numImages = 9070;
        fr = 5;
        sz = [161,142];
    case 516
        fileName = 'medium4_SolinColmed06232016';
        numImages = 9216;
        fr = 5;
        sz = [143,133];
    % -------------------- Encounter expt --------------------%  
    % animal 1
    case 551
        fileName = 'control1_AEPcolony06072016';
        numImages = 8086;
        fr = 5;
        sz = [402,498];
    case 552
        fileName = 'control1_GcaMPsolitary06132016';
        numImages = 9503;
        fr = 5;
        sz = [195,223];
    case 553
        fileName = 'encounter1Colonyhalf_06142016';
        numImages = 7797;
        fr = 5;
        sz = [308,268];
    case 554
        fileName = 'encounter1Solitaryhalf_06142016';
        numImages = 7797;
        fr = 5;
        sz = [308,154];
    % animal 2
    case 555
        fileName = 'control2_AEPcolony06072016(00178)';
        numImages = 8918;
        fr = 5;
        sz = [408,405];
    case 556
        fileName = 'control2_GCaMPsolitary06152016';
        numImages = 9956;
        fr = 5;
        sz = [187,174];
    case 557
        fileName = 'encounter2Colonyhalf_06152016';
        numImages = 8445;
        fr = 5;
        sz = [77,103];
    case 558
        fileName = 'encounter2Solitaryhalf_06152016';
        numImages = 8445;
        fr = 5;
        sz = [116,97];
    % animal 3
    case 559
        fileName = 'control3_AEPcolony06072016';
        numImages = 8316;
        fr = 5;
        sz = [374,449];
    case 560
        fileName = 'control3_GCaMPSolitary06162016';
        numImages = 7920;
        fr = 5;
        sz = [168,190];
    case 561
        fileName = 'encounter3Colonyhalf_06162016';
        numImages = 9465;
        fr = 5;
        sz = [294,231];
    case 562
        fileName = 'encounter3Solitaryhalf_06162016';
        numImages = 9465;
        fr = 5;
        sz = [274,209];
    % animal 4
    case 563
        fileName = 'control4_AEPcolony06132016(00188)';
        numImages = 8963;
        fr = 5;
        sz = [172,159];
    case 564
        fileName = 'control4_GCaMPSolitary06172016';
        numImages = 9295;
        fr = 5;
        sz = [162,148];
    case 565
        fileName = 'encounter4Colonyhalf_06162016';
        numImages = 10417;
        fr = 5;
        sz = [131,131];
    case 566
        fileName = 'encounter4Solitaryhalf_06162016';
        numImages = 10417;
        fr = 5;
        sz = [163,145];
    % ------------- red light long term imaging ---------- %
    case 601
        fileName = '20151203_redlight_1';
        numImages = 8179;
        fr = 5;
        sz = [256,256];
    case 602
        fileName = '20151203_redlight_2';
        numImages = 8179;
        fr = 5;
        sz = [212,212];
    case 603
        fileName = '20151203_redlight_3';
        numImages = 8179;
        fr = 5;
        sz = [147,152];
    case 604
        fileName = '20151203_redlight_4';
        numImages = 8179;
        fr = 5;
        sz = [141,141];
    case 605
        fileName = '20151203_redlight_5';
        numImages = 8179;
        fr = 5;
        sz = [159,159];
    case 606
        fileName = '20151203_redlight_6';
        numImages = 8179;
        fr = 5;
        sz = [142,142];
    case 607
        fileName = '20151203_redlight_7';
        numImages = 8179;
        fr = 5;
        sz = [139,139];
    case 608
        fileName = '20151203_redlight_8';
        numImages = 8179;
        fr = 5;
        sz = [130,130];
    case 609
        fileName = '20151203_redlight_9';
        numImages = 8179;
        fr = 5;
        sz = [146,146];
    case 610
        fileName = '20151203_redlight_10';
        numImages = 8179;
        fr = 5;
        sz = [171,171];
    case 611
        fileName = '20151203_redlight_11';
        numImages = 8179;
        fr = 5;
        sz = [163,163];
    case 612
        fileName = '20151203_redlight_12';
        numImages = 1346;
        fr = 5;
        sz = [148,148];
    % light data
    case 613
        fileName = '20161024_AEP_light-1';
        numImages = 32716;
        fr = 5;
        sz = [168,168];
    case 614
        fileName = '20161024_AEP_light-2';
        numImages = 32716;
        fr = 5;
        sz = [165,165];
    case 615
        fileName = '20161024_AEP_light-3';
        numImages = 32716;
        fr = 5;
        sz = [129,129];
    case 616
        fileName = '20161024_AEP_light-4';
        numImages = 32716;
        fr = 5;
        sz = [125,125];
    case 617
        fileName = '20161024_AEP_light-5';
        numImages = 32716;
        fr = 5;
        sz = [106,106];
    case 618
        fileName = '20161024_AEP_light-6';
        numImages = 32716;
        fr = 5;
        sz = [122,122];
    case 619
        fileName = '20161024_AEP_light-7';
        numImages = 32716;
        fr = 5;
        sz = [115,115];
    case 620
        fileName = '20161024_AEP_light-8';
        numImages = 32716;
        fr = 5;
        sz = [156,156];
    % dark dataset
    case 621
        fileName = '20161025_AEP_dark-1';
        numImages = 32716;
        fr = 5;
        sz = [153,153];
    case 622
        fileName = '20161025_AEP_dark-2';
        numImages = 32716;
        fr = 5;
        sz = [143,143];
    case 623
        fileName = '20161025_AEP_dark-3';
        numImages = 32716;
        fr = 5;
        sz = [150,150];
    case 624
        fileName = '20161025_AEP_dark-4';
        numImages = 32716;
        fr = 5;
        sz = [176,176];
    case 625
        fileName = '20161025_AEP_dark-5';
        numImages = 32716;
        fr = 5;
        sz = [163,163];
    case 626
        fileName = '20161025_AEP_dark-6';
        numImages = 32716;
        fr = 5;
        sz = [170,170];
    case 627
        fileName = '20161025_AEP_dark-7';
        numImages = 32716;
        fr = 5;
        sz = [135,135];
    case 628
        fileName = '20161025_AEP_dark-8';
        numImages = 23348;
        fr = 5;
        sz = [177,177];
    % dataset 2
    % dark
    case 629
        fileName = '20161102_dark-1';
        numImages = 32716;
        fr = 5;
        sz = [180,180];
    case 630
        fileName = '20161102_dark-2';
        numImages = 32716;
        fr = 5;
        sz = [191,191];
    case 631
        fileName = '20161102_dark-3';
        numImages = 32716;
        fr = 5;
        sz = [189,189];
    case 632
        fileName = '20161102_dark-4';
        numImages = 32716;
        fr = 5;
        sz = [189,189];
    case 633
        fileName = '20161102_dark-5';
        numImages = 32716;
        fr = 5;
        sz = [174,174];
    case 634
        fileName = '20161102_dark-6';
        numImages = 32716;
        fr = 5;
        sz = [135,135];
    case 635
        fileName = '20161102_dark-7';
        numImages = 32716;
        fr = 5;
        sz = [215,215];
    case 636
        fileName = '20161102_dark-8';
        numImages = 28161;
        fr = 5;
        sz = [164,164];
    % light
    case 637
        fileName = '20161103_light-1';
        numImages = 32716;
        fr = 5;
        sz = [177,177];
    case 638
        fileName = '20161103_light-2';
        numImages = 32716;
        fr = 5;
        sz = [182,182];
    case 639
        fileName = '20161103_light-3';
        numImages = 32716;
        fr = 5;
        sz = [164,164];
    case 640
        fileName = '20161103_light-4';
        numImages = 32716;
        fr = 5;
        sz = [243,243];
    case 641
        fileName = '20161103_light-5';
        numImages = 32716;
        fr = 5;
        sz = [198,198];
    case 642
        fileName = '20161103_light-6';
        numImages = 32716;
        fr = 5;
        sz = [166,166];
    case 643
        fileName = '20161103_light-7';
        numImages = 32716;
        fr = 5;
        sz = [179,179];
    case 644
        fileName = '20161103_light-8';
        numImages = 24211;
        fr = 5;
        sz = [173,173];
    % dataset 3
    % dark
    case 645
        fileName = '20161107_dark-1';
        numImages = 32716;
        fr = 5;
        sz = [187,187];
    case 646
        fileName = '20161107_dark-2';
        numImages = 32716;
        fr = 5;
        sz = [168,168];
    case 647
        fileName = '20161107_dark-3';
        numImages = 32716;
        fr = 5;
        sz = [157,157];
    case 648
        fileName = '20161107_dark-4';
        numImages = 32716;
        fr = 5;
        sz = [173,173];
    case 649
        fileName = '20161107_dark-5';
        numImages = 32716;
        fr = 5;
        sz = [155,155];
    case 650
        fileName = '20161107_dark-6';
        numImages = 32716;
        fr = 5;
        sz = [157,157];
    case 651
        fileName = '20161107_dark-7';
        numImages = 32716;
        fr = 5;
        sz = [181,181];
    case 652
        fileName = '20161107_dark-8';
        numImages = 19899;
        fr = 5;
        sz = [171,171];
    % light
    case 653
        fileName = '20161108_light-1';
        numImages = 32716;
        fr = 5;
        sz = [190,190];
    case 654
        fileName = '20161108_light-2';
        numImages = 32716;
        fr = 5;
        sz = [200,200];
    case 655
        fileName = '20161108_light-3';
        numImages = 32716;
        fr = 5;
        sz = [184,184];
    case 656
        fileName = '20161108_light-4';
        numImages = 32716;
        fr = 5;
        sz = [195,195];
    case 657
        fileName = '20161108_light-5';
        numImages = 28197;
        fr = 5;
        sz = [191,191];
    case 658
        fileName = '20161121_light-1';
        numImages = 32716;
        fr = 5;
        sz = [260,257];
    case 659
        fileName = '20161121_light-2';
        numImages = 16900;
        fr = 5;
        sz = [201,197];
    case 660
        fileName = '20161121_light-3';
        numImages = 15816;
        fr = 5;
        sz = [195,196];
    case 661
        fileName = '20161121_light-4';
        numImages = 32716;
        fr = 5;
        sz = [134,134];
    case 662
        fileName = '20161121_light-5';
        numImages = 32716;
        fr = 5;
        sz = [121,121];
    case 663
        fileName = '20161121_light-6';
        numImages = 32716;
        fr = 5;
        sz = [126,127];
    case 664
        fileName = '20161121_light-7';
        numImages = 32716;
        fr = 5;
        sz = [145,152];
    case 665
        fileName = '20161121_light-8';
        numImages = 32716;
        fr = 5;
        sz = [161,169];
    case 666
        fileName = '20161121_light-9';
        numImages = 14600;
        fr = 5;
        sz = [124,128];
    case 667
        fileName = '20161122_dark-1';
        numImages = 32716;
        fr = 5;
        sz = [310,310];
    case 668
        fileName = '20161122_dark-2';
        numImages = 32716;
        fr = 5;
        sz = [270,270];
    case 669
        fileName = '20161122_dark-3';
        numImages = 32716;
        fr = 5;
        sz = [199,199];
    case 670
        fileName = '20161122_dark-4';
        numImages = 32716;
        fr = 5;
        sz = [260,260];
    case 671
        fileName = '20161122_dark-5';
        numImages = 32716;
        fr = 5;
        sz = [250,250];
    case 672
        fileName = '20161122_dark-6';
        numImages = 32716;
        fr = 5;
        sz = [256,256];
    case 673
        fileName = '20161129_light-1';
        numImages = 32716;
        fr = 5;
        sz = [229,229];
    case 674
        fileName = '20161129_light-2';
        numImages = 32716;
        fr = 5;
        sz = [163,163];
    case 675
        fileName = '20161129_light-3';
        numImages = 32716;
        fr = 5;
        sz = [177,177];
    case 676
        fileName = '20161129_light-4';
        numImages = 32716;
        fr = 5;
        sz = [260,292];
    case 677
        fileName = '20161129_light-5';
        numImages = 32716;
        fr = 5;
        sz = [152,151];
    case 678
        fileName = '20161129_light-6';
        numImages = 32716;
        fr = 5;
        sz = [208,208];
    case 679
        fileName = '20161129_light-7';
        numImages = 40404;
        fr = 5;
        sz = [212,212];
    case 680
        fileName = '20161130_dark-1';
        numImages = 32716;
        fr = 5;
        sz = [253,253];
    case 681
        fileName = '20161130_dark-2';
        numImages = 32716;
        fr = 5;
        sz = [212,212];
    case 682
        fileName = '20161130_dark-3';
        numImages = 32716;
        fr = 5;
        sz = [245,245];
    case 683
        fileName = '20161130_dark-4';
        numImages = 32716;
        fr = 5;
        sz = [221,221];
    case 684
        fileName = '20161130_dark-5';
        numImages = 32716;
        fr = 5;
        sz = [222,260];
    case 685
        fileName = '20161130_dark-6';
        numImages = 32716;
        fr = 5;
        sz = [280,255];
    case 686
        fileName = '20161130_dark-7';
        numImages = 31941;
        fr = 5;
        sz = [291,272];
    case 687
        fileName = '20161201_light-1';
        numImages = 32716;
        fr = 5;
        sz = [194,194];
    case 688
        fileName = '20161201_light-2';
        numImages = 32716;
        fr = 5;
        sz = [155,155];
    case 689
        fileName = '20161201_light-3';
        numImages = 32716;
        fr = 5;
        sz = [172,172];
    case 690
        fileName = '20161201_light-4';
        numImages = 32716;
        fr = 5;
        sz = [183,183];
    case 691
        fileName = '20161201_light-5';
        numImages = 32716;
        fr = 5;
        sz = [269,269];
    case 692
        fileName = '20161201_light-6';
        numImages = 32716;
        fr = 5;
        sz = [246,246];
    case 693
        fileName = '20161201_light-7';
        numImages = 32716;
        fr = 5;
        sz = [226,226];
    case 694
        fileName = '20161201_light-8';
        numImages = 21454;
        fr = 5;
        sz = [219,219];
    case 695
        fileName = '20161202_dark-1';
        numImages = 32716;
        fr = 5;
        sz = [151,151];
    case 696
        fileName = '20161202_dark-2';
        numImages = 32716;
        fr = 5;
        sz = [202,202];
    case 697
        fileName = '20161202_dark-3';
        numImages = 32716;
        fr = 5;
        sz = [202,202];
    case 698
        fileName = '20161202_dark-4';
        numImages = 32716;
        fr = 5;
        sz = [182,182];
    case 699
        fileName = '20161202_dark-5';
        numImages = 32716;
        fr = 5;
        sz = [217,217];
    case 700
        fileName = '20161202_dark-6';
        numImages = 32716;
        fr = 5;
        sz = [207,207];
    case 701
        fileName = '20161202_dark-7';
        numImages = 32716;
        fr = 5;
        sz = [206,206];
    case 702
        fileName = '20161202_dark-8';
        numImages = 28401;
        fr = 5;
        sz = [225,225];
    case 703
        fileName = '20161207_light-1';
        numImages = 32716;
        fr = 5;
        sz = [279,312];
    case 704
        fileName = '20161207_light-2';
        numImages = 32716;
        fr = 5;
        sz = [310,331];
    case 705
        fileName = '20161207_light-3';
        numImages = 32716;
        fr = 5;
        sz = [282,284];
    case 706
        fileName = '20161207_light-4';
        numImages = 32716;
        fr = 5;
        sz = [360,335];
    case 707
        fileName = '20161207_light-5';
        numImages = 32716;
        fr = 5;
        sz = [200,200];
    case 708
        fileName = '20161207_light-6';
        numImages = 32716;
        fr = 5;
        sz = [236,236];
    case 709
        fileName = '20161207_light-7';
        numImages = 31500;
        fr = 5;
        sz = [315,315];
    case 710
        fileName = '20161208_dark-1';
        numImages = 32716;
        fr = 5;
        sz = [304,304];
    case 711
        fileName = '20161208_dark-2';
        numImages = 32716;
        fr = 5;
        sz = [239,239];
    case 712
        fileName = '20161208_dark-3';
        numImages = 32716;
        fr = 5;
        sz = [224,224];
    case 713
        fileName = '20161208_dark-4';
        numImages = 32716;
        fr = 5;
        sz = [236,236];
    case 714
        fileName = '20161208_dark-5';
        numImages = 32716;
        fr = 5;
        sz = [225,225];
    case 715
        fileName = '20161208_dark-6';
        numImages = 32716;
        fr = 5;
        sz = [271,271];
    case 716
        fileName = '20161208_dark-7';
        numImages = 32716;
        fr = 5;
        sz = [247,247];
    case 717
        fileName = '20161208_dark-8';
        numImages = 20523;
        fr = 5;
        sz = [261,261];
    % short dark/light datasets
    case 718
        fileName = '20160105_1_dark';
        numImages = 12029;
        fr = 5;
        sz = [234,234];
    case 719
        fileName = '20160105_1_light';
        numImages = 11236;
        fr = 5;
        sz = [301,301];
    case 720
        fileName = '20160105_2_dark';
        numImages = 10610;
        fr = 5;
        sz = [322,322];
    case 721
        fileName = '20160105_2_light';
        numImages = 11153;
        fr = 5;
        sz = [333,333];
    case 722
        fileName = '20160105_3_dark';
        numImages = 10098;
        fr = 5;
        sz = [392,392];
    case 723
        fileName = '20160105_3_light';
        numImages = 11121;
        fr = 5;
        sz = [369,369];
    case 724
        fileName = '20160106_1_dark';
        numImages = 9260;
        fr = 5;
        sz = [308,308];
    case 725
        fileName = '20160106_1_light';
        numImages = 9460;
        fr = 5;
        sz = [251,251];
    case 726
        fileName = '20160106_2_dark';
        numImages = 8010;
        fr = 5;
        sz = [246,246];
    case 727
        fileName = '20160106_2_light';
        numImages = 10884;
        fr = 5;
        sz = [287,287];
    case 728
        fileName = '20160106_3_dark';
        numImages = 8505;
        fr = 5;
        sz = [329,329];
    case 729
        fileName = '20160106_3_light';
        numImages = 11129;
        fr = 5;
        sz = [409,409];
    case 730
        fileName = '20160108_1_dark';
        numImages = 9050;
        fr = 5;
        sz = [173,173];
    case 731
        fileName = '20160108_1_dark_float';
        numImages = 11681;
        fr = 5;
        sz = [186,186];
    case 732
        fileName = '20160108_1_light';
        numImages = 11933;
        fr = 5;
        sz = [219,219];
    case 733
        fileName = '20160108_2_dark';
        numImages = 9428;
        fr = 5;
        sz = [279,279];
    case 734
        fileName = '20160108_2_dark_float';
        numImages = 17461;
        fr = 5;
        sz = [239,239];
    case 735
        fileName = '20160108_2_light';
        numImages = 9602;
        fr = 5;
        sz = [386,386];
    case 736
        fileName = '20160112_1_dark';
        numImages = 9548;
        fr = 5;
        sz = [300,300];
    case 737
        fileName = '20160112_1_light';
        numImages = 6171;
        fr = 5;
        sz = [342,342];
    case 738
        fileName = '20160112_2_dark';
        numImages = 8402;
        fr = 5;
        sz = [299,299];
    case 739
        fileName = '20160112_2_light';
        numImages = 8656;
        fr = 5;
        sz = [279,279];
    case 740
        fileName = '20160112_3_dark';
        numImages = 8224;
        fr = 5;
        sz = [323,323];
    case 741
        fileName = '20160112_3_light';
        numImages = 7602;
        fr = 5;
        sz = [417,417];
    case 742
        fileName = '20160113_1_dark';
        numImages = 10470;
        fr = 5;
        sz = [214,214];
    case 743
        fileName = '20160113_1_light';
        numImages = 9019;
        fr = 5;
        sz = [216,216];
    case 744
        fileName = '20160113_2_dark';
        numImages = 8567;
        fr = 5;
        sz = [239,239];
    case 745
        fileName = '20160113_2_light';
        numImages = 12904;
        fr = 5;
        sz = [200,200];
    case 746
        fileName = '20160113_3_dark';
        numImages = 8726;
        fr = 5;
        sz = [294,294];
    case 747
        fileName = '20160113_3_light';
        numImages = 9944;
        fr = 5;
        sz = [313,313];
    case 748
        fileName = '20161008_1_dark';
        numImages = 11031;
        fr = 5;
        sz = [172,162];
    case 749
        fileName = '20161008_1_light';
        numImages = 10331;
        fr = 5;
        sz = [188,182];
    case 750
        fileName = '20161008_2_dark';
        numImages = 11230;
        fr = 5;
        sz = [306,207];
    case 751
        fileName = '20161008_2_light';
        numImages = 7100;
        fr = 5;
        sz = [256,256];
    case 752
        fileName = '20161010_1_dark';
        numImages = 9610;
        fr = 5;
        sz = [317,320];
    case 753
        fileName = '20161010_1_light';
        numImages = 10883;
        fr = 5;
        sz = [277,288];
    case 754
        fileName = '20161010_2_dark';
        numImages = 9586;
        fr = 5;
        sz = [285,276];
    case 755
        fileName = '20161010_2_light';
        numImages = 12560;
        fr = 5;
        sz = [238,351];
    case 756
        fileName = '20161014_1_dark';
        numImages = 10198;
        fr = 5;
        sz = [286,303];
    case 757
        fileName = '20161014_1_light';
        numImages = 10203;
        fr = 5;
        sz = [251,254];
    case 758
        fileName = '20161014_2_dark';
        numImages = 12012;
        fr = 5;
        sz = [287,304];
    case 759
        fileName = '20161014_2_light';
        numImages = 9678;
        fr = 5;
        sz = [376,386];
    % green hydra
    case 760
        fileName = '20170126_green_dark-1';
        numImages = 32716;
        fr = 5;
        sz = [335,335];
    case 761
        fileName = '20170126_green_dark-2';
        numImages = 32716;
        fr = 5;
        sz = [344,344];
    case 762
        fileName = '20170126_green_dark-3';
        numImages = 32716;
        fr = 5;
        sz = [356,356];
    case 763
        fileName = '20170126_green_dark-4';
        numImages = 32716;
        fr = 5;
        sz = [358,358];
    case 764
        fileName = '20170126_green_dark-5';
        numImages = 15000;
        fr = 5;
        sz = [352,325];
    case 765
        fileName = '20170201_green_dark-1';
        numImages = 32216;
        fr = 5;
        sz = [318,318];
    case 766
        fileName = '20170201_green_dark-2';
        numImages = 32716;
        fr = 5;
        sz = [318,318];
    case 767
        fileName = '20170201_green_dark-3';
        numImages = 32716;
        fr = 5;
        sz = [358,358];
    case 768
        fileName = '20170201_green_dark-4';
        numImages = 32716;
        fr = 5;
        sz = [281,281];
    case 769
        fileName = '20170201_green_dark-5';
        numImages = 14000;
        fr = 5;
        sz = [310,310];
    case 770
        fileName = '20170202_green_dark-1';
        numImages = 32716;
        fr = 5;
        sz = [127,127];
    case 771
        fileName = '20170202_green_dark-2';
        numImages = 32716;
        fr = 5;
        sz = [110,110];
    case 772
        fileName = '20170202_green_dark-3';
        numImages = 32716;
        fr = 5;
        sz = [119,119];
    case 773
        fileName = '20170202_green_dark-4';
        numImages = 32716;
        fr = 5;
        sz = [113,113];
    case 774
        fileName = '20170202_green_dark-5';
        numImages = 32716;
        fr = 5;
        sz = [109,109];
    case 775
        fileName = '20170202_green_dark-6';
        numImages = 32716;
        fr = 5;
        sz = [127,127];
    case 776
        fileName = '20170202_green_dark-7';
        numImages = 32716;
        fr = 5;
        sz = [132,132];
    case 777
        fileName = '20170202_green_dark-8';
        numImages = 23945;
        fr = 5;
        sz = [121,121];
    case 778
        fileName = '20170207_green_dark-1';
        numImages = 32716;
        fr = 5;
        sz = [223,223];
    case 779
        fileName = '20170207_green_dark-2';
        numImages = 32716;
        fr = 5;
        sz = [257,241];
    case 780
        fileName = '20170207_green_dark-3';
        numImages = 32716;
        fr = 5;
        sz = [231,231];
    case 781
        fileName = '20170207_green_dark-4';
        numImages = 32716;
        fr = 5;
        sz = [353,313];
    case 782
        fileName = '20170207_green_dark-5';
        numImages = 32716;
        fr = 5;
        sz = [305,326];
    case 783
        fileName = '20170207_green_dark-6';
        numImages = 28215;
        fr = 5;
        sz = [247,247];
    case 784
        fileName = '20170208_green_dark-1';
        numImages = 32716;
        fr = 5;
        sz = [127,127];
    case 785
        fileName = '20170208_green_dark-2';
        numImages = 32716;
        fr = 5;
        sz = [171,171];
    case 786
        fileName = '20170208_green_dark-3';
        numImages = 32716;
        fr = 5;
        sz = [195,195];
    case 787
        fileName = '20170208_green_dark-4';
        numImages = 32716;
        fr = 5;
        sz = [208,217];
    case 788
        fileName = '20170208_green_dark-5';
        numImages = 32716;
        fr = 5;
        sz = [172,172];
    case 789
        fileName = '20170208_green_dark-6';
        numImages = 32716;
        fr = 5;
        sz = [255,302];
    case 790
        fileName = '20170208_green_dark-7';
        numImages = 39763;
        fr = 5;
        sz = [263,264];
    % ---------------- big/small dataset --------------- %
    case 901
        fileName = '20170201_large_1';
        numImages = 18022;
        fr = 5;
        sz = [208,208];
    case 902
        fileName = '20170201_small_1';
        numImages = 18739;
        fr = 5;
        sz = [124,124];
    case 903
        fileName = '20170202_large_1';
        numImages = 17921;
        fr = 5;
        sz = [275,275];
    case 904
        fileName = '20170202_small_1';
        numImages = 19097;
        fr = 5;
        sz = [171,171];
    case 905
        fileName = '20170202_small_2';
        numImages = 18340;
        fr = 5;
        sz = [187,187];
    case 906
        fileName = '20170206_large_1';
        numImages = 18397;
        fr = 5;
        sz = [206,206];
    case 907
        fileName = '20170206_small_1';
        numImages = 18072;
        fr = 5;
        sz = [148,148];
    case 908
        fileName = '20170207_large_1';
        numImages = 19719;
        fr = 5;
        sz = [298,298];
    case 909
        fileName = '20170207_large_2';
        numImages = 21782;
        fr = 5;
        sz = [293,293];
    case 910
        fileName = '20170207_small_1';
        numImages = 17954;
        fr = 5;
        sz = [158,158];
    % ---------------- day/night dataset --------------- %
    case 1001
        fileName = 'Day1-1';
        numImages = 8170;
        fr = 2;
        sz = [127,146];
    case 1002
        fileName = 'Day1-2';
        numImages = 8179;
        fr = 2;
        sz = [135,141];
    case 1003
        fileName = 'Day1-3';
        numImages = 8179;
        fr = 2;
        sz = [140,138];
    case 1004
        fileName = 'Day1-4';
        numImages = 8179;
        fr = 2;
        sz = [132,136];
    case 1005
        fileName = 'Day1-5';
        numImages = 8179;
        fr = 2;
        sz = [134,140];
    case 1006
        fileName = 'Day1-6';
        numImages = 8179;
        fr = 2;
        sz = [133,139];
    case 1007
        fileName = 'Day1-7';
        numImages = 8179;
        fr = 2;
        sz = [142,135];
    case 1008
        fileName = 'Day1-8';
        numImages = 8179;
        fr = 2;
        sz = [130,130];
    case 1009
        fileName = 'Day1-9';
        numImages = 8179;
        fr = 2;
        sz = [138,134];
    case 1010
        fileName = 'Day1-10';
        numImages = 8179;
        fr = 2;
        sz = [133,135];
    case 1011
        fileName = 'Day1-11';
        numImages = 4542;
        fr = 2;
        sz = [141,143];
    case 1012
        fileName = 'Night1-1';
        numImages = 8170;
        fr = 2;
        sz = [126,126];
    case 1013
        fileName = 'Night1-2';
        numImages = 8179;
        fr = 2;
        sz = [116,110];
    case 1014
        fileName = 'Night1-3';
        numImages = 8179;
        fr = 2;
        sz = [112,111];
    case 1015
        fileName = 'Night1-4';
        numImages = 8179;
        fr = 2;
        sz = [105,113];
    case 1016
        fileName = 'Night1-5';
        numImages = 8179;
        fr = 2;
        sz = [123,135];
    case 1017
        fileName = 'Night1-6';
        numImages = 8179;
        fr = 2;
        sz = [124,129];
    case 1018
        fileName = 'Night1-7';
        numImages = 8179;
        fr = 2;
        sz = [126,136];
    case 1019
        fileName = 'Night1-8';
        numImages = 8179;
        fr = 2;
        sz = [117,130];
    case 1020
        fileName = 'Night1-9';
        numImages = 8179;
        fr = 2;
        sz = [112,127];
    case 1021
        fileName = 'Night1-10';
        numImages = 8179;
        fr = 2;
        sz = [115,126];
    case 1022
        fileName = 'Night1-11';
        numImages = 4613;
        fr = 2;
        sz = [116,117];
    case 1023
        fileName = 'Day2-1';
        numImages = 8164;
        fr = 2;
        sz = [111,125];
    case 1024
        fileName = 'Day2-2';
        numImages = 8179;
        fr = 2;
        sz = [115,117];
    case 1025
        fileName = 'Day2-3';
        numImages = 8179;
        fr = 2;
        sz = [143,156];
    case 1026
        fileName = 'Day2-4';
        numImages = 8179;
        fr = 2;
        sz = [116,130];
    case 1027
        fileName = 'Day2-5';
        numImages = 8179;
        fr = 2;
        sz = [145,144];
    case 1028
        fileName = 'Day2-6';
        numImages = 8179;
        fr = 2;
        sz = [146,132];
    case 1029
        fileName = 'Day2-7';
        numImages = 8179;
        fr = 2;
        sz = [133,156];
    case 1030
        fileName = 'Day2-8';
        numImages = 8179;
        fr = 2;
        sz = [130,154];
    case 1031
        fileName = 'Day2-9';
        numImages = 8179;
        fr = 2;
        sz = [128,132];
    case 1032
        fileName = 'Day2-10';
        numImages = 8179;
        fr = 2;
        sz = [119,122];
    case 1033
        fileName = 'Day2-11';
        numImages = 4613;
        fr = 2;
        sz = [124,108];
    case 1034
        fileName = 'Night2-1';
        numImages = 8163;
        fr = 2;
        sz = [117,110];
    case 1035
        fileName = 'Night2-2';
        numImages = 8179;
        fr = 2;
        sz = [125,116];
    case 1036
        fileName = 'Night2-3';
        numImages = 8179;
        fr = 2;
        sz = [111,111];
    case 1037
        fileName = 'Night2-4';
        numImages = 8179;
        fr = 2;
        sz = [120,122];
    case 1038
        fileName = 'Night2-5';
        numImages = 8179;
        fr = 2;
        sz = [111,114];
    case 1039
        fileName = 'Night2-6';
        numImages = 8179;
        fr = 2;
        sz = [119,106];
    case 1040
        fileName = 'Night2-7';
        numImages = 8179;
        fr = 2;
        sz = [123,113];
    case 1041
        fileName = 'Night2-8';
        numImages = 8179;
        fr = 2;
        sz = [117,127];
    case 1042
        fileName = 'Night2-9';
        numImages = 8179;
        fr = 2;
        sz =[132,118];
    case 1043
        fileName = 'Night2-10';
        numImages = 8179;
        fr = 2;
        sz = [124,133];
    case 1044
        fileName = 'Night2-11';
        numImages = 4613;
        fr = 2;
        sz = [117,111];
    case 1045
        fileName = 'Day3-1';
        numImages = 8168;
        fr = 2;
        sz = [147,150];
    case 1046
        fileName = 'Day3-2';
        numImages = 8179;
        fr = 2;
        sz = [131,116];
    case 1047
        fileName = 'Day3-3';
        numImages = 8179;
        fr = 2;
        sz = [122,126];
    case 1048
        fileName = 'Day3-4';
        numImages = 8179;
        fr = 2;
        sz = [129,137];
    case 1049
        fileName = 'Day3-5';
        numImages = 8179;
        fr = 2;
        sz = [134,126];
    case 1050
        fileName = 'Day3-6';
        numImages = 8179;
        fr = 2;
        sz = [140,131];
    case 1051
        fileName = 'Day3-7';
        numImages = 8179;
        fr = 2;
        sz = [135,139];
    case 1052
        fileName = 'Day3-8';
        numImages = 8179;
        fr = 2;
        sz = [126,118];
    case 1053
        fileName = 'Day3-9';
        numImages = 8179;
        fr = 2;
        sz = [134,129];
    case 1054
        fileName = 'Day3-10';
        numImages = 8179;
        fr = 2;
        sz = [118,122];
    case 1055
        fileName = 'Day3-11';
        numImages = 4613;
        fr = 2;
        sz = [120,127];
    case 1056
        fileName = 'Night3-1';
        numImages = 8163;
        fr = 2;
        sz = [118,116];
    case 1057
        fileName = 'Night3-2';
        numImages = 8179;
        fr = 2;
        sz = [110,108];
    case 1058
        fileName = 'Night3-3';
        numImages = 8179;
        fr = 2;
        sz = [106,114];
    case 1059
        fileName = 'Night3-4';
        numImages = 8179;
        fr = 2;
        sz = [102,116];
    case 1060
        fileName = 'Night3-5';
        numImages = 8179;
        fr = 2;
        sz = [113,114];
    case 1061
        fileName = 'Night3-6';
        numImages = 8179;
        fr = 2;
        sz = [106,112];
    case 1062
        fileName = 'Night3-7';
        numImages = 8179;
        fr = 2;
        sz = [111,107];
    case 1063
        fileName = 'Night3-8';
        numImages = 8179;
        fr = 2;
        sz = [119,116];
    case 1064
        fileName = 'Night3-9';
        numImages = 8179;
        fr = 2;
        sz = [120,113];
    case 1065
        fileName = 'Night3-10';
        numImages = 8179;
        fr = 2;
        sz = [104,98];
    case 1066
        fileName = 'Night3-11';
        numImages = 4613;
        fr = 2;
        sz = [105,105];
    % --------------- well-fed big/small dataset -------------- %
    case 1101
        fileName = '20170221_fed_light_1';
        numImages = 20794;
        fr = 5;
        sz = [238,238];
    case 1102
        fileName = '20170221_fed_light_2';
        numImages = 17900;
        fr = 5;
        sz = [253,253];
    case 1103
        fileName = '20170221_fed_light_3';
        numImages = 10664;
        fr = 5;
        sz = [365,365];
    case 1104
        fileName = '20170223_small_fed_light_1';
        numImages = 16018;
        fr = 5;
        sz = [233,233];
    case 1105
        fileName = '20170223_small_fed_light_10';
        numImages = 18038;
        fr = 5;
        sz = [240,240];
    case 1106
        fileName = '20170223_small_fed_light_2';
        numImages = 15358;
        fr = 5;
        sz = [249,249];
    case 1107
        fileName = '20170223_small_fed_light_3';
        numImages = 18257;
        fr = 5;
        sz = [344,344];
    case 1108
        fileName = '20170223_small_fed_light_4';
        numImages = 18082;
        fr = 5;
        sz = [226,226];
    case 1109
        fileName = '20170223_small_fed_light_5';
        numImages = 14881;
        fr = 5;
        sz = [245,245];
    case 1110
        fileName = '20170223_small_fed_light_6';
        numImages = 19993;
        fr = 5;
        sz = [256,256];
    case 1111
        fileName = '20170223_small_fed_light_7';
        numImages = 16140;
        fr = 5;
        sz = [225,225];
    case 1112
        fileName = '20170223_small_fed_light_8';
        numImages = 17068;
        fr = 5;
        sz = [171,171];
    case 1113
        fileName = '20170223_small_fed_light_9';
        numImages = 16547;
        fr = 5;
        sz = [198,198];
    case 1114
        fileName = '20170224_large_fed_light_1';
        numImages = 15074;
        fr = 5;
        sz = [197,197];
    case 1115
        fileName = '20170227_big_fed_light_1';
        numImages = 9006;
        fr = 5;
        sz = [192,192];
    case 1116
        fileName = '20170227_big_fed_light_2';
        numImages = 16631;
        fr = 5;
        sz = [199,199];
    case 1117
        fileName = '20170227_big_fed_light_3';
        numImages = 18007;
        fr = 5;
        sz = [171,171];
    case 1118
        fileName = '20170227_big_fed_light_4';
        numImages = 18005;
        fr = 5;
        sz = [206,206];
    case 1119
        fileName = '20170227_big_fed_light_5';
        numImages = 19990;
        fr = 5;
        sz = [180,180];
    case 1120
        fileName = '20170227_big_fed_light_6';
        numImages = 17348;
        fr = 5;
        sz = [232,232];
    case 1121
        fileName = '20170228_big_fed_light_1';
        numImages = 20694;
        fr = 5;
        sz = [207,207];
    case 1122
        fileName = '20170228_big_fed_light_2';
        numImages = 15681;
        fr = 5;
        sz = [331,331];
    case 1123
        fileName = '20170228_big_fed_light_3';
        numImages = 18134;
        fr = 5;
        sz = [325,325];
    case 1124
        fileName = '20170228_big_fed_light_4';
        numImages = 18628;
        fr = 5;
        sz = [214,214];
    case 1125
        fileName = '20170228_big_fed_light_5';
        numImages = 20390;
        fr = 5;
        sz = [193,193];
        
     % ------------------------- flat prep ----------------------- %
    case 1201
        fileName = '20170216_flat_1';
        numImages = 10458;
        fr = 5;
        sz = [312,312];
    case 1202
        fileName = '20170216_flat_2';
        numImages = 10820;
        fr = 5;
        sz = [204,204];
    case 1203
        fileName = '20170216_flat_3';
        numImages = 11329;
        fr = 5;
        sz = [216,216];
    case 1204
        fileName = '20170217_flat_1';
        numImages = 10612;
        fr = 5;
        sz = [285,285];
    case 1205
        fileName = '20170217_flat_3';
        numImages = 9718;
        fr = 5;
        sz = [258,258];
    case 1206
        fileName = '20170217_flat_4';
        numImages = 10526;
        fr = 5;
        sz = [258,258];
    case 1207
        fileName = '20170217_flat_5';
        numImages = 9654;
        fr = 5;
        sz = [242,242];
    case 1208
        fileName = '20170217_flat_6';
        numImages = 13406;
        fr = 5;
        sz = [201,201];
    case 1209
        fileName = '20170217_flat_7';
        numImages = 10293;
        fr = 5;
        sz = [187,187];
    case 1210
        fileName = '20170217_flat_8';
        numImages = 9110;
        fr = 5;
        sz = [146,146];
    case 1211
        fileName = '20170220_flat_1';
        numImages = 10972;
        fr = 5;
        sz = [185,185];
    case 1212
        fileName = '20170220_flat_2';
        numImages = 10467;
        fr = 5;
        sz = [257,257];
    case 1213
        fileName = '20170220_flat_3';
        numImages = 10029;
        fr = 5;
        sz = [156,156];
    case 1214
        fileName = '20170220_flat_4';
        numImages = 9604;
        fr = 5;
        sz = [262,262];
    case 1215
        fileName = '20170220_flat_5';
        numImages = 8588;
        fr = 5;
        sz = [199,199];
    case 1216
        fileName = '20170220_flat_6';
        numImages = 9232;
        fr = 5;
        sz = [185,185];
    case 1217
        fileName = '20170220_flat_7';
        numImages = 10548;
        fr = 5;
        sz = [227,227];
    case 1218
        fileName = '20170221_flat_1';
        numImages = 9279;
        fr = 5;
        sz = [159,159];
    case 1219
        fileName = '20170221_flat_2';
        numImages = 11915;
        fr = 5;
        sz = [242,242];
    case 1220
        fileName = '20170221_flat_3';
        numImages = 9703;
        fr = 5;
        sz = [222,222];
    case 1221
        fileName = '20170221_flat_4';
        numImages = 8810;
        fr = 5;
        sz = [218,218];
    case 1222
        fileName = '20170221_flat_5';
        numImages = 9774;
        fr = 5;
        sz = [259,259];
    case 1223
        fileName = '20170221_flat_6';
        numImages = 8859;
        fr = 5;
        sz = [188,188];
    case 1224
        fileName = '20170221_flat_7';
        numImages = 9067;
        fr = 5;
        sz = [209,209];
    case 1225
        fileName = '20170222_flat_1';
        numImages = 8952;
        fr = 5;
        sz = [161,161];
    case 1226
        fileName = '20170222_flat_2';
        numImages = 8159;
        fr = 5;
        sz = [166,166];
    case 1227
        fileName = '20170222_flat_3';
        numImages = 9047;
        fr = 5;
        sz = [202,202];
    case 1228
        fileName = '20170222_flat_4';
        numImages = 10054;
        fr = 5;
        sz = [221,221];
    case 1229
        fileName = '20170222_flat_5';
        numImages = 9821;
        fr = 5;
        sz = [208,208];

    otherwise
        error('file does not exist');
end

end
