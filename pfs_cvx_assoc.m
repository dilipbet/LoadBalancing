function[activity_fractions,utility_cvx] = pfs_cvx_assoc(schedulable_rates_matrix,num_AP,num_users,max_users_served,alpha)
rates = schedulable_rates_matrix;


if(alpha ==1)
    cvx_begin
    
    variable alph(num_AP,num_users)
    maximize sum(log(sum(alph.*rates,1)),2)
    0 <= alph;
    sum(alph,2) <= max_users_served;
    sum(alph,1) <= 1;
    
    cvx_end
    
    activity_fractions = alph;
    utility_cvx = sum(log(sum(activity_fractions.*rates,1)),2);
else
    cvx_begin
    
    variable alph(num_AP,num_users)
    maximize sum(    pow_p(sum(alph.*rates,1),(1-alpha))/(1-alpha)           ,2)
    0 <= alph;
    sum(alph,2) <= max_users_served;
    sum(alph,1) <= 1;
    
    cvx_end
    
    activity_fractions = alph;
    utility_cvx = sum(   pow_p(sum(activity_fractions.*rates,1),(1-alpha))/(1-alpha),            2);
end

