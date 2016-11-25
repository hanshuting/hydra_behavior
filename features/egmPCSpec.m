function [pc_mat] = egmPCSpec(movieParam,coeff,latent,regparam,outputsz,timeStep)

seg = regparam.segAll;
a = regparam.a;
theta = regparam.theta;
centroid = regparam.centroid;

num_mode = size(coeff,2);
numT = floor(movieParam.numImages/timeStep);
pc_mat = zeros(numT,num_mode);

% registration
frscale = outputsz(1)/3/nanmean(a);
for ii = 1:numT
    
    % take the average angle and centroid in the time window
    avg_theta = 90-trimmean(theta((ii-1)*timeStep+1:ii*timeStep),50);
    avg_cent = round(trimmean(centroid((ii-1)*timeStep+1:ii*timeStep,:),50,1));
    
    for jj = 1:timeStep
        indx = (ii-1)*timeStep+jj;
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],indx));
        if isnan(avg_theta)
            pcspec = NaN(1,num_mode);
        else
            im = imrotate(imtranslate(im,[movieParam.imageSize(1)/2-avg_cent(1)...
                movieParam.imageSize(2)/2-avg_cent(2)]),90-avg_theta,'crop');
            bw = imrotate(imtranslate(seg(:,:,(ii-1)*timeStep+jj),...
                [movieParam.imageSize(1)/2-avg_cent(1) ...
                movieParam.imageSize(2)/2-avg_cent(2)]),90-avg_theta,'crop');
            im = mat2gray(im.*double(bw~=0));
            im = scaleImage(im,outputsz,frscale);
            
            % assign to eigenmodes
            im = reshape(im,1,[]);
            pcspec = (im-mean(im))*coeff./sqrt(latent');
            
        end
    pc_mat(ii,(jj-1)*num_mode+1:jj*num_mode) = pcspec;
    end
end

    
end