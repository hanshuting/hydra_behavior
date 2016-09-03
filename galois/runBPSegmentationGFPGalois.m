
fileIndx = [401:432];
% fileIndx = 26;
savepath = '/home/sh3276/work/results/register_param/seg_gfp_6parts_20160307/';

for n = 1:length(fileIndx)

    movieParam = paramAll_galois(fileIndx(n));
    fprintf('processing %s...\n',movieParam.fileName);
    
    % initialize
    segAll = zeros([movieParam.imageSize,movieParam.numImages],'uint8');
    theta = zeros(movieParam.numImages,1);
    centroid = zeros(movieParam.numImages,2);
    a = zeros(movieParam.numImages,1);
    b = zeros(movieParam.numImages,1);
    numT = movieParam.numImages;

    parfor i = 1:numT
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],i));
%         [seg_im,theta(i),centroid(i,:),a(i),b(i)] = getBwRegion2(im);
        [seg_im,theta(i),centroid(i,:),a(i),b(i)] = getBwRegionGFP3(im);
        segAll(:,:,i) = uint8(seg_im);

    end
    
    save([savepath movieParam.fileName '_seg.mat'],'segAll','theta','centroid','a','b','-v7.3');
    
end

delete(gcp);