function [vector_strength,phase,bins,edges] = phase_histogram...
    (spiketimes,trigtimes,number_bins)
% This function calculates the phase histogram of two given vectors
% INPUT:
%     spiketimes: event time
%     trigtimes: trigger time (or event time from another observation)
%     num_bins: number of bins in the phase histogram plot
% OUTPUT:
%     vector_strength: strength of phase-lock
%     phase: a vector with calculated phases
%     bins: bins in histogram
%     edges: edges of the histogram
%
% SH 6/26/16

spiketimes = spiketimes(spiketimes>trigtimes(1)&spiketimes<trigtimes(end));
phase = zeros(length(spiketimes),1); 
for I = 1:length(spiketimes) 
    ind = max(find(trigtimes<=spiketimes(I))); 
    phase(I) = 2*pi*(spiketimes(I)-trigtimes(ind))/(trigtimes(ind+1)-trigtimes(ind)); 
end
edges=linspace(0,2*pi,number_bins); 
bins=histc(phase,edges); 

figure;set(gcf,'color','w');
bar(edges,bins); 
vector_strength = sqrt(mean(cos(phase)).^2+mean(sin(phase)).^2);

end