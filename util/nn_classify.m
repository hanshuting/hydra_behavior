function [pred_label] = nn_classify(data,query,data_label,num_nn,ifweight)
% KNN classification function. Requires yael matlab package.
% INPUT:
%     data: a matrix to be searched in; rows are observations, columns are
%         variables
%     query: query matrix
%     data_label: label of data matrix
%     num_nn: number of nearest neighbors required
%     ifweight: if weight the final decision by distance
% OUTPUT:
%     pred_label: predicted label
%
% Shuting Han, 2016

num_sample = size(query,1);
max_label = max(data_label);
pred_label = zeros(num_sample,1);

for i = 1:num_sample
    
    [ids,dis] = yael_nn(single(data'),single(query(i,:)'),num_nn);
    if any(isnan(dis))
        pred_label(i) = NaN;
        continue;
    end
    
    sim = max(dis)-dis;
    [count,hindx] = histc(data_label(ids),1:max_label);
    if ifweight
        nzIndx = hindx~=0;
        wcount = accumarray(hindx(nzIndx),sim(nzIndx),[max_label+1,1]);
        [~,pred_label(i)] = max(wcount);
    else
        [~,pred_label(i)] = max(count);
    end
    
end


end