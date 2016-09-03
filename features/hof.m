function [hist_flows] = hof(uu,vv,cube_step,time_step,num_bins)

% calculate histogram of orientation given the flow vectors
% INPUT:
%     uu: matrix of v_x
%     vv: matrix of v_y
%     cube_step: binning size
%     time_step: size of time window
%     num_bins: number of bins of orientations
% OUTPUT:
%     hist_flow: concatenated histograms of orientations

%%

dims = size(uu);
bin_ranges = single(-pi:(2*pi/(num_bins-1)):pi);
num_cubes = floor(dims/cube_step);

% take only complete time windows
tt = floor(size(uu,3)/time_step);
uu = uu(:,:,1:tt*time_step);
vv = vv(:,:,1:tt*time_step);

% calculate background variance
sig = var(sqrt(uu.^2+vv.^2),0,3);

hist_flows = zeros(tt,num_bins*num_cubes(1)*num_cubes(2));

for i = 1:tt
    
    tw_a = zeros(dims(1),dims(2),time_step);
    tw_w = zeros(dims(1),dims(2),time_step);
    
    % calculate orientatioins and weights in current time window
    for j = 1:time_step
        
        f_u = uu(:,:,(i-1)*time_step+j);
        f_v = vv(:,:,(i-1)*time_step+j);
        
        %lf_a = atan(f_u(:)./f_v(:));
        %lf_a(isnan(lf_a)) = 0;
        %f_a = reshape(lf_a,dims(1),dims(2));
        f_a = atan2(f_u,f_v);
        f_w = sqrt(f_u.^2+f_v.^2);
        
        tw_a(:,:,j) = f_a;
        tw_w(:,:,j) = f_w;
        
        %f_o = zeros(floor(dims(1)/cube_step),floor(dims(2)/cube_step),num_bins+1);
        f_o = zeros(num_bins,floor(dims(1)/cube_step),floor(dims(2)/cube_step));
        
        % take small neighborhood areas
        for k1 = 1:cube_step
            for k2 = 1:cube_step
       
                step_a = f_a(k1:cube_step:end,k2:cube_step:end);
                step_w = f_w(k1:cube_step:end,k2:cube_step:end);
            
                %[~,bin_ind] = histc(step_a,bin_ranges);
                for ii = 1:floor(dims(1)/cube_step)
                    for jj = 1: floor(dims(2)/cube_step)
                        %f_o(bin_ind(ii,jj),ii,jj) = f_o(bin_ind(ii,jj),ii,jj)+step_w(ii,jj);
                        if step_w(ii,jj) < sig(ii,jj)
                            % count as zero bin: the last bin
                            f_o(num_bins,ii,jj) = f_o(num_bins,ii,jj)+step_w(ii,jj);
                        else
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
        end
        
        %f_o = reshape(f_o,num_bins*time_step,num_cubes(1)*num_cubes(2));
        hist_flows(i,:,:) = hist_flows(i,:,:)+f_o(:)';
        
    end
    
    % normalization
    hist_flows(i,:,:) = hist_flows(i,:,:)./(ones(1,size(hist_flows(i,:,:),2))*sum(hist_flows(i,:,:),2));
    
end


end