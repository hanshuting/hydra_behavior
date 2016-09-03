function [] = runOpticalFlowsYeti(fileind)

tic;
addpath('/u/10/s/sh3276/code/motion_estimation/');

%% set parameters

movieParam = paramAll_yeti(fileind);
filepath = ['/vega/brain/users/sh3276/results/flows/' movieParam.fileName 'flows_assembled_int16.mat'];

pyramid_factor = 0.95;
pyramid_levels = 1;
beta = 0.5;
lambda = 0.1;
warps = 50;
check = 0;
handles = [];
max_iter = 100;

%% estimate flows

uu = int16(zeros(movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages-1));
vv = int16(zeros(movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages-1));

parfor i = 2:movieParam.numImages 
    
    fprintf('processing frame %d\n',i);

    % calculate flows
    im1 = double(imread([movieParam.filePath movieParam.fileName '.tif'],i-1));
    im2 = double(imread([movieParam.filePath movieParam.fileName '.tif'],i));
    
    im1 = 255-im1;
    im1 = medfilt2(im1,[5,5]);
    im2 = 255-im2;
    im2 = medfilt2(im2,[5,5]);

    flow_all = coarse_to_fine(im1, im2, lambda, beta, warps, max_iter, ...
        pyramid_levels, pyramid_factor, check, handles);
    
    uu(:,:,i-1) = int16(flow_all(:,:,1)*1000);
    vv(:,:,i-1) = int16(flow_all(:,:,2)*1000);
    
end

fprintf('int16 limit: %d; max value: %d, %d; min value: %d, %d\n',...
    2^15,max(uu(:)),max(vv(:)),min(uu(:)),min(vv(:)));

%% save result
save(filepath);
display(filepath);

toc;

end
