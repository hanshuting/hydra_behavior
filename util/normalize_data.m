function [nor_data] = normalize_data(data)
% normalize rows of data to be in [0,1]

dims = size(data);
min_data = repmat(min(data,[],2),1,dims(2));
max_data = repmat(max(data,[],2),1,dims(2));

nor_data = (data-min_data)./(max_data-min_data);

end