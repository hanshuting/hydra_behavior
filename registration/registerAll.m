function [uu_reg,vv_reg,bw_reg,thetas,centroids,as] = registerAll(movieParam,uu,vv,bw,bg,time_step)
% register hydra videos, and calculate the orientation, centroid and length
% SYNOPSIS:
%     [uu_reg,vv_reg,bw_reg,thetas,centroids,as] = registerAll(movieParam,uu,vv,bw,bg,time_step)
% INPUT:
%     movieParam: a struct returned by function paramAll
%     uu, vv: M-by-N-by-T matrices with optical flow in x and y direction, 
%       [M N] is the size of videos, T is the number of total frames
%     bw: binary mask with segmented region
%     bg: estimated background image (currently not used)
%     time_step: number of frames in each time window
% OUTPUT:
%     uu_reg, vv_reg: registered flow matrices
%     bw_reg: registered mask matrix
%     thetas: T-by-1 vector, with the orientations of hydra
%     centroids: T-by-2 matrix, with the centroids of hydra
%     as: T-by-1 vector, with the length of hydra
% 
% Shuting Han, 2015

% initialization
dims = size(uu);
uu_reg = cast(zeros(dims),'like',uu);
vv_reg = cast(zeros(dims),'like',vv);
bw_reg = false(dims);
thetas = zeros(dims(3),1);
centroids = zeros(dims(3),2);
as = zeros(dims(3),1);
tt = floor(movieParam.numImages/time_step);

% progress text
fprintf('processed time window:      0/%u',tt);

% register the rest based on the first image
for i = 1:tt
    
%     tw_theta = zeros(time_step,1);
%     tw_centroid = zeros(time_step,2);
%     tw_a = zeros(time_step,1);
    
    % take the average angle and centroid in the time window
    for k = 1:time_step
        
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],...
            (i-1)*time_step+k));
        
        immax = max(im(:));
        im = round(im/immax*255);
    
        % align and fit ellipse
        if i==1 && k==1
            [thetas((i-1)*time_step+k),centroids((i-1)*time_step+k,:),...
                as((i-1)*time_step+k),~,rarea] = registerIm(im);
        else
            [thetas((i-1)*time_step+k),centroids((i-1)*time_step+k,:),...
                as((i-1)*time_step+k),~,rarea] = registerIm(im,rareaprev,centroidprev);
        end
        centroidprev = centroids((i-1)*time_step+k,:);
        rareaprev = rarea;
        
        % visualization
        %imagesc(im);colormap(gray);title(num2str((i-1)*time_step+k));
        %axis equal tight;
        %tmp.Centroid=tw_centroid(k,:); tmp.MajorAxisLength=tw_a(k);
        %tmp.MinorAxisLength=b; tmp.Orientation=tw_theta(k);
        %hold on;plot_ellipse2(tmp);
        %quiver(tmp.Centroid(1),tmp.Centroid(2),cos(degtorad(tw_theta(k)))*tw_a(k),...
        %    -sin(degtorad(tw_theta(k)))*tw_a(k));
        %xlim([0 movieParam.imageSize(2)]);ylim([0 movieParam.imageSize(1)]);
        %hold off
        %pause(0.01);
        
    end
    
%     thetas(i) = trimmean(tw_theta,50);
%     centroids(i,:) = trimmean(tw_centroid,50,1);
%     as(i) = trimmean(tw_a,50);
    
    cr_theta = 90-trimmean(thetas((i-1)*time_step+1:i*time_step),50);
    cr_cent = trimmean(centroids((i-1)*time_step+1:i*time_step,:),50,1);
    rotmat = [cos(degtorad(-cr_theta)) -sin(degtorad(-cr_theta)); ...
              sin(degtorad(-cr_theta)) cos(degtorad(-cr_theta))];
    
    % register each frame
    for j = 1:time_step
        
        % register flow vectors
        f_uu = squeeze(double(uu(:,:,(i-1)*time_step+j)));
        f_vv = squeeze(double(vv(:,:,(i-1)*time_step+j)));
        cr_flow = [f_uu(:),f_vv(:)];
        reg_cr_flow = rotmat*cr_flow';
        reg_cr_flow = reg_cr_flow';
        f_uu_reg = reshape(reg_cr_flow(:,1),dims(1),dims(2));
        f_vv_reg = reshape(reg_cr_flow(:,2),dims(1),dims(2));
        f_uu_reg = imrotate(imtranslate(f_uu_reg,[movieParam.imageSize(1)/2-cr_cent(1)...
            movieParam.imageSize(2)/2-cr_cent(2)]),cr_theta,'crop');
        f_vv_reg = imrotate(imtranslate(f_vv_reg,[movieParam.imageSize(1)/2-cr_cent(1)...
            movieParam.imageSize(2)/2-cr_cent(2)]),cr_theta,'crop');
        f_uu_reg = cast(f_uu_reg,'like',uu);
        f_vv_reg = cast(f_vv_reg,'like',vv);
        uu_reg(:,:,(i-1)*time_step+j) = f_uu_reg;
        vv_reg(:,:,(i-1)*time_step+j) = f_vv_reg;
        
        % register mask and flows
        f_bw = squeeze(double(bw(:,:,(i-1)*time_step+j)));
        bw_reg(:,:,(i-1)*time_step+j) = imrotate(imtranslate(f_bw,...
            [movieParam.imageSize(1)/2-cr_cent(1) movieParam.imageSize(2)/2-...
            cr_cent(2)]),cr_theta,'crop');

        %imagesc(bw_reg(:,:,(i-1)*time_step+j));colormap(gray);pause(0.01);
          
    end
    
    % update progress text
    fprintf(repmat('\b',1,length(num2str(tt))+length(num2str(i))+1));
    fprintf('%u/%u',i,tt);
    
end

uu_reg = cast(uu_reg,'like',uu);
vv_reg = cast(vv_reg,'like',vv);

fprintf('\n');

end