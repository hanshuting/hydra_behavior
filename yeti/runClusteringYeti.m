% script for clustering

% parameters
fileindx = [1:11,13:32];
numCluster = 10;
filepath = '/vega/brain/users/sh3276/results/hists/';
filename = 'all_results_m_2_n_2_step_5_20151115_drHist';

% load data
load([filepath filename]);

%%%% plain k means %%%%
indAllKmeans = kmeans(drHistAll,numCluster,'replicate',3,'emptyaction','drop');

%%%% AP clustering %%%%
simHistAll = 1-pdist2(drHistAll,drHistAll);
% indAll = apcluster(simHistAll,median(simHistAll));
indAllAP = apcluster(simHistAll,min(simHistAll(:))-10*(max(simHistAll(:))-min(simHistAll(:))));

%%%% k-means+LDA %%%%
[indAllRclda,histTrans] = rclda(drHistAll,numCluster,ci);

% t-SNE
emHist = tsne(histAll,[]);

save(['/vega/brain/users/sh3276/results/' filename '_clustering.mat'],'indAllKmeans',...
    'indAllAP','indAllRclda','histTrans','emHist','-v7.3');