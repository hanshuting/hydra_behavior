
% set parameters
rng(1000)
fileind = [1:11,13:32];
annoType = 1:6;
time_step = 5;
filepath = '/home/sh3276/work/results/bow_hydra/results_m_2_n_2_step_5_20151115/';
filename = 'all_results_m_2_n_2_step_5_20151115_drHist';
annoPath = '/home/sh3276/work/data/annotations/';

% load data
load([filepath filename '.mat']);

% substitute all NaN with 0
drHistAll(isnan(drHistAll)) = 0;
sample = drHistAll;

% modify number of images in parameter struct
movieParamMulti = paramMulti_galois(fileind);
for i = 1:length(fileind)
    movieParamMulti{i}.numImages = (acm(i+1)-acm(i))*time_step;
end

% load annotation
annoRaw = annoMulti(movieParamMulti,annoPath,time_step,0);

for i = 1:length(annoType)
    fprintf('processing annotation type %u...\n',annoType(i));
    label = mergeAnno(annoRaw,annoType(i));
    % save to files
    gnLibsvmFile(label,sample,[filepath filename '_annoType' num2str(annoType(i)) '_all.txt']);
end
