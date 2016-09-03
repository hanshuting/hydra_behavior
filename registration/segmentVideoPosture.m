
%% parameters
rng(1000);
fileIndx = [1:5,7:11,13:28,30:56];
locspath = 'C:\Shuting\Data\DT_results\register_param\video_seg_loc\seg_20160420\';
segpath = 'C:\Shuting\Data\DT_results\register_param\seg_20160413\';
videospath = 'C:\Shuting\Data\DT_results\chopped_data\loc\seg_20160420\';

%% segment by posture spectrum
for n = 1:length(fileIndx)
    
    movieParam = paramAll(fileIndx(n));
    fprintf('processing file %s...\n',movieParam.fileName);
    dims = [movieParam.imageSize movieParam.numImages];
    load([segpath movieParam.fileName '_seg.mat']);
    
    % image fourier
    fprintf('FFT...\n');
    freq_im = zeros(dims);
    for i = 1:dims(3)
%         fprintf('%u\n',i);
        im = double(imread([movieParam.filePath movieParam.fileName '.tif'],i));
%         reg_im = registerData(im,theta(i),centroid(i,:),1,0);
%         freq_im(:,:,i) = abs(fftshift(fft2(reg_im)));
        freq_im(:,:,i) = abs(fftshift(fft2(im)));
    end

    % find change points
    fprintf('segmenting video...\n');
    step = 10;
    freq_wd = round(min(dims(1:2))*0.25);
    cent = round(dims(1:2)/2);
    freq_im_wd = freq_im(cent(1)-freq_wd:cent(1)+freq_wd,...
        cent(2)-freq_wd:cent(2)+freq_wd,:);
    freq_cent = squeeze(reshape(freq_im_wd,1,(freq_wd*2+1)^2,dims(3)));
    freq_change = sum(freq_cent,1)';
    freq_change = abs(freq_change(step+1:end)-freq_change(1:end-step));
    fgauss = fspecial('gaussian',[10,1],5);
    conv_change = conv(freq_change,fgauss,'same');
%     plot(conv_change)

    hh_thresh = quantile(conv_change,0.75);
    [~,raw_locs] = findpeaks(conv_change,'minpeakheight',hh_thresh);
    raw_locs = raw_locs(raw_locs>0);
    
    % merge peaks that are too close
    min_dur = 16; % this should be larger than the L in DT
    ext_locs = [1;raw_locs+round(step/2);dims(3)];
    for i = 1:length(ext_locs)-1
        if ext_locs(i+1)-ext_locs(i) < min_dur
            ext_locs(i+1) = ext_locs(i);
        end
    end
    locs = unique(ext_locs);
    
    % visualize
%     for i = 1:length(locs)
%         playVideo(locs(i):locs(i+1)-1,movieParam,1,0.01,0)
%     end
    
    fprintf('saving results...\n');
    save([locspath movieParam.fileName '_seg_loc.mat'],'locs','-v7.3');

end

%% make segmented videos
outputsz = [200,200];
ifscale = 1;

for n = 1:length(fileIndx)
    
    movieParam = paramAll(fileIndx(n));
    load([segpath movieParam.fileName '_seg.mat']);
    load([locspath movieParam.fileName '_seg_loc.mat']);

    segmat = segRegVideo(movieParam,segAll,a,b,theta,centroid,locs,...
        videospath,outputsz,ifscale);

    save([segpath movieParam.fileName '_reg_seg.mat'],'segmat','-v7.3');
    
end
