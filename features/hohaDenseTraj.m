function [x_points, y_points, v_points] = hohaDenseTraj(params,grid_step)
% Dense_trajectories(forw_flow, back_flow, grid_step)
%-------------------------------------------------------%
% input:
%       params : parameters structure -  im_path, flo_path
%                                        first  , last
%       grid_step : sampling step
% Output: 
%       x_points : N_points x Frames, x dimension 
%       y_points : N_points x Frames, y dimension
%       v_points : N_points x Frames, v=1 new track,
%                                     v=0 continue tracking
%                                     v=-1 lost track
%--------------------------------------------------------%
  
%------------------------------------------------------%   
% parameters
im_path = params.im_path;
flow_path = params.flow_path;
first = params.first;
last = params.last;
sigma = params.corner_sigma;
s_patch = params.corner_patch;
norm_const = params.norm_const;
tol_const = params.tol_const;
m_norm_const = params.m_norm_const;
m_tol_const = params.m_tol_const;
corner_thresh = params.corner_thresh;
patch_s = params.patch_s;
per_threshold = params.per_threshold;
is_plotting = params.is_plotting;
im_name = params.im_name;
len_fr = length(first:last);

%------------------------------------------------------%
% Reading size of images
im = double(imread([im_path im_name '.tif'],first));
[M,N,x] = size(im);
  
% Creating the grid
[X_grid,Y_grid] = meshgrid(1:grid_step:M,1:grid_step:N);
[M_p,N_p] = size(X_grid);
X_grid = single(X_grid(:));
Y_grid = single(Y_grid(:));
  
[M_N_p] = size(X_grid,1);
x_points = single(zeros(M_N_p*2, len_fr -1));
y_points = single(zeros(M_N_p*2, len_fr -1));
v_points =   int8(zeros(M_N_p*2, len_fr -1));
  
% Setup First Frame Points
x_points(1:M_N_p,1) = single(X_grid);
y_points(1:M_N_p,1) = single(Y_grid);
v_points(1:M_N_p,1) = int8(ones(M_N_p,1));
v_points(M_N_p+1:2*M_N_p,1) = int8(-ones(M_N_p,1));
  
count = 1;
load([flow_path im_name '_flows_assembled_int16.mat']);
for fr = first : last-1

    im = double(imread([im_path im_name '.tif'],fr));
    
%     forw = load(fullfile(flow_path, sprintf(forw_name, fr)));

    % Median  Filter of Optical Flow
%     forw.fvx = medfilt2(forw.vx,[3 3], 'symmetric');
%     forw.fvy = medfilt2(forw.vy,[3 3], 'symmetric');
    fvx = medfilt2(double(uu_all(:,:,fr)),[3 3], 'symmetric');
    fvy = medfilt2(double(vv_all(:,:,fr)),[3 3], 'symmetric');    

    w_f = cat(3,fvx,fvy);
    w_b = [];
    
    % Find Corneness of each pixel
    corn = cornerness_im2(im, s_patch, sigma);
    
    corn = corn > corner_thresh;
    
    % Occlusion Boundaries using Symmetry Constraints 
    % & Motion Boundary detection
    [mb]  = sym_occl_detection(w_f, w_b, norm_const,...
                               tol_const, m_norm_const, m_tol_const,0 );
    
    
    % Clean Small Boundaries & Enhance the uncertain region
    se1 = strel('disk',1);
    mb1 = imerode(mb, se1);
    mb1 = imdilate(mb1, se1);
    mb1 = imdilate(mb1, se1);
    mb1 = bwmorph(mb1, 'majority');
    
    %----------------------------------------------------
    % Propage Track Points
    %----------------------------------------------------
    x_points(1:M_N_p,count+1) = single(X_grid);
    y_points(1:M_N_p,count+1) = single(Y_grid);
    v_points(1:M_N_p,count+1) = int8(ones(M_N_p,1));
    v_points(M_N_p+1:2*M_N_p,count+1) = int8(-ones(M_N_p,1));

    count = count+1;
 
    if is_plotting 
      
      figure(1);
      
      subplot(3,2,1); imagesc(mb);colormap('jet');
      subplot(3,2,2); imagesc(corn);
      subplot(3,2,3); imagesc(mb1);
      subplot(3,2,5); flowshow_prctl(w_f);
      drawnow;
      figure(2);
      imshow(im);
      hold on;
      plot(y_points(v_points(:,count)>=0, count) ,...
           x_points(v_points(:,count)>=0, count),'.b');
      
    end
    
end 
  
end
  