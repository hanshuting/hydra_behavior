tic;
%% set parameters
t_step=5;
movieParam = paramAll(t_step);

pyramid_factor = 0.95;
pyramid_levels = 10;
beta = 0.05;
lambda = 0.05;
warps = 1;
max_iter = 100;
check = 0;
handles = [];

%% estimate flows

uu = zeros(movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages-1,'single');
vv = zeros(movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages-1,'single');

im2 = double(imread([movieParam.filenameImages movieParam.filenameBasis...
    movieParam.enumString(1,:) '.tif']));

for i = 2:movieParam.numImages 

    % calculate flows
    im1 = im2;
    im2 = double(imread([movieParam.filenameImages movieParam.filenameBasis...
        movieParam.enumString(i,:) '.tif']));
    flow_all = coarse_to_fine(im1, im2, lambda, beta, warps, max_iter, ...
        pyramid_levels, pyramid_factor, check, handles);
    
    uu(:,:,i-1) = single(flow_all(:,:,1));
    vv(:,:,i-1) = single(flow_all(:,:,2));
    
    display(i);
    
end

%% save result
%save(['/vega/brain/users/sh3276/results/flows10.mat']);

toc;