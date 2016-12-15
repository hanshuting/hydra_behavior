
%% ap clustering
ap_indx = apcluster(sim_corr,median(sim_corr)-10*(max(sim_corr(:))-min(sim_corr(:))));


%% evaluate kmeans cluster number
num_clust = 4:2:30;
km_indx = zeros(length(num_clust),size(sample,1));

for n = 1:length(num_clust)
    km_indx(n,:) = kmeans(sample,num_clust(n),'emptyaction','drop','replicates',3);
end

eva = evalclusters(sample,km_indx,'CalinskiHarabasz');
disp(eva);

%% hierachical clustering
num_clust = 3:20;
hindx = zeros(size(sample,1),length(num_clust));

for n = 1:length(num_clust)
    hindx(:,n) = cluster(Z,'maxclust',n);
end

eva = evalclusters(sample,hindx,'CalinskiHarabasz');
disp(eva);

%% make videos
for n = 1:6
    visualizeResultMulti(find(c==n),timeStep,movieParamMulti,1,1,...
        ['hier_weighted_corr_cluster' num2str(n)]);
end


