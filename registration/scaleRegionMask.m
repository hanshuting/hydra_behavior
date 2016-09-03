function [segmat] = scaleRegionMask(mask,a,b,timeStep,skipStep,ifscale,outputsz)


tt = floor(size(mask,3)/timeStep/skipStep);
segmat = zeros([outputsz,tt],'uint8');

if ~ifscale
    frscale = [1,1];
end

for i = 1:tt
    
    if ifscale
        avg_a = mean(a((i-1)*timeStep+1:i*timeStep));
%         avg_b = mean(b((i-1)*timeStep+1:i*timeStep));
        frscale = outputsz(1)/3/avg_a;
    end
    
    % scale segmentation matrix
    for j = 1:timeStep
        seg_im = mask(:,:,(i-1)*timeStep+(j-1)*skipStep+1);
        seg_im(seg_im==0) = NaN;
        seg_im = scaleImage(seg_im,outputsz,frscale);
        seg_im = round(seg_im);
%         seg_im(seg_im>3) = 3;
        seg_im(isnan(seg_im)) = 0;
        segmat(:,:,(i-1)*timeStep+j) = uint8(seg_im);
    end
    
end


end