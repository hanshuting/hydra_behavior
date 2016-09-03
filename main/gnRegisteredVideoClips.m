
% fileIndx = [1:5,7:11,13:28,30:34,35:56];
fileIndx = 301:324;
timeStep = 25;
skipStep = 1;
outputsz = [300,300];
filepath = 'C:\Shuting\Data\DT_results\register_param\seg_3region_20160510\';
savepath = 'C:\Shuting\Data\DT_results\chopped_data\seg\3parts_20160510\';
% filepath = 'C:\Shuting\Data\DT_results\register_param\seg_gfp_3parts_20160308\';
ifscale = 1;

for i = 1:length(fileIndx)

    movieParam = paramAll(fileIndx(i));
    fprintf('processing %s...\n',movieParam.fileName);
    
    % load data
    load([filepath movieParam.fileName '_seg.mat']);
    
    % registration
    regSeg = registerSegmentMask(segAll,theta,centroid,timeStep*skipStep);
%     save([filepath movieParam.fileName '_reg_seg_step_' num2str(timeStep)],...
%         'regSeg','-v7.3');
    
    % make video and scale
    segmat = makeRegisteredVideo(fileIndx(i),regSeg,timeStep,skipStep,...
        filepath,savepath,ifscale,outputsz);
    
    % load registration data
%     load([filepath movieParam.fileName '_reg_seg_step_' num2str(timeStep) '.mat']);
%     segmat = scaleRegionMask(regSeg,a,b,timeStep,skipStep,ifscale,outputsz);
    save([filepath movieParam.fileName '_scaled_reg_seg_step_' ...
        num2str(timeStep) '.mat'],'segmat','-v7.3');

end