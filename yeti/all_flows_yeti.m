addpath('/u/10/s/sh3276/code/motion_estimation/');

fileInd = 1;

movieParam = paramAll(fileInd);

pyramid_factor=[0.5,0.8,0.95];
pyramid_levels=[1,10,50];
beta=[0.01,0.1,0.2,0.5];
lambda=[1,10,50,100];
warps = 1;
max_iter = 100;
check = 0;
handles = [];

imageRaw1 = double(imread([movieParam.filenameImages movieParam.filenameBasis...
movieParam.enumString(1,:) '.tif']));

imageRaw2 = double(imread([movieParam.filenameImages movieParam.filenameBasis...
movieParam.enumString(2,:) '.tif']));

flows = cell(144,1);
count = 1;
params = zeros(144,4);
for a = 1:4
    for b = 1:4
        for c = 1:3
            for d = 1:3
                flows{count} = coarse_to_fine(imageRaw1,imageRaw2,lambda(a), beta(b), warps, max_iter,pyramid_levels(c), pyramid_factor(d), check, handles);
                params(count,:) = [lambda(a),beta(b),pyramid_levels(c),pyramid_factor(d)];
                display(count);
                count = count+1;
            end
        end
    end
end

save(['/vega/brain/users/sh3276/results/grids_step1.mat']);
