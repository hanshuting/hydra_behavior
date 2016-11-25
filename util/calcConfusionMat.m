function [cmat] = calcConfusionMat(trueLabel,predictedLabel,labelset)

numClass = length(labelset);
cmat = zeros(numClass,numClass);

for m = 1:numClass
    for n = 1:numClass
        cmat(m,n) = sum(predictedLabel==labelset(n) & trueLabel==labelset(m));
    end
end

end