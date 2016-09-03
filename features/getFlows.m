function [flows,indx] = getFlows(trackVelBatch,doNormalize)

% extract the velocity vectors in the given time window

dimsBatch = size(trackVelBatch);
flows = [];
indx = [];

for i = 1:dimsBatch(1)
    for j = 1:dimsBatch(2)
        if i==64&&j==1
            i;
        end
        tmpmat = trackVelBatch{i,j};
        if ~isempty(tmpmat)
            dimmat = size(tmpmat);
            indx(end+1:end+dimmat(1),1) = i;
            indx(end-dimmat(1)+1:end,2) = j;
            
            % normalize by the sum of the displacement vectors
            %if doNormalize==1
            %    for k = 1:dimmat(1)
            %        tmp = reshape(tmpmat(k,:),[2,dimmat(2)/2]);
            %        scales = sum(sqrt(sum(tmp.^2,1)));
            %        tmpmat(k,:) = tmpmat(k,:)./scales;
            %    end
            %end
            
            flows(end+1:end+dimmat(1),1:dimmat(2)) = tmpmat;
            
            %allFlows(end+1:end+dimmat(1),1) = i; % store the time index in the first column
            %allFlows(end-dimmat(1)+1:end,2) = j; % store the patch index in the first column
            %allFlows(end-dimmat(1)+1:end,3:dimmat(2)+2) = tmpmat;
            
            % normalize by the length of the hydra, and scale up
            %allFlows(end-dimmat(1)+1:end,3:dimmat(2)+2) = 1000*allFlows(end-dimmat(1)+1:end,3:dimmat(2)+2)./hydraParam.length; 
            
            % normalize velocity by 2-norm
            %if doNormalize==1
            %    norms = sqrt(sum(flows(end-dimmat(1)+1:end,:).^2,2));
            %    norms = repmat(norms,1,dimmat(2));
            %    flows(end-dimmat(1)+1:end,:) = flows(end-dimmat(1)+1:end,:)./norms;
            %end
            
        end
    end
end

%allFlows(allFlows==0) = NaN;
%allFlows = allFlows(sum(isnan(allFlows),2)==0,:);
%keepInd = sum(allFlows==0,2)==0;
%allFlows = allFlows(keepInd,:); % delete rows with zeros
%indx = indx(keepInd,:);

% normalize flows between -1 and 1
if doNormalize==1
    mi = min(flows(:));
    ma = max(flows(:));
    flows = flows./max(abs(ma),abs(mi));
end

end