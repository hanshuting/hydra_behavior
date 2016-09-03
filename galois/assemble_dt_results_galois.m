
%fileind = [1:5,7:11,13:34];
fileind = 202:253;
%fileind = 401:414;
%fileind = [307:312];
trackLength = 15;
sampleStride = 5;
timeStep = 100;
s = 2;
t = 3;
N = 32;
nolen = 0;

filepath = '/home/sh3276/work/results/dt_features/min_var0.5/';
savepath = '/home/sh3276/work/results/dt_results_assembled/min_var0.5/';
infostr = ['_L_' num2str(trackLength) '_W_' num2str(sampleStride) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];

for i = 35:length(fileind)
    
    movieParam = paramAll_galois(fileind(i));
    
    fprintf('processing sample %s...\n',movieParam.fileName);

    % load features
    [hofAll,hogAll,mbhxAll,mbhyAll] = extractDT_galois(fileind(i),filepath,timeStep,nolen,trackLength,sampleStride,N,s,t);

    % save features
    save([savepath movieParam.fileName infostr '_hof.mat'],'hofAll','-v7.3')
    save([savepath movieParam.fileName infostr '_hog.mat'],'hogAll','-v7.3')
    save([savepath movieParam.fileName infostr '_mbhx.mat'],'mbhxAll','-v7.3')
    save([savepath movieParam.fileName infostr '_mbhy.mat'],'mbhyAll','-v7.3')
end
    
