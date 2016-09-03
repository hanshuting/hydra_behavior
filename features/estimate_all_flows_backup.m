tic;
%% set parameters
movieParam = paramAll;
%hydraParam = estimateHydraParam;

pyramid_factor = 0.95;
pyramid_levels = 10;
beta = 0.05;
lambda = 0.05;
warps = 1;
max_iter = 100;
check = 0;
handles = [];

%tw = 10;
%step = 1;
%m = 1;
%n = 1;

%scale = hydraParam.length/200;

%% read tracking information
%tracksRaw = dlmread(movieParam.filenameTracks,'\t',1,3);

% put all tracks together
%tracksAll = cell(movieParam.numImages,1);
 % normalizing parameter
%for i = 1:movieParam.numImages
%    ind = (tracksRaw(:,7)==i-1); % because in the csv file frame starts from 0
%    infomat = zeros(sum(ind),3);
%    infomat(:,1) = tracksRaw(ind,1); % track ID
%    infomat(:,2:3) = tracksRaw(ind,3:4);
    %coordCurrent = tracksRaw(ind,3:4);
    % rotate to calibrated coordinate system (animal axis aligned) and
    % centralize the centroid
    %coordNew = (coordCurrent-ones(sum(ind),1)*hydraParam.centroid)*...
    %    hydraParam.rotmat;
    % normalize by half length of the hydra, and scale up by 100
    %coordNew = coordNew./scale;
    %infomat(:,2:3) = coordNew; % (x,y) location
%    tracksAll{i} = infomat;
%    clear infomat
%    clear ind
%end

%clear tracksRaw

%a = floor(hydraParam.length/(scale*m));
%b = floor(hydraParam.length/(scale*n));
%a0 = m*a/2;
%b0 = n*b/2;

%% estimate flows

%flows = cell(round((movieParam.numImages-1)/step),m*n);
%locs = cell(round((movieParam.numImages-1)/step),m*n);
uu = zeros(movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages-1,'single');
vv = zeros(movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages-1,'single');

%indt = 1;
im2 = double(imread([movieParam.filenameImages movieParam.filenameBasis...
    movieParam.enumString(1,:) '.tif']));
%for i = 1:round((movieParam.numImages-1)/step)
for i = 2:movieParam.numImages 

    % calculate flows
    im1 = im2;
    %im2 = double(imread([movieParam.filenameImages movieParam.filenameBasis...
    %    movieParam.enumString(indt+step,:) '.tif']));
    im2 = double(imread([movieParam.filenameImages movieParam.filenameBasis...
        movieParam.enumString(i,:) '.tif']));
    flow_all = coarse_to_fine(im1, im2, lambda, beta, warps, max_iter, ...
        pyramid_levels, pyramid_factor, check, handles);
    
    uu(:,:,i-1) = single(flow_all(:,:,1));
    vv(:,:,i-1) = single(flow_all(:,:,2));
    
    display(i);
    
    % normalize coordinates and flows
    %trackInfo = tracksAll{indt};
    %coordNor = trackInfo(:,2:3);
    %coordNor = (coordNor-ones(size(coordNor,1),1)*hydraParam.centroid)*...
    %    hydraParam.rotmat;
    %coordNor = coordNor./scale;
    
    % extract flows at cell locations
    %for j = 1:size(trackInfo,1)
        
    %    coordRaw = trackInfo(j,2:3);
    %    coordNew = coordNor(j,:);
        
    %    if coordNew(1) <= -a0
    %        indx = 1;
    %    elseif coordNew(1) > a0
    %        indx = m;
    %    else
    %        indx = ceil((coordNew(1)+a0)/a);
    %    end
    %    if coordNew(2) <= -b0
    %        indy = 0;
    %    elseif coordNew(2) > b0
    %        indy = (n-1)*m;
    %    else
    %        indy = floor((coordNew(2)+b0)/b)*m;
    %    end
    %    inds = indx+indy;
    %    %inds = 1;
        
        % take out current matrix
    %    tmpflow = flows{(indt-1)/step+1,inds};
    %    tmploc = locs{(indt-1)/step+1,inds};
        
        % rotate and normalize flow
    %    flowRaw = [flow_all(round(coordRaw(1)),round(coordRaw(2)),1),...
    %        flow_all(round(coordRaw(1)),round(coordRaw(2)),2)];
    %    endpoint = coordRaw+flowRaw;
    %    endpointNew = (endpoint-hydraParam.centroid)*hydraParam.rotmat;
    %    endpointNew = endpointNew./scale;
    %    endpointAll(end+1,:)=endpointNew;
    %    flowNew = endpointNew-coordNew;
        
    %    tmpflow(end+1,:) = flowNew;
    %    tmploc(end+1,:) = coordNew; % store normalized coordinates
        
        % put back updated matrix
    %    flows{(indt-1)/step+1,inds} = tmpflow;
    %    locs{(indt-1)/step+1,inds} = tmploc;
        
    %end
    
    %indt = indt+step;
    
end

%% save result
%save(['/vega/brain/users/sh3276/results/flows10.mat']);

toc;