function [pred,score] = saveSVMpred(filepath,filename)

predictionresult = dlmread([filepath filename '_pred.txt'],' ',1,0);
pred = predictionresult(:,1);
score = predictionresult(:,2:end);
save([filepath filename '_pred.mat'],'pred','score');

end