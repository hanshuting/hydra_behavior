function [x_points,y_points,v_points] = extractTraj(movieParam)
% extract dense trajectories from DT results
% fileIndx = 1;
L = 299;
% movieParam = paramAll_galois(fileIndx);
% filepath = 'C:\Users\shuting\Desktop\temp\';
filepath = '/home/sh3276/work/results/dt_features/with_coords/';

% read in results
if (isunix) %# Linux, mac
    [~,result] = system(sprintf('wc -l %s%s.txt',filepath,movieParam.fileName));
    numlines = str2double(result);
elseif (ispc)
    numlines = str2double(perl('countlines.pl',sprintf('%s%s.txt',filepath,movieParam.fileName)));
end
dt_features = dlmread([filepath movieParam.fileName '.txt'],'\t',[2,0,numlines-1,4*L+10-1]);

x_points = zeros(size(dt_features,1),movieParam.numImages);
y_points = zeros(size(dt_features,1),movieParam.numImages);
v_points = zeros(size(dt_features,1),movieParam.numImages);

% index of end frame
end_frame = dt_features(:,1);
uframe = unique(end_frame);
for i = 1:length(uframe)
    f_indx = end_frame==uframe(i);
    if uframe(i)<L
        y_points(f_indx,1:uframe(i)) = dt_features(f_indx,11+2*L:2:10+2*L+uframe(i)*2);
        x_points(f_indx,1:uframe(i)) = dt_features(f_indx,12+2*L:2:10+2*L+uframe(i)*2);
        v_points(f_indx,1) = 1;
        v_points(f_indx,2:uframe(i)) = 0;
        v_points(f_indx,uframe+1:end) = -1;
    else
        y_points(f_indx,uframe(i)-L+1:uframe(i)) = dt_features(f_indx,11+2*L:2:10+4*L);
        x_points(f_indx,uframe(i)-L+1:uframe(i)) = dt_features(f_indx,12+2*L:2:10+4*L);
        v_points(f_indx,uframe(i)-L+1) = 1;
        v_points(f_indx,2:uframe(i)) = 0;
        v_points(f_indx,[1:uframe(i)-L,uframe+1:end]) = -1;
    end
end

end