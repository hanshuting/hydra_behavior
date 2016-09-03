function hoha_video_cluster(varargin)
% HOHA_VIDEO_CLUSTER 
% Video Segmentation--Clustering of Dense Trajectories
% Hollywood Dataset -- Script

% Author:  Michalis Raptis
% Affiliation:  Disney Research, UCLA 

% Copyright (C) 2007-12 Michalis Raptis
% This file is available under the terms of the
% GNU GPLv2, or (at your option) any later version.

server = 0;
part_index = [ 1 2 3  4 5 6 7 8 9 10 ];

addpath('../ocode/flow_utils/');
addpath('../ocode/l1_tv_pock/');

ind_start= 1;%:448;
ind_end  = 448;


% Code Directory
main_code = pwd;

% Optical Flow Utilities Code

oflow_path = fullfile('../ocode', 'flow_utils');


%Directory of the Action Dataset ()

im_data   = fullfile('..','data','hoha','videoclips');

main_data_= fullfile('..','data','hoha');

% Saved Data Directory -- Optical Flow Directory
flow_data = fullfile('..','data','hoha','flow');

% adding paths
addpath(oflow_path);
addpath(main_code);

% Saved Data Directory
  
saved_data = fullfile('..','data','hoha','keys'); if ~exist(saved_data,'dir'); mkdir(saved_data);end
video_data = fullfile('..','data','hoha', 'video');if ~exist(video_data,'dir'); mkdir(video_data);end
tracks_data= fullfile('..','data','hoha', 'tracks');if ~exist(tracks_data,'dir'); mkdir(tracks_data);end
groups_data= fullfile('..','data','hoha', 'groups');if ~exist(groups_data,'dir'); mkdir(groups_data);end
log_data   = fullfile('..','data','hoha', 'log_data');if ~exist(log_data,'dir'); mkdir(log_data);end

part_index = 1;
K = 100;         
grid_step = 5;
scree = 0;
params.im_path = [];
parmas.flow_path = [];
params.first    = [];
params.last     = [];
params.im_name  = [];
params.corner_sigma = 1;
params.corner_patch = 5;
params.norm_const = 0.01; % Occlusion Detection Threshold
params.tol_const = 0.5;
params.m_norm_const = 0.03;% Motion Boundary Detection
params.m_tol_const = 0.1;
params.corner_thresh = 1e-5;
params.patch_s = 5; % 2*Patch : window that check for density of
                    % points
params.per_threshold = 0.0002;
params.thresh_move = 5;
params.min_length  = 3;

params.dist_thre   = 30;

params.is_plotting = 0;
params.plot_tracks = 0;
params.plot_clusters = 1;
params.make_video  = 0;
one_color = 0;
recompute = 0;
% Reading input Arguments
for k= 1:2: length(varargin)
  opt = lower(varargin{k});
  arg = varargin{k+1};
  switch opt
      case 'part_index' %
          part_index = arg;
      case  'scree'
          scree = arg; % Scree test 0 (Fast Heuristic) or  1
      case 'corner_sigma'
          params.corner_sigma = arg;
      case 'corner_patch'
          params.corner_patch = arg;
      case 'norm_const'
          params.nrom_const = arg;
      case 'tol_const'
          params.tol_const = arg;
      case 'm_tol_const'
          params.m_tol_const = arg;
      case 'corner_thresh'
          params.corner_thresh = arg;
      case 'patch_s'
          params.patch_s = arg;
      case 'thresh_move'
          params.thresh_move = arg;
      case 'is_plotting'
          params.is_plotting = arg;
      case 'grid_size'
          grid_size  = arg;
      case 'plot_tracks'
          plot_tracks = arg;
      case 'plot_clusters'
          plot_clusters = arg;
      case 'make_video'
          params.make_video = arg;
      case 'one_color'
          one_color = arg;
      otherwise
          opt
          error('Unknown Argument')
  end
end

