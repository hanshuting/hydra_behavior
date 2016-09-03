function [rab,rregion,solidity,a,b,centroid,theta,seg] = ...
    extractRegionFeatures(movieParam)

numRegions = 3;
numBins = 8;
dims = [movieParam.imageSize movieParam.numImages];
a = zeros(dims(3),1);
b = zeros(dims(3),1);
centroid = zeros(dims(3),2);
theta = zeros(dims(3),1);
seg = zeros(dims,'uint8');
rab = zeros(dims(3),1);
rregion = zeros(dims(3),numRegions);
solidity = zeros(dims(3),1);
% hof = cell(dims(3)-1,numRegions);
% mvel = zeros(dims(3),2*numRegions);

binRange = -pi:2*pi/numBins:pi;
for i = 1:dims(3)
    
    % read image
    fprintf('frame %u\n',i);
    im = double(imread([movieParam.filePath movieParam.fileName '.tif'],i));
    im = mat2gray(im);
    
    % segment image
    [f_seg,f_theta,f_centroid,f_a,f_b] = getBwRegion2(im);
    a(i) = f_a;
    b(i) = f_b;
    seg(:,:,i) = f_seg;
    centroid(i,:) = f_centroid;
    theta(i) = f_theta;
        
    % static features
    rab(i) = f_a/f_b;
    rregion(i,:) = [sum(f_seg(:)==1),sum(f_seg(:)==2),sum(f_seg(:)==3)]/...
        sum(f_seg(:)~=0);
    rs = regionprops(double(f_seg==1|f_seg==2),'solidity');
    solidity(i) = struct2array(rs);
    
    % motion features
    if 0
    rotmat = [cos(-degtorad(f_theta+90))...
              -sin(-degtorad(f_theta+90));...
              sin(-degtorad(f_theta+90))...
              cos(-degtorad(f_theta+90))];
    if i ~= dims(3)
        f_coord = coords{i};
        f_icoord = round(f_coord(~any(isnan(f_coord),2),:));
        f_icoord(f_icoord<=0) = 1;
        xicoord = f_icoord(:,1:2:end);
        yicoord = f_icoord(:,2:2:end);
        % rotate
        f_coord = reshape(f_coord,[],2);
        f_coord = f_coord*rotmat;
        f_coord = reshape(f_coord,[],4);
        xcoord = f_coord(:,1:2:end);
        ycoord = f_coord(:,2:2:end);
        lind = sub2ind([dims(1) dims(2)],yicoord(:,1),xicoord(:,1));
        segIndx = f_seg(lind);
        
        for j = 1:numRegions
            fuu = xcoord(segIndx==j,2)-xcoord(segIndx==j,1);
            fvv = ycoord(segIndx==j,2)-ycoord(segIndx==j,1);
            fvec = atan2(fuu,fvv);
            fwei = sqrt(fuu.^2+fvv.^2);
            if ~isempty(fwei)
                mvel(i,(j-1)*2+1:j*2) = [quantile(fwei,0.1),quantile(fwei,0.9)];
                [~,histIndx] = histc(fvec,binRange);
                histIndx = reshape(histIndx,[],1);
                fHof = transpose(accumarray(histIndx,fwei,[numBins+1,1]));
                fHof = fHof(:,1:end-1);
                fHof = fHof/sum(fHof);
            else
                mvel(i,(j-1)*2+1:j*2) = [0,0];
                fHof = 1/numBins*ones(1,numBins);
            end
            hof{i,j} = fHof;
        end    
    end
    
    end
    
end

end