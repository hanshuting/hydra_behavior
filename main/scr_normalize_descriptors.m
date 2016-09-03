

fileind = 1:13;
m = 1;
n = 1;
filepath = 'C:\Shuting\Data\yeti\features\features_whole\';
savepath = 'C:\Shuting\Data\yeti\features\features_whole_normalized\';

for i = 1:length(fileind)
    
    movieParam = paramAll(fileind(i));
    fprintf('processing sample %s...\n',movieParam.fileName);
    
    load([filepath movieParam.fileName '_results_params_step5.mat'],'indxSample');
    
    % flow
    load([filepath movieParam.fileName '_results_flows_step_5.mat']);
    for j = 1:size(flows,1)
        tmp = double(flows{j});
        flows{j} = tmp./(max(tmp,[],2)*ones(1,size(tmp,2)));
    end
    subFlows = flows(indxSample);
    save([savepath movieParam.fileName '_results_flows_m_1_n_1_step_5.mat'],'flowCoord','flows','-v7.3');
    save([savepath movieParam.fileName '_results_flows_subsample_m_1_n_1_step_5.mat'],'subFlows');
    
%     % hof
%     load([filepath movieParam.fileName '_results_hof_step_5.mat']);
%     for j = 1:size(msHofAll,1)
%         tmp = double(msHofAll{j});
%         msHofAll{j} = tmp./(sum(tmp,2)*ones(1,size(tmp,2)));
%     end
%     subHof = msHofAll(indxSample);
%     save([savepath movieParam.fileName '_results_hof_m_1_n_1_step_5.mat'],'hofCoord','msHofAll','-v7.3');
%     save([savepath movieParam.fileName '_results_hof_subsample_m_1_n_1_step_5.mat'],'subHof');
%     
%     % hog
%     load([filepath movieParam.fileName '_results_hog_step_5.mat']);
%     for j = 1:size(msHogAll,1)
%         tmp = double(msHogAll{j});
%         msHogAll{j} = tmp./(sum(tmp,2)*ones(1,size(tmp,2)));
%     end
%     subHog = msHogAll(indxSample);
%     save([savepath movieParam.fileName '_results_hog_m_1_n_1_step_5.mat'],'hogCoord','msHogAll','-v7.3');
%     save([savepath movieParam.fileName '_results_hog_subsample_m_1_n_1_step_5.mat'],'subHog');
%     
%     % mbh
%     load([filepath movieParam.fileName '_results_mbh_step_5.mat']);
%     for j = 1:size(msMbhAll,1)
%         tmp = double(msMbhAll{j});
%         msMbhAll{j} = tmp./(sum(tmp,2)*ones(1,size(tmp,2)));
%     end
%     subMbh = msMbhAll(indxSample);
%     save([savepath movieParam.fileName '_results_mbh_m_1_n_1_step_5.mat'],'mbhCoord','msMbhAll','-v7.3');
%     save([savepath movieParam.fileName '_results_mbh_subsample_m_1_n_1_step_5.mat'],'subMbh');
%     
end