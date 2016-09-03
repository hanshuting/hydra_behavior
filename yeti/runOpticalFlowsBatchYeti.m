function [] = runOpticalFlowsBatchYeti(fileind,arrayID)

%fileind = 27;

tic;
addpath('/u/10/s/sh3276/code/motion_estimation/');
%% set parameters

fprintf('processing file %u, part %u\n',fileind,arrayID);

scriptsize = 50;
movieParam = paramAllBatchYeti(fileind,arrayID,scriptsize);
filepath = ['/vega/brain/users/sh3276/results/flows/' movieParam.fileName '_flows_int16_' num2str(arrayID) '.mat'];

pyramid_factor = 0.95;
pyramid_levels = 1;
beta = 0.5;
lambda = 0.1;
warps = 50;
%lambda = 0.1;
%beta = 0.1;
%pyramid_levels = 10;
%pyramid_factor = 0.8;
%warps = 10;
check = 0;
handles = [];
max_iter = 100;

%% estimate flows

uu = zeros(movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages-1,'int16');
vv = zeros(movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages-1,'int16');

im2 = double(imread([movieParam.filePath movieParam.fileName '.tif'],1));
im2 = 255-im2;
im2 = medfilt2(im2,[5,5]); 

for i = 1:movieParam.numImages-1 

    fprintf('processing frame %d\n',i);
    
    % calculate flows
    im1 = im2;
    im2 = double(imread([movieParam.filePath movieParam.fileName '.tif'],movieParam.frameStart+i));
    
    im2 = 255-im2;
    im2 = medfilt2(im2,[5,5]);

    flow_all = coarse_to_fine(im1, im2, lambda, beta, warps, max_iter, ...
        pyramid_levels, pyramid_factor, check, handles);
    
    uu(:,:,i) = int16(flow_all(:,:,1)*1000);
    vv(:,:,i) = int16(flow_all(:,:,2)*1000);
    
    

end

fprintf('int16 limit: %d; max value: %d, %d; min value: %d, %d\n',...
    2^15,max(uu(:)),max(vv(:)),min(uu(:)),min(vv(:)));

%% save result

save(filepath,'uu','vv','-v7.3');
display(filepath);

toc;

end
