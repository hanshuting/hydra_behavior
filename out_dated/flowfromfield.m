function [vel,ang,wei,ind] = flowfromfield(uu,vv,xx,yy,tw,m,n)
% extract optical flows from a given flow field

numCubes = floor(size(uu,1)/tw);
dims = size(uu);
vel = zeros(numCubes*dims(2)*dims(3),tw*2);
ang = zeros(numCubes*dims(2)*dims(3),tw);
wei = zeros(numCubes*dims(2)*dims(3),tw);
ind = zeros(numCubes*dims(2)*dims(3),2);


a = floor((max(xx(:))-min(xx(:)))/m);
b = floor((max(yy(:))-min(yy(:)))/n);
a0 = m*a/2;
b0 = n*b/2;

inds = zeros(dims(2)*dims(3),1);
for i = 1:dims(2)
    for j = 1:dims(3)
        coord = [xx(i,j),yy(i,j)];
        if coord(1) <= -a0
            tmp1 = 1;
        elseif coord(1) > a0
            tmp1 = m;
        else
            tmp1 = ceil((coord(1)+a0)/a);
        end
        if coord(2) <= -b0
            tmp2 = 0;
        elseif coord(2) > b0
            tmp2 = (n-1)*m;
        else
            tmp2 = floor((coord(2)+b0)/b)*m;
        end
        inds((i-1)*dims(2)+j) = tmp1+tmp2; 
    end
end

for i = 1:numCubes
    
    veltw = zeros(dims(2)*dims(3),tw*2);
    angtw = zeros(dims(2)*dims(3),tw);
    weitw = zeros(dims(2)*dims(3),tw);
    
    for j = 1:tw
        
        %uu = field{(i-1)*tw+j,1};
        %vv = field{(i-1)*tw+j,2};
        uutw = uu((i-1)*tw+j,:,:);
        vvtw = vv((i-1)*tw+j,:,:);
        veltw(:,j*2-1) = uutw(:)';
        veltw(:,j*2) = vvtw(:)';
        angtw(:,j) = atan(veltw(:,j*2)./veltw(:,j*2-1));
        weitw(:,j) = sqrt(sum(veltw(:,j*2-1:j*2).^2,2));
        weitw(:,j) = weitw(:,j)./sum(weitw(:,j));
       
    end
    
    vel((i-1)*dims(2)*dims(3)+1:i*dims(2)*dims(3),:) = veltw;
    ang((i-1)*dims(2)*dims(3)+1:i*dims(2)*dims(3),:) = angtw;
    wei((i-1)*dims(2)*dims(3)+1:i*dims(2)*dims(3),:) = weitw;
    ind((i-1)*dims(2)*dims(3)+1:i*dims(2)*dims(3),1) = i;
    %ind((i-1)*dims(2)*dims(3)+1:i*dims(2)*dims(3),2) = 1;
end

ind(:,2) = repmat(inds,numCubes,1);

end