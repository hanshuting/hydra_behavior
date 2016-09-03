
testIndx = [1,25,33,34];
infostr = 'L_15_W_5_N_32_s_1_t_3_step_25';
annoType = 5;
K = 128;
datastr = '20160225_spseg';

filepath = ['/home/sh3276/work/results/dt_fv/min_var0.5/' infostr ...
    '_K_' num2str(K) '_' datastr '/'];

% save training predictions
filename = [infostr '_drFVall_annoType' num2str(annoType) '_training'];
predictionresult = dlmread([filepath filename '_prediction.txt'],' ',1,0);
predictedTest=predictionresult(:,1);
scoresTest=predictionresult(:,2:end);
save([filepath filename '_prediction.mat'],'predictedTest','scoresTest');

% save test predictions
filename = [infostr '_drFVall_annoType' num2str(annoType) '_test'];
predictionresult = dlmread([filepath filename '_prediction.txt'],' ',1,0);
predictedTest=predictionresult(:,1);
scoresTest=predictionresult(:,2:end);
save([filepath filename '_prediction.mat'],'predictedTest','scoresTest');

% save new sample predictions
for i = 1:length(testIndx)
    movieParam = paramAll_galois(testIndx(i));
    filename = [movieParam.fileName '_' infostr '_annoType5_drFV_all'];
    predictionresult = dlmread([filepath filename '_prediction.txt'],' ',1,0);
    predictedTest=predictionresult(:,1);
    scoresTest=predictionresult(:,2:end);
    save([filepath filename '_prediction.mat'],'predictedTest','scoresTest');
end