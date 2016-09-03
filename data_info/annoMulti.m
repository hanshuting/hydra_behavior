function [annoAll] = annoMulti(movieParamMulti,annoPath,annoType,timeStep)

% read in annotation files of multi samples, combine them and devide into
% time windows

annoAll = [];

for i = 1:length(movieParamMulti)
    
    movieParam = movieParamMulti{i};
    load([annoPath movieParam.fileName '_annotation.mat']); % variable name: anno
    anno = mergeAnno(anno,annoType);
    annoCubes = zeros(floor(movieParam.numImages/timeStep),1);
    for j = 1:length(annoCubes)
        annotw = anno((j-1)*timeStep+1:j*timeStep);
        if length(annotw)==1
            annoCubes(j) = annotw;
            continue;
        end
        label1 = mode(annotw);
        label2 = mode(annotw(annotw~=label1));
        c1 = sum(annotw==label1);
        c2 = sum(annotw==label2);
        if label1 > label2
            annoCubes(j) = label1;
        else
            if 3*c2 > c1
                annoCubes(j) = label2;
            else
                annoCubes(j) = label1;
            end
        end
%        annoCubes(j) = mode(anno((j-1)*time_step+1:j*time_step));
    end
    
    annoAll(end+1:end+length(annoCubes)) = annoCubes;
    
end

annoAll = annoAll';

end