if isempty(part_index)
    error('part index not define');
end

if part_index > length(ind_start);
  error('Part index larger than dataset classes');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load Annotation for the Videos of HOHA
load(fullfile(main_data_,'hoha_annotation_corrected.mat'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for ii= ind_start(part_index): ind_end(part_index)
  
  name_perf = files_struct{ii}.name;
  disp(name_perf);

  start_fr = files_struct{ii}.start;
  last_fr  = files_struct{ii}.last; 
  actions_name = files_struct{ii}.action;
  len_fr = length(start_fr:last_fr);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  pos_names = { 'AsGoodAsItGets-00259'}; % Run only this Video of
                                         % the HoHA dataset

  flag = 0;
  for pr = 1: length(pos_names)
    if (strcmp( name_perf, pos_names{pr} ))
      flag = 1;
      continue;
    end
  end
  if  ~flag 
    continue;
  end
    
  if ~one_color
    video_name = fullfile(video_data, sprintf('%s_%04d.avi',name_perf,start_fr));
  else
    video_name = fullfile(video_data, sprintf('%s_%04d_one_color.avi',name_perf,start_fr));
  end
  
  params.flow_path = fullfile(flow_data,name_perf);
  params.im_path = fullfile(im_data, name_perf);
  
  tracks_name = fullfile(tracks_data, sprintf('%s_%04d.mat', name_perf, start_fr));
  groups_name = fullfile(groups_data, sprintf('%s_%04d.mat', name_perf, start_fr));
  
  params.first= start_fr;
  params.last = last_fr;
  params.flow_name = 'Forward%04d.mat';
  min_length = params.min_length;
  %------------------------------------------------------%
  % Dense Tracking 
  %------------------------------------------------------%
  if ~exist(tracks_name,'file') || recompute
    [x_track, y_track, v_track] = hoha_dense_trajectories(params,grid_step);
   
    %------------------------------------------------------%
    % Create Data Structure for Trajectories
    %------------------------------------------------------%
    flag =1;
    while (flag)
      [first_feat last_feat line_feat] = traj2Struct_mex(x_track,y_track,v_track, min_length-1);
      NN = length(first_feat);
      if NN < 21000;
        flag= 0;
      else
        min_length = min_length+1;
      end
    end
    clear('tracks');
    for xi= 1 : NN
      
      tracks(xi).loc = int32([ floor(x_track(line_feat(xi)+1, first_feat(xi)+1: last_feat(xi)+1).*10  ); ...
                          floor(y_track(line_feat(xi)+1, first_feat(xi)+1: last_feat(xi)+1 ).*10)]);
      tracks(xi).fe = int32([(first_feat(xi)+1) (last_feat(xi)+1)]);
    end
    clear('first_feat','last_feat','line_feat','x_track','y_track','v_track');
    
    
    %------------------------------------------------------%
    % Prune Trajectories that Don't move
    %------------------------------------------------------%
    
    tracks = prune_traj_move(tracks, params.thresh_move);
      
    if length(tracks)> 20000
      fprintf(1, 'Potential Memory Issue, Skipping Action: %s, Sequence %s Start_fr %d\n',...
              actions_name, name_perf, start_fr);
      %fprintf(fid, 'Skipping Action: %s, Sequence %s Start_fr %d\n', actions_name, name_perf, start_fr);
      continue;
    end
    %------------------------------------------------------%
    % Plot Trajectories 
    %------------------------------------------------------%
    if params.plot_tracks
      current_fr = params.first;
      cur = 1;
      for fr = 1: len_fr-1
        im = imread(fullfile(params.im_path, sprintf('image%04d.png',current_fr)));
        figure(1);
        imshow(im);
        hold on;
        for ii = 1:length(tracks)
          if (cur<= tracks(ii).fe(2) && cur >= tracks(ii).fe(1))
            plot(double(tracks(ii).loc(2,tracks(ii).fe(1): ...
                                       cur -tracks(ii).fe(1)+1))/10, ...
                 double(tracks(ii).loc(1,tracks(ii).fe(1):...
                                       cur -tracks(ii).fe(1)+1))/10,'-r');
            
            plot(double(tracks(ii).loc(2, cur -tracks(ii).fe(1)+1))/10, ...
                 double(tracks(ii).loc(1, cur -tracks(ii).fe(1)+1))/10,...
                 '.b','MarkerSize',9);
          end
          
        end
        drawnow
        pause(0.1);
        current_fr = current_fr+1;
        cur = cur+1;
      end
    end
  else
    load(tracks_name);
  end
  
  if ~exist(groups_name,'file')  || recompute
    %------------------------------------------------------%
    % Calculate Affinity Matrix 
    %------------------------------------------------------%
        
    disp('Calculating Velocity Distance');

    Vel = trajectoryVelocityDistance(tracks);

    Ax = exp(-Vel);
    clear('Vel');
    disp('Calculating Trajectory Intersection Distance');
    DI  = trajectoryIntersectionDistance(tracks);
    Ax = Ax.^( 1./DI);
    clear('DI');
    
    disp('Calculating Spatial Distance');
    dist_thre = single( params.dist_thre);
    Dsp = trajectorySpatialDistance(tracks);
    Ax = Ax.^((Dsp+eps)/(dist_thre/3));
    disp('Calculating Nearest Neighbor');
    NNx = single( knn_h(Dsp, 30,dist_thre));
    
    Ax = Ax.*NNx;
    clear('Dsp','NNx');
        
    % Remove Single - Connected Points of the Graph
    xx = sum(Ax);
    ind = (xx ==1);
    Ax = Ax(:,~ind);
    Ax = Ax(~ind,:);
    tracks = tracks(~ind);
    
    %--------------------------------------------------%
    % Save Trajectories 
    %--------------------------------------------------%e
    
    save(tracks_name,'tracks');
    
    % Find The connected Components of The Graph

    Labels = comp(Ax);
    max_comp = max(Labels);
    
    scales_group = [1:4];
    asize_group = [50 200 500 1000];
    ac_const    = [ 10^(-5) 10^(-4) 10^(-3) 10^(-1)];
    for comp_ = 1: max_comp
      if sum(Labels==comp_)>1
        A_1 = Ax(Labels==comp_, Labels==comp_);
        
        writeAdj(A_1);
        
        system('../ocode/ganc_v1.0/ganc -f test2.pairs --float-weight --one-based')   
        curv = load(strcat('test2.curv'));
        [Ac,Bc] = sort(curv(:,2),'descend');
        idx_ = find(Labels == comp_);
        sc_count = 1;
        if scree 
          fprintf(1,'Computing Singular Values\n');
          deigv   = svd(A_1); % Slow Computation
          csdeigv = cumsum(deigv);    
        end
 
        for scale = scales_group
          gg = 1;
          
          if ~scree
            K = sum(Labels==comp_)/asize_group(scale);
          else
            sc_val = deigv(2:end)./csdeigv(1:end-1)+ac_const(scale)*5*[2:(length(csdeigv))]';
            [~, K] = min(sc_val);
          end
          if K>=2
            [kk rr] = sort(abs(curv(Bc(1:end),1)-K),'ascend');
            k = size(Ac,1)-curv(Bc(rr(1)));       
            system(['../ocode/ganc_v1.0/ganc -f test2.pairs --float-weight --one-based -c ' num2str(k) ]);
            idxfull = load(strcat('test2.groups')); 
            sc = find(idxfull==0);
            sc = [sc ;(length(idxfull)+1)];
            for kk = 1: length(sc)-1
              groups_{comp_}{sc_count}{gg} = idx_(idxfull(sc(kk)+1: sc(kk+1)-1));
              gg = gg+1;
              
            end
          else
            groups_{comp_}{sc_count}{gg} = idx_;
          end
          sc_count = sc_count+1;            
        end
      end
    end  
    
    save(groups_name, 'groups_');
    
    clear('A_1','Ax','Labels');
  else
    load(groups_name);
  end

  
  %------------------------------------------------------%
  % Plotting Groups
  %------------------------------------------------------%
  scl = 2; % Level  of clustering 1-4
  if params.plot_clusters
    if params.make_video
      aviobj = VideoWriter(video_name);
      aviobj.FrameRate = 25;
      open(aviobj);
    end
    cl_nm = 0;
    for comp_ = 1 : length(groups_)
      if ~isempty(groups_{comp_})
        cl_nm = cl_nm+ length(groups_{comp_}{scl});
      end
    end

    color = rand(cl_nm,3);
    cur =1;
    current_fr = params.first;
    for fr = 1: len_fr-1
      
      
      im = imread(fullfile(params.im_path, sprintf('image%04d.png',current_fr)));
            
      hh = figure(1);
      imshow(im);
       cc = 1;
      for comp_ = 1: length(groups_)
        hold on;
       
        if ~isempty(groups_{comp_})
          for clu_i = 1:length(groups_{comp_}{scl})
            %cluster_i = find(idxfull(:,2)==clu_i);
            if length(groups_{comp_}{scl})>=1
              cluster_i  = groups_{comp_}{scl}{clu_i};
              cl_points  = [];
              for ii = cluster_i'
                
                if (cur<= tracks(ii).fe(2) && cur >= tracks(ii).fe(1))
                  % plot(double(tracks(ii).loc(2,tracks(ii).fe(1): cur -tracks(ii).fe(1)+1))/1, ...
                  %            double(tracks(ii).loc(1,tracks(ii).fe(1):...
                  %            cur -tracks(ii).fe(1)+1))/1,'-r');
                  if one_color
                    if (cur -tracks(ii).fe(1)) >2
                      plot(double(tracks(ii).loc(2, cur -tracks(ii).fe(1)-1: cur -tracks(ii).fe(1)+1))/10, ...
                           double(tracks(ii).loc(1, cur -tracks(ii).fe(1)-1: cur -tracks(ii).fe(1)+1))/10,'-',...
                           'Color', [0.9 0.9 0.9],'LineWidth',2);
                    else
                      plot(double(tracks(ii).loc(2,1: cur -tracks(ii).fe(1)+1))/10, ...
                           double(tracks(ii).loc(1, 1: cur -tracks(ii).fe(1)+1))/10,'-',...
                           'Color', [0.9 0.9 0.9],'LineWidth',2);
                    end
                  else
                  
                      plot(double(tracks(ii).loc(2,  cur -tracks(ii).fe(1)+1))/10, ...
                           double(tracks(ii).loc(1,  cur -tracks(ii).fe(1)+1))/10,'.',...
                         'Color',color(cc,:),'LineWidth',2);
                  
                    
                  end
                    cl_points = [cl_points [ tracks(ii).loc(1,cur -tracks(ii).fe(1)+1);...
                                      tracks(ii).loc(2,cur-tracks(ii).fe(1)+1)]];
                end
                
              end
              if size(cl_points,2)>1
              yc = prctile(single(cl_points)./10, [20 80],2);
              %  rectangle('Position',[(yc(2,1)-5) (yc(1,1)-5) (abs(yc(2,2)-yc(2,1))+5) ...
              %                    (abs(yc(1,2)-yc(1,1))+5)], ...
              %          'LineWidth',3,'Edge',color(cc,:));
              end
              
              cc = cc+1;
            end
          
          end
        end
      end
      drawnow;
      hold off;

      if params.make_video
        F = getframe(hh);
        writeVideo(aviobj,F);
      end
      pause(0.01);
      current_fr = current_fr +1;
      cur = cur+1;
    end
    if params.make_video
      close(aviobj);
    end
  end
  clear('groups_');

end     
