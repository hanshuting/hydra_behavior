
fileIndx = [1:5,7:11,13:24,26:28,30:34];
savepath = '/home/sh3276/work/results/register_param/seg/';

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
    
    %fprintf('processed time window:      0/%u',numT);
    parfor i = 1:numT
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],i));
        [seg_im,theta(i),centroid(i,:),a(i),b(i)] = getBwRegion2(im);
        segAll(:,:,i) = uint8(seg_im);
%       imagesc(seg_fr);
%       title(num2str(i));pause(0.01);

        % update progress text
        %fprintf(repmat('\b',1,length(num2str(numT))+length(num2str(i))+1));
        %fprintf('%u/%u',i,numT);
    end
    %fprintf('\n');
    
    save([savepath movieParam.fileName '_seg.mat'],'segAll','theta','centroid','a','b','-v7.3');
    
end
