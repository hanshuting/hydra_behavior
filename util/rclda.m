function [labels,XTransformed] = rclda(X,numCluster,ci)
% regular clustering with LDA

numIter = 10;
XTransformed = X;

for i = 1:numIter
    
    % iteration step 1: kmeans
    [labels,~]=kmeans(XTransformed,numCluster,'replicate',3);
    
    % iteration step 2: LDA
    %ldaObj = fitcdiscr(X,labels,'discrimType','pseudoLinear');
    %[ldaTrans,ldaLambda] = eig(ldaObj.BetweenSigma,ldaObj.Sigma);
    %ldaLambda = diag(ldaLambda);
    %[ldaLambda,sorted] = sort(ldaLambda,'descend');
    
    % in the first round, do dimensionality reduction
    %if i==1
    %    for j = 1:length(ldaLambda)
    %        if nansum(ldaLambda(1:j))/nansum(ldaLambda) > ci/100
    %            keepInd = j;
    %            break;
    %        end
    %    end
    %    sorted = sorted(1:keepInd);
    %end
    %ldaTrans = ldaTrans(:,sorted);
    
    % transform the data
    %XTransformed = ldaObj.XCentered*ldaTrans;
    
    ldaTrans = directlda(X,labels,3,'pcalda');
    XTransformed = X*ldaTrans';
    
end

[labels,~]=kmeans(XTransformed,numCluster,'replicate',3);

end