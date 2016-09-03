function [] = script_all_batch_yeti(arrayID)

fileInd = [1,2,3,4,5,6,7,8,9,10,11,13];
movieParam = paramAll_yeti(fileInd(arrayID));
    
fprintf('processing sample: %s\n', movieParam.fileName);    

load(['/vega/brain/users/sh3276/results/flow_assembled/' ...
    movieParam.fileName '_flows_assembled_step_1.mat']);
fprintf('flow data loaded\n');
    
% calculate results
ifInvert = 0;
time_step = 5;
cube_step = 2;
num_bins = 9;

[bw,bg] = gnMask(movieParam,ifInvert);
fprintf('mask calculation done\n');

[uu_reg,vv_reg,bw_reg,theta,centroid] = registerAll(movieParam,uu_all,...
    vv_all,bw,bg,time_step);
fprintf('registration done\n');

clear uu_all vv_all

flows = getOpticalFlow(uu_reg,vv_reg,time_step,bw_reg);
fprintf('flow representation done\n');

msHofAll = temporalMaskedHof(single(uu_reg),single(vv_reg),cube_step,...
    time_step,num_bins,bw_reg);
fprintf('HOF calculation done\n');

msHogAll = registerMaskedHog(movieParam,cube_step,time_step,num_bins,...
    bw_reg,theta,centroid);
fprintf('HOG calculation done\n');

msMbhAll = temporalMaskedMbh(uu_reg,vv_reg,cube_step,time_step,num_bins,...
    bw_reg);
fprintf('MBH calculation done\n');

clear bw centroid flowCenters histFlow histHofCenters histHogCenters ...
    hofCenters hogCenters uu_reg vv_reg

numSample = length(flows);
indxSample = randperm(numSample);
indxSample = indxSample(1:round(0.1*numSample));

subFlows = flows(indxSample);
subHof = msHofAll(indxSample);
subHog = msHogAll(indxSample);
subMbh = msMbhAll(indxSample);

save(['/vega/brain/users/sh3276/results/features/' movieParam.fileName...
    '_results_flows_step_' num2str(time_step) '.mat'],'flows','-v7.3');
save(['/vega/brain/users/sh3276/results/features/' movieParam.fileName...
    '_results_hof_step_' num2str(time_step) '.mat'],'msHofAll','-v7.3');
save(['/vega/brain/users/sh3276/results/features/' movieParam.fileName...
    '_results_hog_step_' num2str(time_step) '.mat'],'msHogAll','-v7.3');
save(['/vega/brain/users/sh3276/results/features/' movieParam.fileName...
    '_results_mbh_step_' num2str(time_step) '.mat'],'msMbhAll','-v7.3');

save(['/vega/brain/users/sh3276/results/features/' movieParam.fileName...
    '_results_flows_subsample_step_' num2str(time_step) '.mat'],'subFlows','-v7.3');
save(['/vega/brain/users/sh3276/results/features/' movieParam.fileName...
    '_results_hof_subsample_step_' num2str(time_step) '.mat'],'subHof','-v7.3');
save(['/vega/brain/users/sh3276/results/features/' movieParam.fileName...
    '_results_hog_subsample_step_' num2str(time_step) '.mat'],'subHog','-v7.3');
save(['/vega/brain/users/sh3276/results/features/' movieParam.fileName...
    '_results_mbh_subsample_step_' num2str(time_step) '.mat'],'subMbh','-v7.3');

fprintf('Results saved\n');

end
