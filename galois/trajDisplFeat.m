
% set parameters
rng(1000)
fileIndx = [1:5,7:11,13:24,26:28,30:32,35:56];
time_step = 25;
annoType = 5;
L = 15;
W = 2;
N = 32;
s = 1;
t = 1;
K = 256;
ci = 90;
num_region = 3;
datastr = '20160315_spseg3';
infostr = ['L_' num2str(L) '_W_' num2str(W) '_N_' num2str(N) '_s_' num2str(s) '_t_' num2str(t) '_step_' num2str(time_step)];
datapath = ['/home/sh3276/work/results/dt_results_assembled/registered/' infostr '_' datastr '/'];
segpath = '/home/sh3276/work/results/register_param/seg_3region_20160310/';
annoPath = '/home/sh3276/work/data/annotations/';

%%
bin_range = 0:0.005:0.05;
displAll = [];
raAll = [];
rareaAll = [];
acm = ones(length(fileIndx),1);
fgauss = fspecial('gaussian',[3,1],1);

for i = 1:length(fileIndx)
    
    movieParam = paramAll_galois(fileIndx(i));
    fprintf('processing file %s...\n',movieParam.fileName')
    load([datapath movieParam.fileName '_' infostr '_traj.mat']);
    load([segpath movieParam.fileName '_seg']);
    
    tt = size(trajAll,1);
    acm(i+1) = acm(i)+tt;
    
    for j = 1:num_region
        for k = 1:size(trajAll,1)
            traj = trajAll{k,j};
            displ = traj(:,1:2:end).^2+traj(:,2:2:end).^2;
            hist_displ = histc(displ(:),bin_range);
            hist_displ = hist_displ/sum(hist_displ);
            displAll(acm(i)+k,(j-1)*length(bin_range)+1:j*length(bin_range)) = hist_displ';
        end
    end
    
    for j = 1:tt
        
        tw_a = a((j-1)*time_step+1:j*time_step);
        tw_area = zeros(time_step,1);
        for k = 1:time_step
            tw_area(k) = sum(sum(segAll(:,:,(j-1)*time_step+k)~=0));
        end
        
        tw_a = conv(tw_a,fgauss,'same');
        tw_area = conv(tw_area,fgauss,'same');
        
        raAll(end+1,:) = (tw_a(2:end)-tw_a(1:end-1))./tw_a(1:end-1);
        rareaAll(end+1,:) = (tw_area(2:end)-tw_area(1:end-1))./tw_area(1:end-1);
        
    end
    
end



