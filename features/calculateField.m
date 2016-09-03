function [uu,vv] = calculateField(tracksAll,xx,yy,r)

uu = zeros(size(tracksAll,1)-1,size(xx,1),size(xx,2));
vv = zeros(size(tracksAll,1)-1,size(yy,1),size(yy,2));
nt = size(tracksAll,1);
%scale = hydraParam.length/200;

for i = 1:nt
    
    infomat = tracksAll{i};
    
    if i>1
        
        uutw = zeros(size(xx));
        vvtw = zeros(size(yy));
        infomatPrev = tracksAll{i-1};
        
        % go through all nodes
        for m = 1:size(xx,1)
            for n = 1:size(xx,2)
                
                % search for neighbors
                [indxPrev,dists] = findNeighbor([xx(m,n),yy(m,n)],infomatPrev(:,2:3),5*r);
                % find the index of neighbors in the previous frame
                indx = zeros(size(indxPrev));
                % keep points that are exist in both frames
                if ~isempty(indxPrev)
                    for k = 1:length(indxPrev);
                        if ~isempty(find(infomat(:,1)==infomatPrev(indxPrev(k),1),1))
                            indx(k) = find(infomat(:,1)==infomatPrev(indxPrev(k),1));
                        end
                    end
                    keepInd = indx~=0;
                    indxPrev = indxPrev(keepInd);
                    indx = indx(keepInd);
                    dists = dists(keepInd);
                    if ~isempty(indxPrev)
                        vels = infomat(indx,2:3)-infomatPrev(indxPrev,2:3);
                        weights = (1./(dists.^2)/sum(1./(dists.^2)))';
                        % use weighted average as the value of the current node
                        uutw(m,n) = sum(vels(:,1).*weights)/mean(dists);
                        vvtw(m,n) = sum(vels(:,2).*weights)/mean(dists);
                    end
                end
            end
        end
        %flowfield{i-1,1} = uu;
        %flowfield{i-1,2} = vv;
        uu(i-1,:,:) = uutw;
        vv(i-1,:,:) = vvtw;
    end
    %display(i);
end

end