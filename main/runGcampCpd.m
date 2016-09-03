% test script for coherent point drift

%% parameters
if 0
fileInd = 202;
movieParam = paramAll(fileInd);

% cpd parameters
opt.method = 'nonrigid';
opt.scale = 0;
opt.normalize = 0;
opt.corresp = 1;
opt.outliers = 0.5;
opt.beta = 10;
opt.viz = 0;

% load mask
load(['E:\Data\register_param\mask\' movieParam.fileName '_mask.mat']);
end
%% detect cells
cellR = 1;
max_d = 20; %maximum distance allowed for points matching
allCoords = cell(movieParam.numImages,1);
% T = cell(movieParam.numImages-1,1);
figure;
for i = 1:movieParam.numImages
    
    % load image
    im = double(imread([movieParam.filePath movieParam.fileName '.tif'],i));
    
    % my gmm detection code
%     im_smooth = imgaussfilt(im,1).*double(bw(:,:,i));
%     if i==1
%         initThresh = (max(im_smooth(:))-min(im_smooth(:)))*0.05+min(im_smooth(:));
%     end
%     coords = fit_2d_gaussian(im_smooth,1,initThresh,0);
%     coords = coords(:,[2,1]);

    % another version
    im_smooth = imgaussfilt(im,1);
    cellInfo = detectNuclei(im_smooth,cellR);
    coords = [cellInfo.xCoord(:,1),cellInfo.yCoord(:,1)];
    [maskxx,maskyy]=ind2sub(size(im),find(bw(:,:,i)~=0));
    inregIndx = ismember(coords,[maskyy,maskxx],'rows');
    coords = coords(inregIndx,:);
    
    if i==1
        % user selection at the first frame
        imagesc(im);colormap(gray);
        hold on;scatter(coords(:,1),coords(:,2),'r');
        [roi,xx,yy] = choose_polygon2(size(im,2),size(im,1));
        initIndx = inpolygon(coords(:,1),coords(:,2),xx,yy);
        prevCoords = coords(initIndx,:);
        allCoords{i} = prevCoords;
        
    else
        
        % cpd
        prevCoords = allCoords{i-1};
        [T,C] = cpd_register(coords,prevCoords,opt);
        
        % discard outliers
        keepCoords = coords(C,:);
        D = sqrt(sum((prevCoords-keepCoords).^2,2));
        Dindx = D<=max_d;
        keepCoords = keepCoords(Dindx,:);
        
        % find the convex hull of the kept transformed points
        convh = convhull(keepCoords(:,1),keepCoords(:,2));
        Hindx = inpolygon(keepCoords(:,1),keepCoords(:,2),keepCoords(convh,1),...
            keepCoords(convh,2));
        allCoords{i} = keepCoords(Hindx,:);
        
        % visualize
        imagesc(im);colormap(gray);title(num2str(i));
        hold on;scatter(keepCoords(Hindx,1),keepCoords(Hindx,2),'r');pause(0.01);
    end
    
end

