function [ Rstat ] = utility_value_to_rate_statistic(utility_value_vec, alpha, Nusers)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


if alpha~=1

Rstat = ((1-alpha)*utility_value_vec/Nusers).^(1/(1-alpha));
else
Rstat = exp(utility_value_vec/Nusers);    

end

