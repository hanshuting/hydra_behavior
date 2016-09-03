function [rawIndChopped,marker] = findClusterID(flowsAll,flowsChopped,rawInd)

% given the spatially chopped flows, the original flows and its index
% vector rawInd (here could be the cluster identity vector), find the
% corresponding index of the chopped flows from the original flow indexes
% by comparing flows. flowsAll should include all rows of flowsChopped.

marker = [];
rawIndChopped = zeros(size(flowsChopped,1),1);

for i = 1:size(flowsChopped,1)
    %if i==618
    %    i
    %end
    %ind = find(ismember(flowsChopped(i,3:end),flowsAll(:,3:end),'rows'));
    ind = find(flowsAll(:,1)==flowsChopped(i,1));
    if ~isempty(ind)
        flag = 0;
        for j = 1:size(ind,1)
            if isequal(flowsAll(ind(j),:),flowsChopped(i,:))
                rawIndChopped(i) = rawInd(ind(j));
                flag = 1;
            end    
        end
        if flag==0
            marker(end+1) = i;
        end
    end
    
end



end