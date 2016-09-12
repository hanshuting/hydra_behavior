function [segAll,theta,centroid,a,b] = runBPSegmentation(movieParam)

fprintf('processing %s...\n',movieParam.fileName);

% initialize
segAll = zeros([movieParam.imageSize,movieParam.numImages],'uint8');
theta = zeros(movieParam.numImages,1);
centroid = zeros(movieParam.numImages,2);
a = zeros(movieParam.numImages,1);
b = zeros(movieParam.numImages,1);%  +Tsa
numT = movieParam.numImages;

fprintf('processed time window:      0/%u',numT);
for i = 1:numT
    im = double(imread([movieParam.filePath movieParam.fileName '.tif'],i));
    [seg_im,theta(i),centroid(i,:),a(i),b(i)] = getBwRegion2(im);
%    [seg_im,theta(i),centroid(i,:),a(i),b(i)] = getBwRegion3(im);
    segAll(:,:,i) = uint8(seg_im);
%   imagesc(seg_fr);
%   title(num2str(i));pause(0.01);

    % update progress text
    fprintf(repmat('\b',1,length(num2str(numT))+length(num2str(i))+1));
    fprintf('%u/%u',i,numT);
end
fprintf('\n');

    
end
