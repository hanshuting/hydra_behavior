function [bestc,bestg,bestcv] = svmParamGrid(label,data,meth,weightParam)
% parameter grid search for SVM, using 5-fold cross-validation
% INPUT:
%     label: a vector with true labels
%     data: observation matrix, rows correspond to samples, columns
%       correspond to variables
%     meth: 'one-vs-rest' model, or 'one-vs-one' model
%     weightParam: a string with unbalanced class weight
% OUTPUT:
%     bestc: best C returned by cross-validation
%     bestg: best g returned by cross-validation
%     bestcv: best accuracy with cross-validation
% 
% Shuting Han, 2015

bestcv = 0;

% test all combinations
for log2c = -2:2:12
    for log2g = -2:2:12
    
        svmParam = ['-t 2 -b 1 -q ' weightParam ' -c ' num2str(2^log2c)...
             ' -g ',num2str(2^log2g)];
        switch meth
            case 'one-vs-rest'
                cv = get_cv_ac(label,data,svmParam,5);
            case 'one-vs-one'
                cv = svmtrain(label,data,[svmParam ' -v 5']);
            otherwise
                error('invalid svm method');
        end
    
        % update best parameters
        if (cv >= bestcv)
            bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
        end
    
        % display progress
        fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n',log2c,log2g,cv,...
            bestc,bestg,bestcv);
    
    end
end


end