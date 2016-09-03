
%% initialize
rng(1000);

%% parameters
fileIndx = [1:5,7:11,13:24,26:28,30:32];
% parampath = 'C:\Shuting\Data\DT_results\register_param\';
parampath = '/home/sh3276/work/results/register_param/';
outputsz = [100,100];
hydrasz = 50;
ci = 90;

%% get registered and scaled images
im_train = [];
for i = 1:length(fileIndx)
    
%     movieParam = paramAll(fileIndx(i));
    movieParam = paramAll_galois(fileIndx(i));
    fprintf('collecting data from %s...\n',movieParam.fileName);
    load([parampath movieParam.fileName '_results_params_step_1.mat']);
    
    num_frame = movieParam.numImages;
    subindx = randperm(num_frame,round(num_frame*0.1));
    im_mat = zeros(length(subindx),outputsz(1)*outputsz(2));
    
    % registration
    for j = 1:subindx
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],j));
        im = imrotate(imtranslate(im,[movieParam.imageSize(1)/2-...
            hydraCent(j,1) movieParam.imageSize(2)/2-...
            hydraCent(j,2)]),90-hydraOri(j),'crop');
                
        % keep only the segmented region
        im = im.*bwReg(:,:,j);
        im = mat2gray(im);
        
        % scale
        im = imresize(im,hydrasz/hydraLength(j));
        imrsz = size(im);
        im_final = zeros(size(im,1)+outputsz(1),size(im,2)+outputsz(2));
        im_final(round((size(im_final,1)-imrsz(1))/2)+1:...
            round((size(im_final,1)-imrsz(1))/2)+imrsz(1),...
            round((size(im_final,2)-imrsz(2))/2)+1:...
            round((size(im_final,2)-imrsz(2))/2)+imrsz(2)) = im;
        im_final = im_final(round((size(im_final,1)-outputsz(1))/2)+1:...
            round((size(im_final,1)-outputsz(1))/2)+outputsz(1),...
            round((size(im_final,2)-outputsz(2))/2)+1:...
            round((size(im_final,2)-outputsz(2))/2)+outputsz(2));
        
        % store image
        im_mat(j,:) = reshape(im_final,1,[]);
        
    end
    
    im_train(end+1:end+size(im_mat,1),:) = im_mat;
    
end

%% pca
fprintf('pca...\n');
[coeff,score,latent,tsquared,explained,mu] = pca(im_train);

% plot explained variance curve
expcum = cumsum(explained);
figure;plot(expcum);

% get eigenmodes
num_mode = find(expcum>ci,1);

% plot eigenmodes
N = ceil(sqrt(num_mode));
M = ceil(num_mode/N);
figure;set(gcf,'color','w')
for i = 1:num_mode
    h = subplot(M,N,i);
    imagesc(reshape(coeff(:,i),outputsz));
    colormap(gray);title(num2str(i));
    axis equal off
end

%% generate pc representation
pc_spec = [];
for i = 1:length(fileIndx)
    
    movieParam = paramAll_galois(fileIndx(i));
    fprintf('collecting data from %s...\n',movieParam.fileName);
    load([parampath movieParam.fileName '_results_params_step_1.mat']);

    pc_mat = zeros(movieParam.numImages,num_mode);
    
    % take entire time windows
    for j = 1:size(bwReg,3)

        % registration
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],j));
        im = imrotate(imtranslate(im,[movieParam.imageSize(1)/2-...
            hydraCent(j,1) movieParam.imageSize(2)/2-...
            hydraCent(j,2)]),90-hydraOri(j),'crop');        
        im = im.*bwReg(:,:,j);
        im = mat2gray(im);
        
        % scale
        im = imresize(im,hydrasz/hydraLength(j));
        imrsz = size(im);
        im_final = zeros(size(im,1)+outputsz(1),size(im,2)+outputsz(2));
        im_final(round((size(im_final,1)-imrsz(1))/2)+1:...
            round((size(im_final,1)-imrsz(1))/2)+imrsz(1),...
            round((size(im_final,2)-imrsz(2))/2)+1:...
            round((size(im_final,2)-imrsz(2))/2)+imrsz(2)) = im;
        im_final = im_final(round((size(im_final,1)-outputsz(1))/2)+1:...
            round((size(im_final,1)-outputsz(1))/2)+outputsz(1),...
            round((size(im_final,2)-outputsz(2))/2)+1:...
            round((size(im_final,2)-outputsz(2))/2)+outputsz(2));
        
        % pc representation
%         pc_mat(j,:) = reshape(im_final,1,[])*coeff(:,1:num_mode);
        pc_mat(j,:) = reshape(im_final,1,[])*coeff(:,1:num_mode)./sqrt(latent(1:num_mode)');

    end
    
    pc_spec(end+1:end+size(pc_mat,1),:) = pc_mat;
    
end
