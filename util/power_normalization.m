function [norm_data] = power_normalization(data,rho)
% (signed) power normalization of input data
% SYNOPSIS:
%     [norm_data] = power_normalization(data,rho)
% INPUT:
%     data: rows are observatioin, columns are variables
%     rho: power, range [0,1]
% OUTPUT:
%     norm_data: normalized data
% 
% Shuting Han, 2015

sign_data = sign(data);
norm_data = abs(data).^rho;
norm_data = norm_data.*sign_data;

end