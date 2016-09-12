function [filePath,fileName,numImages,fr] = fileinfo_win(indx)

% a function that stores all path and file name information

switch indx
    %%%%%%%%%%%% bright field behavior data %%%%%%%%%%%%%%%
    case 1
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150218_light_1_5hz_resized'; %9000
        numImages = 9000;
        fr = 5;
    case 2
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150218_light_2_5hz_resized'; %9000
        numImages = 9000;
        fr = 5;
    case 3
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150311_EC_light'; %7074
        numImages = 7000;
        fr = 5;
    case 4
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150410_1'; %7722
        numImages = 7500;
        fr = 5;
    case 5
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150410_4'; %3762
        numImages = 3500;
        fr = 5;
    case 6
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150410_6'; %7684
        numImages = 7500;
        fr = 5;
    case 7
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150411_1'; % 3500
        numImages = 3500;
        fr = 5;
    case 8
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150411_4'; % 8622
        numImages = 8500;
        fr = 5;
    case 9
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150504_1'; % 9500
        numImages = 9500;
        fr = 5;
    case 10
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150504_2'; % 9800
        numImages = 9800;
        fr = 5;
    case 11
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150504_3'; % 6100
        numImages = 6000;
        fr = 5;
    case 12
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150504_4'; % 9518
        numImages = 9500;
        fr = 5;
    case 13
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150504_5'; % 9001
        numImages = 9000;
        fr = 5;
    case 14
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150813_1_floating';
        numImages = 7263;
        fr = 5;
    case 15
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150813_2_feeding';
        numImages = 6000; % 6001
        fr = 5;
    case 16
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150813_3_feeding';
        numImages = 7493;
        fr = 5;
    case 17
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150813_4_feeding';
        numImages = 5862;
        fr = 5;
    case 18
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150813_5';
        numImages = 1900; % 1902
        fr = 5;
    case 19
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150813_6_somersaulting_feeding';
        numImages = 8098;
        fr = 5;
    case 20
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150814_1_somersaulting';
        numImages = 2783;
        fr = 5;
    case 21
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20150814_2_somersaulting';
        numImages = 4562;
        fr = 5;
    case 22
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20141218_somersaulting';
        numImages = 4658;
        fr = 5;
    case 23
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20151107_1';
        numImages = 8899;
        fr = 5;
    case 24
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20151107_2';
        numImages = 4900;
        fr = 5;
    case 25
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20151107_3';
        numImages = 7059;
        fr = 5;
    case 26
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20151109_1';
        numImages = 9801;
        fr = 5;
    case 27
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20151109_2';
        numImages = 7962;
        fr = 5;
    case 28
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20151109_3';
        numImages = 8812;
        fr = 5;
    case 29
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20151109_4';
        numImages = 9543;
        fr = 5;
    case 30
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20151110_1';
        numImages = 9726;
        fr = 5;
    case 31
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20151110_2';
        numImages = 7766;
        fr = 5;
    case 32
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20151110_3';
        numImages = 9810;
        fr = 5;
    case 33
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20151111_1';
        numImages = 8393;
        fr = 5;
    case 34
        filePath = 'C:\Shuting\Data\freely_moving\individual_samples\';
        fileName = '20151111_2';
        numImages = 5915;
        fr = 5;
        
    %%%%%%%%%%%%%%%%%% CD data %%%%%%%%%%%%%%%
    % CD SF normal
    case 101
        filePath = 'E:\charles_processed\';
        fileName = '08052013_004_lef_'; %2820
        numImages = 2820;
        fr = 1;
    case 102
        filePath = 'E:\charles_processed\';
        fileName = '08052013_005_left'; %7766
        numImages = 7766;
        fr = 1;
    case 103
        filePath = 'E:\charles_processed\';
        fileName = '11052013_004_left';
        numImages = 7897;
        fr = 1;
    case 104
        filePath = 'E:\charles_processed\';
        fileName = '11052013_004_right';
        numImages = 7897;
        fr = 1;
    case 105
        filePath = 'E:\charles_processed\';
        fileName = '06052013_001';
        numImages = 5847;
        fr = 1;
    case 106
        filePath = 'E:\charles_processed\';
        fileName = '06052013_002';
        numImages = 8003;
        fr = 1;
    case 107
        filePath = 'E:\charles_processed\';
        fileName = '06052013_003';
        numImages = 14971;
        fr = 1;
    % CD hydra 11062013
    case 108
        filePath = 'E:\charles_processed\11062013\hydra001\';
        fileName = 'NFtransplant3_001_left';
        numImages = 5655;
        fr = 10;
    case 109
        filePath = 'E:\charles_processed\11062013\hydra001\';
        fileName = 'NFtransplant3_001_right';
        numImages = 5655;
        fr = 10;
    case 110
        filePath = 'E:\charles_processed\11062013\hydra001\';
        fileName = 'SF-NF_and_NF-SF_grafts_10hours_left';
        numImages = 361;
        fr = 10;
    case 111
        filePath = 'E:\charles_processed\11062013\hydra001\';
        fileName = 'SF-NF_and_NF-SF_grafts_10hours_right';
        numImages = 361;
        fr = 10;
    case 112
        filePath = 'E:\charles_processed\11062013\hydra002\';
        fileName = 'NFtransplant3_002_left';
        numImages = 1264;
        fr = 10;
    case 113
        filePath = 'E:\charles_processed\11062013\hydra002\';
        fileName = 'NFtransplant3_002_right';
        numImages = 1264;
        fr = 10;
    case 114
        filePath = 'E:\charles_processed\11062013\hydra003\';
        fileName = 'NFtransplant3_003_left';
        numImages = 1552;
        fr = 10;
    case 115
        filePath = 'E:\charles_processed\11062013\hydra003\';
        fileName = 'NFtransplant3_003_right';
        numImages = 1552;
        fr = 10;
    case 116
        filePath = 'E:\charles_processed\11062013\hydra004\';
        fileName = 'NFtransplant3_004_left';
        numImages = 5758;
        fr = 10;
    case 117
        filePath = 'E:\charles_processed\11062013\hydra004\';
        fileName = 'NFtransplant3_004_right';
        numImages = 5758;
        fr = 10;
    case 118
        filePath = 'E:\charles_processed\11062013\hydra005\';
        fileName = 'NFtransplant3_005_left';
        numImages = 3527;
        fr = 10;
    case 119
        filePath = 'E:\charles_processed\11062013\hydra005\';
        fileName = 'NFtransplant3_005_right';
        numImages = 3527;
        fr = 10;
    case 120
        filePath = 'E:\charles_processed\11062013\hydra005\';
        fileName = 'SF-NF_and_NF-SF_grafts_48hours_left';
        numImages = 361;
        fr = 10;
    case 121
        filePath = 'E:\charles_processed\11062013\hydra005\';
        fileName = 'SF-NF_and_NF-SF_grafts_48hours_right';
        numImages = 361;
        fr = 10;
    case 122
        filePath = 'E:\charles_processed\11062013\hydra006\';
        fileName = 'NFtransplant3_006_left';
        numImages = 5885;
        fr = 10;
    case 123
        filePath = 'E:\charles_processed\11062013\hydra006\';
        fileName = 'NFtransplant3_006_right';
        numImages = 5885;
        fr = 10;
    case 124
        filePath = 'E:\charles_processed\11062013\hydra007\';
        fileName = 'NFtransplant3_007_left';
        numImages = 2471;
        fr = 10;
    case 125
        filePath = 'E:\charles_processed\11062013\hydra007\';
        fileName = 'NFtransplant3_007_right';
        numImages = 2471;
        fr = 10;
    case 126
        filePath = 'E:\charles_processed\11062013\hydra008\';
        fileName = 'NFtransplant3_008_left';
        numImages = 6451;
        fr = 10;
    case 127
        filePath = 'E:\charles_processed\11062013\hydra008\';
        fileName = 'NFtransplant3_008_right';
        numImages = 6451;
        fr = 10;
    case 128
        filePath = 'E:\charles_processed\';
        fileName = 'SF_normal_test_058_1-4000_left';
        numImages = 4000;
        fr = 10;
    case 129
        filePath = 'E:\charles_processed\';
        fileName = 'SF_normal_test_058_1-4000_right';
        numImages = 2000;
        fr = 10;
    case 131
        filePath = 'E:\charles_processed\';
        fileName = 'SF_normal_055_720-3240_left';
        numImages = 2521;
        fr = 10;
    case 132
        filePath = 'E:\charles_processed\';
        fileName = 'SF_normal_055_720-3240_right';
        numImages = 2521;
        fr = 10;
    case 133
        filePath = 'E:\charles_processed\';
        fileName = 'Regen_Tops_056_2500-5000_left';
        numImages = 2501;
        fr = 10;
    case 134
        filePath = 'E:\charles_processed\';
        fileName = 'Regen_Tops_056_2500-5000_right';
        numImages = 2501;
        fr = 10;
    case 135
        filePath = 'E:\charles_processed\';
        fileName = '28052013_SF_Regen_001_left';
        numImages = 1800;
        fr = 10;
    case 136
        filePath = 'E:\charles_processed\';
        fileName = '28052013_SF_Regen_001_right';
        numImages = 1800;
        fr = 10;
    case 137
        filePath = 'E:\charles_processed\';
        fileName = '28052013_SF_Regen_002_left';
        numImages = 6197;
        fr = 10;
    case 138
        filePath = 'E:\charles_processed\';
        fileName = '28052013_SF_Regen_002_right';
        numImages = 6197;
        fr = 10;
    case 139
        filePath = 'E:\charles_processed\';
        fileName = '08052013_001_left';
        numImages = 1785;
        fr = 10;
    case 140
        filePath = 'E:\charles_processed\';
        fileName = '08052013_002_left';
        numImages = 5476;
        fr = 10;
    case 141
        filePath = 'E:\charles_processed\';
        fileName = '20052003_001_left';
        numImages = 4450;
        fr = 10;
    case 142
        filePath = 'E:\charles_processed\';
        fileName = '20052003_001_right';
        numImages = 4450;
        fr = 10;
    %%%%%%%%%%%%%%%%%% GCaMP6s neural data %%%%%%%%%%%%%%%%
    case 200
        filePath = 'C:\Users\shuting\Desktop\temp\';
        fileName = '20151130_2_10hz_pz50hz_smoothed';
        numImages = 2686;
        fr = 10;
    case 201
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra1_baseline_1';
        numImages = 2500;
        fr = 10;
    case 202
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra1_baseline_2';
        numImages = 2430;
        fr = 10;
    case 203
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra1_GSM_1';
        numImages = 1200;
        fr = 10;
    case 204
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra1_GSM_2';
        numImages = 2790;
        fr = 10;
    case 205
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra2_baseline_1';
        numImages = 3000;
        fr = 10;
    case 206
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra2_baseline_2';
        numImages = 3000;
        fr = 10;
    case 207
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra2_baseline_3';
        numImages = 733;
        fr = 10;
    case 208
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra2_GSM_1';
        numImages = 3000;
        fr = 10;
    case 209
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra2_4AP_1';
        numImages = 2500;
        fr = 10;
    case 210
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra2_4AP_2';
        numImages = 2921;
        fr = 10;
    case 211
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra3_baseline_1';
        numImages = 2500;
        fr = 10;
    case 212
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra3_baseline_2';
        numImages = 2238;
        fr = 10;
    case 213
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra3_GSM_1';
        numImages = 1275;
        fr = 10;
    case 214
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra3_GSM_2';
        numImages = 1690;
        fr = 10;
    case 215
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra4_baseline';
        numImages = 2909;
        fr = 10;
    case 216
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra4_GSM';
        numImages = 1869;
        fr = 10;
    case 217
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra4_4AP_1';
        numImages = 781;
        fr = 10;
    case 218
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra4_4AP_2';
        numImages = 2235;
        fr = 10;
    case 219
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra4_4AP_3';
        numImages = 1705;
        fr = 10;
    case 220
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra4_4AP_4';
        numImages = 1909;
        fr = 10;
    case 221
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra4_4AP_recover_1';
        numImages = 3000;
        fr = 10;
    case 222
        filePath = 'E:\Data\20151026_GCaMP6_Feeding_4AP\';
        fileName = 'hydra4_4AP_recover_2';
        numImages = 3927;
        fr = 10;
    case 223
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra2_baseline';
        numImages = 4087;
        fr = 10;
    case 224
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra2_mk801_1mM_1';
        numImages = 3000;
        fr = 10;
    case 225
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra2_mk801_1mM_2';
        numImages = 3369;
        fr = 10;
    case 226
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra2_mk801_10mM_1';
        numImages = 3368;
        fr = 10;
    case 227
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra2_mk801_10mM_2';
        numImages = 3623;
        fr = 10;
    case 228
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra3_baseline';
        numImages = 3911;
        fr = 10;
    case 229
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra3_NMDA_10mM';
        numImages = 7272;
        fr = 10;
    case 230
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra3_NMDA_100uM_1';
        numImages = 3048;
        fr = 10;
    case 231
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra3_NMDA_100uM_2';
        numImages = 2031;
        fr = 10;
    case 232
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra4_baseline';
        numImages = 3313;
        fr = 10;
    case 233
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra4_dopamine_10mM_1';
        numImages = 2203;
        fr = 10;
    case 234
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra4_dopamine_10mM_2';
        numImages = 1454;
        fr = 10;
    case 235
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra4_dopamine_10mM_3';
        numImages = 1062;
        fr = 10;
    case 236
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra4_dopamine_10mM_4';
        numImages = 2280;
        fr = 10;
    case 237
        filePath = 'E:\Data\20151029_GCaMP6_dopamine_mk801_NMDA\';
        fileName = 'hydra4_dopamine_100uM';
        numImages = 2666;
        fr = 10;
    case 238
        filePath = 'E:\Data\20151211_g6s_feeding\';
        fileName = '20151211_1';
        numImages = 3057;
        fr = 10;
    case 239
        filePath = 'E:\Data\20151211_g6s_feeding\';
        fileName = '20151211_1_GSM';
        numImages = 2797;
        fr = 10;
    % ------------- 20151124 red light imaging ------------------%
    case 301
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_1';
        numImages = 8172;
        fr = 5;
    case 302
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_2';
        numImages = 8172;
        fr = 5;
    case 303
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_3';
        numImages = 8172;
        fr = 5;
    case 304
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_4';
        numImages = 8172;
        fr = 5;
    case 305
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_5';
        numImages = 8172;
        fr = 5;
    case 306
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_6';
        numImages = 8172;
        fr = 5;
    case 307
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_7';
        numImages = 8172;
        fr = 5;
    case 308
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_8';
        numImages = 8172;
        fr = 5;
    case 309
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_9';
        numImages = 8172;
        fr = 5;
    case 310
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_10';
        numImages = 8172;
        fr = 5;
    case 311
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_11';
        numImages = 8172;
        fr = 5;
    case 312
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_12';
        numImages = 8172;
        fr = 5;
    case 313
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_13';
        numImages = 8172;
        fr = 5;
    case 314
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_14';
        numImages = 8172;
        fr = 5;
    case 315
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_15';
        numImages = 8172;
        fr = 5;
    case 316
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_16';
        numImages = 8172;
        fr = 5;
    case 317
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_17';
        numImages = 8172;
        fr = 5;
    case 318
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_18';
        numImages = 8172;
        fr = 5;
    case 319
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_19';
        numImages = 8172;
        fr = 5;
    case 320
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_20';
        numImages = 8172;
        fr = 5;
    case 321
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_21';
        numImages = 8172;
        fr = 5;
    case 322
        filePath = 'C:\Shuting\Data\freely_moving\20151124_red_imaging\';
        fileName = '20151124_red_imaging_22';
        numImages = 3104;
        fr = 5;
    % -------------------------
    case 323
        filePath = 'E:\Data\20151203_redlight\';
        fileName = '20151203_redlight_1';
        numImages = 8172;
        fr = 5;
    case 324
        filePath = 'E:\Data\20151203_redlight\';
        fileName = '20151203_redlight_2';
        numImages = 8172;
        fr = 5;
    case 325
        filePath = 'E:\Data\20151203_redlight\';
        fileName = '20151203_redlight_3';
        numImages = 8172;
        fr = 5;
    case 326
        filePath = 'E:\Data\20151203_redlight\';
        fileName = '20151203_redlight_4';
        numImages = 8172;
        fr = 5;
    case 327
        filePath = 'E:\Data\20151203_redlight\';
        fileName = '20151203_redlight_5';
        numImages = 8172;
        fr = 5;
    case 328
        filePath = 'E:\Data\20151203_redlight\';
        fileName = '20151203_redlight_6';
        numImages = 8172;
        fr = 5;
    case 329
        filePath = 'E:\Data\20151203_redlight\';
        fileName = '20151203_redlight_7';
        numImages = 8172;
        fr = 5;
    case 330
        filePath = 'E:\Data\20151203_redlight\';
        fileName = '20151203_redlight_8';
        numImages = 8172;
        fr = 5;
    case 331
        filePath = 'E:\Data\20151203_redlight\';
        fileName = '20151203_redlight_9';
        numImages = 8172;
        fr = 5;
    case 332
        filePath = 'E:\Data\20151203_redlight\';
        fileName = '20151203_redlight_10';
        numImages = 8172;
        fr = 5;
    case 333
        filePath = 'E:\Data\20151203_redlight\';
        fileName = '20151203_redlight_11';
        numImages = 8172;
        fr = 5;
    case 334
        filePath = 'E:\Data\20151203_redlight\';
        fileName = '20151203_redlight_12';
        numImages = 1346;
        fr = 5;
    % ------------------------ GFP dataset ------------------------%
    case 401
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_1';
        numImages = 6178;
        fr = 10;
    case 402
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_2';
        numImages = 5479;
        fr = 10;
    case 403
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_3';
        numImages = 6007;
        fr = 10;
    case 404
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_4';
        numImages = 4559;
        fr = 10;
    case 405
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_5';
        numImages = 5541;
        fr = 10;
    case 406
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_6';
        numImages = 5232;
        fr = 10;
    case 407
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_7';
        numImages = 5887;
        fr = 10;
    case 408
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_8';
        numImages = 6001;
        fr = 10;
    case 409
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_9';
        numImages = 5785;
        fr = 10;
    case 410
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_10';
        numImages = 5141;
        fr = 10;
    case 411
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_11';
        numImages = 5494;
        fr = 10;
    case 412
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_12';
        numImages = 5986;
        fr = 10;
    case 413
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_13';
        numImages = 5378;
        fr = 10;
    case 414
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_14';
        numImages = 2570;
        fr = 10;
    case 415
        filePath = 'E:\Data\20151203_gfp\';
        fileName = '20151203_GFP_15';
        numImages = 3500;
        fr = 10;
    otherwise
        error('file does not exist');
end

end