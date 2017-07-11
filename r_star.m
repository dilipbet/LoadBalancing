function [r_starv] = r_star(p_star, lambda_star, schedulable_rates_matrix, num_AP, num_users,alpha)

user_prices_mat = repmat(lambda_star',num_AP,1);
AP_prices_mat = repmat(p_star,1,num_users);




buck = user_prices_mat + AP_prices_mat;
bang_per_buck = schedulable_rates_matrix./buck;  %schedulable_rates_matrix = R_kj's

[r_starv] = max(bang_per_buck);

r_starv = r_starv.^(1/alpha);