
movieParam.filePath = 'C:\Users\shuting\Desktop\temp\';
movieParam.fileName = '20151130_2_10hz_pz50hz_test';
movieParam.numImages = 200;
movieParam.frameEnd = 200;
movieParam.bitDepth = 16;
movieParam.fr = 10;

% pyramid_factor=[0.1,0.5,0.8,0.95];
% pyramid_level=[10,50,100];
% beta=[0.01,0.1,0.5,0.9];
% lambda = [1,5,10,50];
% warps = [1,5,10];
% max_iter = 100;

pyramid_factor = 0.1;
pyramid_level = 10;
beta = [0.001,0.1,0.5];
lambda = [0.1,1,10];
warps = 1;
max_iter = 50;

check = 0;
handles = [];

im1 = double(imread([movieParam.filePath movieParam.fileName '.tif'],1));
im1 = wiener2(im1,[3 3]);
im2 = double(imread([movieParam.filePath movieParam.fileName '.tif'],2));
im2 = wiener2(im2,[3 3]);

flows = cell(length(lambda)*length(beta)*length(pyramid_level)*length(pyramid_factor)*length(warps),1);
params = zeros(length(lambda)*length(beta)*length(pyramid_level)*length(pyramid_factor)*length(warps),5);
count = 1;
for a = 1:length(lambda)
    for b = 1:length(beta)
        for c = 1:length(pyramid_level)
            for d = 1:length(pyramid_factor)
                for e = 1:length(warps)
                    tic;
                    flows{count} = coarse_to_fine(im1,im2,lambda(a), beta(b), warps(e), max_iter, ...
                        pyramid_level(c), pyramid_factor(d), check, handles);
                    params(count,:)=[lambda(a),beta(b),pyramid_level(c),pyramid_factor(d),warps(e)];
                    fprintf('cycle %u\n',count);
                    toc;
                    count = count+1;
                end
            end
        end
    end
end