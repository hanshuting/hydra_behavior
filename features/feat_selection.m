function [ranking] = feat_selection(X,Y,meth)
% Feature selection call to FSLib_v4.0_2016
% available method: {'InfFS','ECFS','mrmr','relieff','mutinffs','fsv',
% 'laplacian','mcfs','rfe','L0','fisher','UDFS','llcfs','cfs'};

% Randomly partitions observations into a training set and a test
% set using stratified holdout
P = cvpartition(Y,'Holdout',0.20);

X_train = double( X(P.training,:) );
Y_train = (double( Y(P.training) )-1)*2-1; % labels: neg_class -1, pos_class +1

X_test = double( X(P.test,:) );
Y_test = (double( Y(P.test) )-1)*2-1; % labels: neg_class -1, pos_class +1

% number of features
numF = size(X_train,2);

% feature Selection on training data
switch lower(meth)
    case 'mrmr'
        ranking = mRMR(X_train, Y_train, numF);
    case 'relieff'
        [ranking, w] = reliefF( X_train, Y_train, 20);
    case 'mutinffs'
        [ ranking , w] = mutInfFS( X_train, Y_train, numF );
    case 'fsv'
        [ ranking , w] = fsvFS( X_train, Y_train, numF );
    case 'laplacian'
        W = dist(X_train');
        W = -W./max(max(W)); % it's a similarity
        [lscores] = LaplacianScore(X_train, W);
        [junk, ranking] = sort(-lscores);
    case 'mcfs'
        % MCFS: Unsupervised Feature Selection for Multi-Cluster Data
        options = [];
        options.k = 5; %For unsupervised feature selection, you should tune
        %this parameter k, the default k is 5.
        options.nUseEigenfunction = 4;  %You should tune this parameter.
        [FeaIndex,~] = MCFS_p(X_train,numF,options);
        ranking = FeaIndex{1};
    case 'rfe'
        ranking = spider_wrapper(X_train,Y_train,numF,lower(meth));
    case 'l0'
        ranking = spider_wrapper(X_train,Y_train,numF,lower(meth));
    case 'fisher'
        ranking = spider_wrapper(X_train,Y_train,numF,lower(meth));
    case 'inffs'
        % Infinite Feature Selection 2015 updated 2016
        alpha = 0.5;    % default, it should be cross-validated.
        sup = 0;        % Supervised or Not
        [ranking, w] = infFS( X_train , Y_train, alpha , sup , 0 );    
    case 'ecfs'
        % Features Selection via Eigenvector Centrality 2016
        alpha = 0.5; % default, it should be cross-validated.
        ranking = ECFS( X_train, Y_train, alpha )  ;
    case 'udfs'
        % Regularized Discriminative Feature Selection for Unsupervised Learning
        nClass = 2;
        ranking = UDFS(X_train , nClass ); 
    case 'cfs'
        % BASELINE - Sort features according to pairwise correlations
        ranking = cfs(X_train);     
    case 'llcfs'   
        % Feature Selection and Kernel Learning for Local Learning-Based Clustering
        ranking = llcfs( X_train );
    otherwise
        disp('Unknown method.')
end

end