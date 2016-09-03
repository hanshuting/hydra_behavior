tic;

addpath('/u/10/s/sh3276/code/motion_estimation/');

%% set parameters
fileInd = 1; 

movieParam = paramAll_yeti(fileInd);

pyramid_factor = 0.5;
pyramid_levels = 1;
beta = 0.01;
lambda = 1;
warps = 1;
max_iter = 100;
check = 0;
handles = [];

%% estimate flows
uu = zeros(movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages-1,'single');
vv = zeros(movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages-1,'single');

im2 = double(imread([movieParam.filePath movieParam.fileName '.tif'],1));

for i = 2:movieParam.numImages 

    % calculate flows
    im1 = im2;
    im2 = double(imread([movieParam.filePath movieParam.fileName '.tif'],i));
    flow_all = coarse_to_fine(im1, im2, lambda, beta, warps, max_iter, ...
        pyramid_levels, pyramid_factor, check, handles);
    
    uu(:,:,i-1) = single(flow_all(:,:,1));
    vv(:,:,i-1) = single(flow_all(:,:,2));
    
    display(i);
    
end

%% save result
save(['/vega/brain/users/sh3276/results/flows6.mat']);

toc;
