
movieParam = paramAll_yeti(1);
    
fprintf('processing sample: %s\n', movieParam.fileName);    

load(['/vega/brain/users/sh3276/results/flow_assembled/' ...
    movieParam.fileName '_flows_assembled_step_1.mat']);
fprintf('flow data loaded\n');
    
% calculate results
time_step = 5;
cube_step = 2;
num_bins = 9;
m = 2;
n = 2;

% registration
[bw,bg] = gnMask(movieParam,0);
[uu_reg,vv_reg,bw_reg,thetas,centroids,as] = registerAll(movieParam,...
    uu_all,vv_all,bw,bg,time_step);

clear uu_all vv_all

save('/vega/brain/users/sh3276/results/features/test.mat','-v7.3');