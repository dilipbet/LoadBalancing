function[L_term,utility_dual,p_star, lambda_star,j_k_star]=dual_subgradient_new(schedulable_rates_matrix,max_users_served,num_AP,num_users, a, b, imax,alpha,step_size_option)
%% *****DUAL SUB-GRADIENT ALGORITHM************
% ***INITIALIZE ACTIVITY FRACTIONS******

if(step_size_option == 1)
    sv = a./((b+(0:(imax-1)))^(1/2));
    %sv = 1*ones(1,imax);
    sv(1) = 1;
    initial_price = 10;
elseif(step_size_option == 2)
    sv = 100./((1:imax).^(1/4)); % what Ozgun understood from Dilip's email regarding the step-size choice for alpha = 4 for the submitted paper
    initial_price = 1000;
end

num_iter = length(sv);

utility_dual = zeros(1,num_iter);

user_prices = zeros(num_users,num_iter); %lambda_k s
AP_prices = zeros(num_AP,num_iter); % P_j 's

% ***INITIALIZE PRICES*****

user_prices(:,1) = 1*ones(num_users,1); %lambda_k s
AP_prices(:,1) = initial_price*ones(num_AP,1); % P_j 's

APmat = repmat((1:num_AP)',1,num_users);

%iteration 1
iter = 1;
user_prices_mat = repmat(user_prices(:,iter)',num_AP,1);
AP_prices_mat = repmat(AP_prices(:,iter),1,num_users);


buck = user_prices_mat + AP_prices_mat;
bang_per_buck = schedulable_rates_matrix./buck;  %schedulable_rates_matrix = R_kj's

[rates,j_k_iter] = max(bang_per_buck,[],1);


if(alpha==1)
    F_term(iter) = sum(log(rates))-num_users;
else
    F_term(iter) = (alpha/(1-alpha))*sum(rates.^((1-alpha)/alpha));
end
L_term(iter) = max_users_served'*AP_prices(:,iter)+sum(user_prices(:,iter))+ F_term(iter);
%pause

% ****THE ALGORITHM*******
for iter = 2:num_iter
    iter = iter;
    
    %% *****CALCULATE LIST OF AP'S WITH MAX BANG PER BUCK********
    %     user_prices_mat = repmat(user_prices(:,iter-1),num_AP,1);
    %     AP_prices_mat = repmat(AP_prices(:,iter-1),1,num_users);
    %
    %     buck = user_prices_mat + AP_prices_mat;
    %     bang_per_buck = schedulable_rates_matrix./buck;  %schedulable_rates_matrix = R_kj's
    %
    %     [rates,j_k_iter] = max(bang_per_buck,[],1); %j_k_iter is K size vector = argmax_j R_kj/P_j+lambda_k
    
    indicator = (APmat == repmat(j_k_iter,num_AP,1)) ;%indicator jk is 1 if k is in K_j
    %pause
    
    A = (bang_per_buck.^(1/alpha)).*(schedulable_rates_matrix.^(-1));
    AA = indicator.*A;
    
    
    %max_users_served = Sj's
    
    %% ******PRICE UPDATE************
    
    AP_prices(:,iter) = max(AP_prices(:,iter-1) + sv(iter)*(sum(AA,2)-max_users_served),0);
    
    user_prices(:,iter) = max(user_prices(:,iter-1)' + sv(iter)*(sum(AA,1)-1),0);
    
    
    %
    user_prices_mat = repmat(user_prices(:,iter)',num_AP,1);
    AP_prices_mat = repmat(AP_prices(:,iter),1,num_users);
    % pause
    
    buck = user_prices_mat + AP_prices_mat;
    bang_per_buck = schedulable_rates_matrix./buck;  %schedulable_rates_matrix = R_kj's
    
    [rates,j_k_iter] = max(bang_per_buck,[],1);
    
    
    if(alpha==1)
        F_term(iter) = sum(log(rates))-num_users;
    else
        F_term(iter) = (alpha/(1-alpha))*sum(rates.^((1-alpha)/alpha));
    end
    L_term(iter) = max_users_served'*AP_prices(:,iter)+sum(user_prices(:,iter))+ F_term(iter);
    
    %pause
end

[utility_dual,best_iter] = min(L_term);
p_star = AP_prices(:,best_iter);
lambda_star = user_prices(:,best_iter);
j_k_star = j_k_iter;
%******DUAL SUB-GRADIENT ENDS*********









