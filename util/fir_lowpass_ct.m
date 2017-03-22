function x_filt = fir_lowpass_ct(x,normfreq_lpass)
% design a FIR lowpass filter
% INTPUT:
%     x: num_sample-by-T matrix
%     normfreq_lowpass: normalized lowpass cutoff. 1 correspond to Nyquist
%         rate
% OUTPUT:
%     x_filt: filtered data matrix
% 
% Shuting Han, 2017

% filter length
% nlfilt = 40;
nlfilt = 1000;

% filt length must less than 1/3 of the data
T = size(x,2);
if (nlfilt > T/3-1) 
    nlfilt = floor(T/3-1);
    if mod(nlfilt,2);
        nlfilt = nlfilt-1;
    end
end

% sampling frequency in ms
hfilt = fir1(nlfilt, normfreq_lpass, 'low');

% use filtfilt to get zero phase lag
x_filt = filtfilt(hfilt, 1, x')';

end
