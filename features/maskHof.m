function [msHofAll] = maskHof(uu,vv,cube_step,num_bins,mask)

dims = size(uu);
bin_ranges = single(-pi:(2*pi/(num_bins-1)):pi);

% calculate background variance
sig = var(sqrt(uu.^2+vv.^2),0,3);

msHofAll = cell(dims(3),1);

for i = 1:dims(3)
    
    % angles and weights in the frame
    f_a = atan2(uu(:,:,i),vv(:,:,i));
    f_w = sqrt(uu(:,:,i).^2+vv(:,:,i).^2);
    
    % mask on the frame
    f_m = mask(:,:,i);
    f_hof = zeros(sum(f_m(:)),num_bins);
    count = 1;
    
    % go over pixels
    for k1 = 1:dims(1)-cube_step
        for k2 = 1:dims(2)-cube_step
            
            % if the pixel is under the mask
            if mask(k1,k2,i)==1
                
                % current region angles and weights
                cr_a = f_a(max(k1-cube_step,1):min(k1+cube_step,dims(1)),...
                    max(k2-cube_step,1):min(k2+cube_step,dims(2)));
                cr_w = f_w(max(k1-cube_step,1):min(k1+cube_step,dims(1)),...
                    max(k2-cube_step,0):min(k2+cube_step,dims(2)));
                zz = cr_w<sig(max(k1-cube_step,1):min(k1+cube_step,dims(1)),...
                    max(k2-cube_step,1):min(k2+cube_step,dims(2)));
                cr_a = cr_a(:);
                cr_w = cr_w(:);
                zz = zz(:);
                
                % the last bin: zero bin
                f_hof(count,num_bins) = sum(cr_w(zz));
                
                % nonzero bins
                [~,tmpind] = histc(cr_a(~zz),bin_ranges);
                tmpind(tmpind==num_bins) = num_bins-1;
                for nn = 1:num_bins-1
                    f_hof(count,nn) = sum(cr_w(tmpind==nn));
                end
                f_hof = f_hof/sum(f_hof);
            end
            
        end
    end
    
    msHofAll{i} = f_hof;
    
end

end