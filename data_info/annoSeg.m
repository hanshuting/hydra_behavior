function [annoAll] = annoSeg(movieParam,annoPath,annoType,locPath)

% read in annotation files of multi samples, combine them and devide into
% time windows

load([annoPath movieParam.fileName '_annotation.mat']); % variable name: anno
load([locPath movieParam.fileName '_seg_loc.mat']); % variable: locs
anno = mergeAnno(anno,annoType);
annoAll = zeros(length(locs)-1,1);
for j = 1:length(locs)-1
    annotw = anno(locs(j):locs(j+1)-1);
    if length(annotw)==1
        annoAll(j) = annotw;
        continue;
    end
    label1 = mode(annotw);
    label2 = mode(annotw(annotw~=label1));
    c1 = sum(annotw==label1);
    c2 = sum(annotw==label2);
    if label1 > label2
        annoAll(j) = label1;
    else
        if 4*c2 > c1
            annoAll(j) = label2;
        else
            annoAll(j) = label1;
        end
    end
%    annoCubes(j) = mode(anno((j-1)*time_step+1:j*time_step));
end
    
annoAll = annoAll';


end