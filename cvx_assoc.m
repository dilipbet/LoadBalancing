function[activity_fractions,utility_cvx, user_rates, association, frac_users] = cvx_assoc(schedulable_rates_matrix,num_AP,num_users,max_users_served,alpha, threshold)
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

 user_rates = sum(activity_fractions.*schedulable_rates_matrix,1);
 association = activity_fractions>threshold;
 
    
    user_edge_num_cvx = sum(association,1);
    
    BS_edge_num_cvx = sum(association,2)';
    
    [max_users_per_BS_cvx,which_BS_cvx] = max(BS_edge_num_cvx);
    
    [frac_users] = find(user_edge_num_cvx>1);
    
    edge_frac_users_cvx = user_edge_num_cvx(frac_users);