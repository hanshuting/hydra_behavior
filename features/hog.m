function [hist_hog] = hog(movieParam,cube_step,time_step,num_bins)

% calculate histogram of gradient orientation
% INPUT:
%     movieParam: struct array containing movie information
%     cube_step: binning size
%     num_bins: number of bins of orientations
% OUTPUT:
%     hist_hog: concatenated histograms of orientations

%%
bin_ranges = -pi/2:(pi/(num_bins-1)):pi/2;
num_cubes = floor(movieParam.imageSize/cube_step);
tt = floor(movieParam.numImages/time_step);

hx = [-1,0,1];
hy = -hx';

hist_hog = zeros(tt,num_bins*num_cubes(1)*num_cubes(2));

figure;
for i = 1:tt
    
    % calculate orientatioins and weights in current time window
    for j = 1:time_step
        
        im = imread([movieParam.filenameImages movieParam.filenameBasis...
            movieParam.enumString((i-1)*time_step+j,:) '.tif']);
        
        grad_xr = imfilter(double(im),hx);
        grad_yu = imfilter(double(im),hy);
        f_a = atan(grad_yu./grad_xr);
        f_a(isnan(f_a)) = 0;
        f_w = sqrt((grad_yu.^2)+(grad_xr.^2));
        
        imagesc(f_a.*f_w);colormap(gray);title(num2str((i-1)*time_step+j));
        %subplot(1,2,1);imagesc(grad_xr);colormap(gray);title(num2str((i-1)*time_step+j));
        %subplot(1,2,2);imagesc(grad_yu);colormap(gray);title(num2str((i-1)*time_step+j));
        pause(0.001);
        
        f_o = zeros(num_bins,num_cubes(1),num_cubes(2));
        
        % take small neighborhood areas
        for k1 = 1:cube_step
            for k2 = 1:cube_step
       
                step_a = f_a(k1:cube_step:end,k2:cube_step:end);
                step_w = f_w(k1:cube_step:end,k2:cube_step:end);
            
                for ii = 1:num_cubes(1)
                    for jj = 1:num_cubes(2)
                        [~,tmpind] = histc(step_a(ii,jj),bin_ranges);
                        if tmpind==num_bins
                            % merge last two bins
                            tmpind = tmpind-1;
                        end
                        f_o(tmpind,ii,jj) = f_o(tmpind,ii,jj)+step_w(ii,jj);
                    end
                end
            
            end
        end
        
        %f_o = reshape(f_o,num_bins*time_step,num_cubes(1)*num_cubes(2));
        hist_hog(i,:,:) = hist_hog(i,:,:)+f_o(:)';
        
    end
    
    % normalization
    hist_hog(i,:,:) = hist_hog(i,:,:)./(ones(1,size(hist_hog(i,:,:),2))*sum(hist_hog(i,:,:),2));
    
end


end