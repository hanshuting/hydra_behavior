function [flows,indx] = getFlowsPol(trackVelBatch)

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

            tmpangles = zeros(dimmat(1),dimmat(2)/2);
            tmpamp = zeros(dimmat(1),dimmat(2)/2);
            for k = 1:dimmat(1)
                tmpflow = reshape(tmpmat(k,:),[2,dimmat(2)/2]);
                tmpangles(k,:) = atan(tmpflow(2,:)./tmpflow(1,:));
                tmpamp(k,:) = sqrt(sum(tmpflow.^2,1));
            end
            flows(end+1:end+dimmat(1),1:2:dimmat(2)) = tmpamp;
            flows(end-dimmat(1)+1:end,2:2:dimmat(2)) = tmpangles;
            
        end
    end
end

% normalize flows between -1 and 1
%minamp = min(min(flows(:,1:2:end)));
maxamp = max(max(flows(:,1:2:end)));
%minang = min(min(flows(:,2:2:end)));
%maxang = max(max(flows(:,2:2:end)));
flows(:,1:2:end) = flows(:,1:2:end)./maxamp;
flows(:,2:2:end) = flows(:,2:2:end)./pi;

end