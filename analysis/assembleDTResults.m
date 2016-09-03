
fileind = [1:11,13:34];
trackLength = 15;
sampleStride = 5;
timeStep = 1;
nolen = 8;

filepath = 'C:\Shuting\Data\DT_results\features\features_whole_20151114\';
savepath = 'C:\Shuting\Data\DT_results\features\features_unregistered_step_1_20151120\';
infostr = ['_L_' num2str(trackLength) '_W_' num2str(sampleStride) '_step_' num2str(timeStep)];

for i = 21:length(fileind)
    
    movieParam = paramAll(fileind(i));
    
    fprintf('processing sample %s...\n',movieParam.fileName);

    % load features
    [hofAll,hogAll,mbhxAll,mbhyAll] = extractDT(fileind(i),filepath,timeStep,nolen);

    % save features
    save([savepath movieParam.fileName infostr '_hof.mat'],'hofAll','-v7.3')
    save([savepath movieParam.fileName infostr '_hog.mat'],'hogAll','-v7.3')
    save([savepath movieParam.fileName infostr '_mbhx.mat'],'mbhxAll','-v7.3')
    save([savepath movieParam.fileName infostr '_mbhy.mat'],'mbhyAll','-v7.3')
end
    