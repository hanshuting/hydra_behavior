function h = subplottight(n,m,i)
% this function creates a tight subplot handle (no margin)

    [c,r] = ind2sub([m n], i);
    ax = subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n]);
    if(nargout > 0)
        h = ax;
    end
    
end