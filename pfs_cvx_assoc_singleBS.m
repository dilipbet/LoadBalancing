function[activity_fractions,utility_cvx] = pfs_cvx_assoc_singleBS(schedulable_rates_matrix,max_users_served,alpha,num_users)
rates = schedulable_rates_matrix'


if(alpha ==1)
    cvx_begin
    
    variable alph(num_users,1)
    maximize sum(log(alph.*rates))
    0 <= alph;
    sum(alph) <= max_users_served;
    alph <= 1;
    
    cvx_end
    
    activity_fractions = alph;
    utility_cvx = sum(log(activity_fractions.*rates));
else
    cvx_begin
    
    variable alph(num_users,1)
    maximize sum(    pow_p(alph.*rates,1),(1-alpha))/(1-alpha))
    0 <= alph;
    sum(alph) <= max_users_served;
    alph <= 1;
    
    cvx_end
    
    activity_fractions = alph;
    utility_cvx = sum(   pow_p(activity_fractions.*rates,(1-alpha))/(1-alpha),            2);
end

