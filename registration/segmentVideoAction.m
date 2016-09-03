
%% parameters
rng(1000);
fileIndx = [1:5,7:11,13:28,30:56];
L = 2;
W = 2;
N = 32;
nxy = 1;
nt = 1;
filepath = 'C:\Shuting\Data\DT_results\features\';
locspath = 'C:\Shuting\Data\DT_results\register_param\video_seg_loc\seg_20160331\';
segspath = 'C:\Shuting\Data\DT_results\register_param\seg_20160331\';
videospath = 'C:\Shuting\Data\DT_results\chopped_data\loc\seg_20160404\';

%% extract features
if 0
for n = 1:length(fileIndx)
    
    movieParam = paramAll(fileIndx(n));
    fprintf('processing file %s...\n',movieParam.fileName);
    
    % coordinates from DT
%     coords = extractDTcoord(movieParam,filepath,L,W,N,nxy,nt);
    
    % posture and motion features
    % [rab,rregion,solidity,hof,mvel,a,b,centroid,theta,seg] = ...
    %     extractRegionFeatures(movieParam,coords);
    [rab,rregion,solidity,a,b,centroid,theta,seg] = ...
        extractRegionFeatures(movieParam);
    save([segspath movieParam.fileName '_seg.mat'],'seg','a','b','centroid',...
        'theta','rab','rregion','solidity','-v7.3');
%     load([segspath movieParam.fileName '_seg.mat']);
    
    numRegions = 3;
    
    % smooth 
    fgauss = fspecial('gaussian',[10,1],5);
    srab = conv(rab,fgauss,'same');
    srregion = rregion;
%     smvel = mvel;
    for i = 1:numRegions
        srregion(i,:) = conv(rregion(i,:),fgauss,'same');
%         smvel(2*(i-1)+1,:) = conv(mvel(2*(i-1)+1,:),fgauss,'same');
%         smvel(2*i,:) = conv(mvel(2*i,:),fgauss,'same');
    end
    ssolid = conv(solidity,fgauss,'same');
    
    % normalize features
    nor_rab = normalize_data(srab')';
    nor_rregion = normalize_data(srregion')';
    nor_solid = normalize_data(ssolid')';
%     nor_mvel = normalize_data(mvel')';
    % nor_hof = normalize_data(cell2mat(hof));
    % nor_hof(isnan(nor_hof)) = 0;

    %% detect change points
    % change intensity
    % feat = [nor_rab,nor_solid,nor_mvel(:,2:2:end)];
    feat = [nor_rab,nor_solid];
    fgauss = fspecial('gaussian',[10,1],5);
    step = 5;
    feat_change = sum(abs(feat(step:end,:)-feat(1:end-step+1,:)),2);
    feat_change = conv(feat_change,fgauss,'same');
    
    % peaks
    [~,~,ww,pp] = findpeaks(feat_change);
    ww_thresh = multithresh(ww,2);
    pp_thresh = multithresh(pp,2);
    [~,raw_locs] = findpeaks(feat_change,'MinPeakProminence',pp_thresh(1),...
        'minpeakwidth',ww_thresh(1));
    
    % merge peaks that are too close
    min_dur = 16; % this should be larger than the L in DT
    ext_locs = [1;raw_locs;movieParam.numImages];
    for i = 1:length(ext_locs)-1
        if ext_locs(i+1)-ext_locs(i) < min_dur
            ext_locs(i+1) = ext_locs(i);
        end
    end
    locs = unique(ext_locs);
    
    save([locspath movieParam.fileName '_seg_loc.mat'],'locs','feat_change',...
        'nor_rab','nor_solid','nor_rregion','rab','rregion','solidity','-v7.3');

    % visualize
%     for i = 1:length(locs)-1
%         playVideo(locs(i):locs(i+1),movieParam,1,0.01,0)
%     end
%     playVideo(locs(i):movieParam.numImages,1,0.01,0);

end
end
%% make segmented videos
outputsz = [300,300];
ifscale = 1;

for i = 1:length(fileIndx)
    
    movieParam = paramAll(fileIndx(i));
    load([segspath movieParam.fileName '_seg.mat']);
    load([locspath movieParam.fileName '_seg_loc.mat']);

    segmat = segRegVideo(movieParam,seg,a,b,theta,centroid,locs,...
        videospath,outputsz,ifscale);

    save([segspath movieParam.fileName '_reg_seg.mat'],'segmat');
end

