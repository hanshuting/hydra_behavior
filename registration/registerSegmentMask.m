function [reg_data] = registerSegmentMask(data,theta,centroid,timeStep)
% register each slice of the data matrix using the given parameters
% SYNOPSIS:
%     [reg_data] = registerSegmentMask(data,theta,centroid,time_step)
% INPUT:
%     data: M*N*T matrix, will be registered along the third dimension
%     theta: T-by-1 vector, with the orientations
%     centroid: T-by-2 matrix, with the centroids
%     time_step: number of frames in each time window
% OUTPUT:
%     reg_data: registered mask matrix
% 
% Shuting Han, 2016

% initialization
dims = size(data);
reg_data = zeros(dims,'uint8');
tt = floor(dims(3)/timeStep);

% progress text
fprintf('processed time window:      0/%u',tt);

% register the rest based on the first image
for i = 1:tt
    
    % take the average angle and centroid in the time window
    avg_theta = 90-trimmean(theta((i-1)*timeStep+1:i*timeStep),50);
    avg_cent = round(trimmean(centroid((i-1)*timeStep+1:i*timeStep,:),50,1));
    
    % register each frame
    for j = 1:timeStep
        data_slice = squeeze(double(data(:,:,(i-1)*timeStep+j)));
        data_slice = imtranslate(data_slice,int8([dims(2)/2-avg_cent(1)...
            dims(1)/2-avg_cent(2)]));
        data_slice(data_slice==0) = NaN;
        reg_slice = imrotate(data_slice,avg_theta,'crop');
        reg_slice(isnan(reg_slice)) = 0;
        reg_data(:,:,(i-1)*timeStep+j) = uint8(reg_slice);
    end
    
    % update progress text
    fprintf(repmat('\b',1,length(num2str(tt))+length(num2str(i))+1));
    fprintf('%u/%u',i,tt);
    
end

fprintf('\n');

end