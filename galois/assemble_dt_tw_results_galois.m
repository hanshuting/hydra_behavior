
fileind = [1:5,7:11,13:28,30:34];
%fileind = [25:28,30:34];
L = 15;
W = 5;
timeStep = 25;
s = 1;
t = 3;
N = 32;
chunkLen = 5; %s
trackThresh = 0.5;
numRegion = 6;
datestr = '20160308_spseg';
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];
%filepath = '/home/sh3276/work/results/registered/scaled/';
filepath = '/home/sh3276/work/results/registered/with_coords/';
savepath = ['/home/sh3276/work/results/dt_results_assembled/registered/' infostr '_' datestr '/'];
segpath = '/home/sh3276/work/results/register_param/seg_20160301/';

for i = 1:length(fileind)
    
    movieParam = paramAll_galois(fileind(i));
    
    fprintf('processing sample %s...\n',movieParam.fileName);

    % load features
%    [hofAll,hogAll,mbhxAll,mbhyAll] = extractTwDT_galois(movieParam,filepath,L,s,t,W,N,chunkLen,trackThresh);
    load([segpath movieParam.fileName '_scaled_reg_seg_step_' num2str(timeStep) '.mat']);
    [trajAll,hofAll,hogAll,mbhAll] = extractRegionTwDT(movieParam,...
        filepath,segmat,numRegion,L,s,t,W,N,chunkLen,trackThresh);

    % save features
    save([savepath movieParam.fileName '_' infostr '_traj.mat'],'trajAll','-v7.3');
    save([savepath movieParam.fileName '_' infostr '_hof.mat'],'hofAll','-v7.3');
    save([savepath movieParam.fileName '_' infostr '_hog.mat'],'hogAll','-v7.3');
    save([savepath movieParam.fileName '_' infostr '_mbh.mat'],'mbhAll','-v7.3');
%     save([savepath movieParam.fileName '_' infostr '_mbhy.mat'],'mbhyAll','-v7.3');
    
end
    
