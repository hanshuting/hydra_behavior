
%fileind = [1:5,7:11,13:28,30:34];
fileind = [1:5,7:11,13:28,30:34,35:56];
%fileind = 56;
L = 15;
W = 2;
timeStep = 25;
s = 1;
t = 1;
N = 32;
numRegion = 3;
datestr = '20160404_spseg3';
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];
%filepath = '/home/sh3276/work/results/registered/scaled/';
filepath = '/home/sh3276/work/results/registered/with_coords/3parts_20160331/';
savepath = ['/home/sh3276/work/results/dt_results_assembled/registered/' infostr '_' datestr '/'];
segpath = '/home/sh3276/work/results/register_param/seg_20160331/';

for i = 1:length(fileind)
    
    movieParam = paramAll_galois(fileind(i));
    
    fprintf('processing sample %s...\n',movieParam.fileName);

    % load features
    load([segpath movieParam.fileName '_scaled_reg_seg.mat']);
    load([segpath movieParam.fileName '_seg_loc.mat']);
    [trajAll,hofAll,hogAll,mbhxAll,mbhyAll,coordAll] = extractRegionTwDT2(movieParam,...
         filepath,segmat,locs,numRegion,L,s,t,W,N);

    % save features
%    save([savepath movieParam.fileName '_' infostr '_traj.mat'],'trajAll','-v7.3');
    save([savepath movieParam.fileName '_' infostr '_hof.mat'],'hofAll','-v7.3');
    save([savepath movieParam.fileName '_' infostr '_hog.mat'],'hogAll','-v7.3');
    save([savepath movieParam.fileName '_' infostr '_mbhx.mat'],'mbhxAll','-v7.3');
    save([savepath movieParam.fileName '_' infostr '_mbhy.mat'],'mbhyAll','-v7.3');
%    save([savepath movieParam.fileName '_' infostr '_coord.mat'],'coordAll','-v7.3');

end
    
