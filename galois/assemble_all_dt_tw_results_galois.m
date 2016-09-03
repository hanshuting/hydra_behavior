
fileind = [1:5,7:11,13:28,30:34];
%fileind = 401:414;
%fileind = [238,239];
L = 15;
W = 2;
timeStep = 25;
s = 2;
t = 3;
N = 32;
chunkLen = 5; %s
trackThresh = 0.5;
datestr = '20160130_registered';
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(timeStep)];
filepath = '/home/sh3276/work/results/registered/';
savepath = ['/home/sh3276/work/results/dt_results_assembled/registered/' infostr '_' datestr '/'];

for i = 1:length(fileind)
    
    movieParam = paramAll_galois(fileind(i));
    
    fprintf('processing sample %s...\n',movieParam.fileName);

    % load features
    desc = extractAllTwDT(movieParam,filepath,L,s,t,W,N,chunkLen,trackThresh);

    % save features
    save([savepath movieParam.fileName '_' infostr '_desc.mat'],'desc','-v7.3');
        
end
    
