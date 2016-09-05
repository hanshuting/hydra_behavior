function [hists] = sqrtHist(hists,num_iter)

% smooth the histogram by calculating square root and renormalization

for i = 1:num_iter
    hists = sqrt(hists);
    hists = hists./(sum(hists,2)*ones(1,size(hists,2)));
end

end