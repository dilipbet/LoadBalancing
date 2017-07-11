function [utility_values,activity_fraction_matrix,long_term_rates,users_BS_assoc_indeces,switch_indicator,switching_users_flags,pi_prob, activity_fractions] = user_centric_assoc(num_cells,num_users,max_rates,max_users_served,gamma,num_iter,pi_vec)

% function [utility_values,activity_fraction_matrix,long_term_rates,users_BS_assoc_indeces,switch_indicator,switching_users_flags,pi_prob, activity_fractions] = user_centric_assoc(num_cells,num_users,max_rates,max_users_served,gamma,num_iter,pi_vec)
%
% Decentralized user association with user-centric switching objective (promised long-term rate based)
% Switching occurs probabilistically at each iteration (with common switching probability across all users at each iteration)
% 
%
% Inputs:
%  num_cells: number of BSs
%  num_users: number of users
%  max_rates: a matrix of size num_cells by num_users containing the BS-user peak rates
%  max_users_served: a vector of size num_cells, with the j-th entry containing number of simulataneously served users by BS j
%  gamma: this is the alpha-fairness parameter 
%  num_iter: maximum number of iterations for the user-centric association algorithm
%  pi_vec: this is 2x1 vector  providing the starting-iteration and ending-iteration switching
%          probabilities (at each iteration \pi is the same across ALL users; exponential decay across iteration indeces)
%
% Outputs:
% utility_values: a vector where the ith entry contains the resulting
%                 utility value after iteration i; as the algorithm terminates when there's no more chance for switching (all users are happy with their choice)
%                 utility_values has length <= num_iter
% activity_fractions_matrix: a matrix of size num_cells by num_users containing the ending user-BS acrtivity fractions
%                     (note: due to unique association restriction, each column has a single non-zero element)
% long_term_rates: a vector of size num_users containing  the ending long term user rates 
% user_BS_assoc_indeces: the ith row is a vector of dimension num_users;
%                        entry (i,k) equals the index of the BS to which user k is
%                        associated after iteration i of the decentralized algorithm
% 

% if num_iter is not specified set it to a default value
if nargin<6, num_iter = 10000; end
if isempty(num_iter), num_iter = 10000; end

% if pi_vec is not specified set it to a default value
if nargin<7, pi_vec= 0.1; end
if isempty(pi_vec), pi_vec= 0.1; end


% construct the sequence of probabilities pi(1), pi(2), ..., pi(num_iter)
pi_prob= pi_vec*ones(1,num_iter-1);% corresponding to pi in the paper. Kept fixed across iterations (and also users)

% the next row vector allows efficient conversion of column vectors of
% size num_cells (such as max_users_served) to matrices of size num_cells by num_users where each
% column entry of the vector is repeated across the matrix row.
Ones_UE = ones(1,num_users);

% Compute the incremental BS-user load matrix
incremental_load = (max_rates).^(1/gamma-1);

% make sure max_users_served is a column vector
max_users_served = max_users_served(:);


% initialize users_BS_assoc_indeces matrix
users_BS_assoc_indeces = zeros(num_iter,num_users);

% initialize switching_users_flags matrix
switching_users_flags = zeros(num_iter-1,num_users);


% obtain the BS indeces corresponding to peak-rate association for each
% user
[rates_max_rate_assoc, peak_rate_association] = max(max_rates,[],1);


% initialize the iteration cycle
cycle=1;

% in the first cycle we initialize the system with peak-rate based BS-user
% association
users_BS_assoc_vec=peak_rate_association;
users_BS_assoc_indeces(cycle,:)=  users_BS_assoc_vec;

% obtain the corresponding association_matrix
% association_matrix(j,k) equals 1 if user k is assoc. to BS j, and 0
% otherwise
association_matrix =assoc_indeces_to_matrix(users_BS_assoc_vec,num_cells);

% obtain the corresponding load of each BS
load = sum(association_matrix.*incremental_load,2);


% this flag will be set to zero if on some iteration no user wishes to
% switch association. this in effect means that we should stop iterating
switch_indicator=1; 

% when the following flag becomes zero iterations will stop 
% this will happen after num_iter iterations or if switch_flag=0 (whichever comes first
continue_evolution_flag=1;

while(continue_evolution_flag)
    % load contains sum in denominator of (27) based on association
    % state from previous cycle
    previous_load = load(:) * Ones_UE;
    
    % the (j,k)th entry of new_potential_load contains:
    % the denominator on the LHS of (30) if user k is associated
    % with  BS j
    % the denominator on the RHS of (30) otherwise  
    new_potential_load = previous_load + (1-association_matrix) .* incremental_load;
 
    % promised_activity_fractions is a num_cells by num_users matrix
    % the (j,k)-th entry contains the activity fraction"promised" to user k by BS j   
    promised_activity_fractions = min((((max_users_served(:) * Ones_UE) .* incremental_load) ./ new_potential_load), 1);
    
    % promised_long_term_rate is a num_cells by num_users matrix
    % the (j,k)-th entry contains the long-term rate "promised" to user k by BS j 
    promised_long_term_rate = promised_activity_fractions .* max_rates;
    
    % users_BS_choice: vector containing users BS choices based on promised long term rates 
    %                  the value of the (k)-th entry equals the preferred BS index by user k
    [max_promised_rate, users_BS_choice] = max(promised_long_term_rate,[],1);
    
    % Users switch probabilistically
    % if switch_flag(k)=1,  user k will switch (provided it's been promissed a higher long-term rate by another BS)
    % if switch_flag(k)=0, user k will not switch in this cycle no matter what
    switch_flag = (rand(1,num_users)<pi_prob(cycle));
    
    if isequal(users_BS_choice,users_BS_assoc_vec)
        switch_indicator=0;  % stop iterating; no user will switch associations any more (Nash)
    else
        
        % determine the new user BS associations:
        % if a BS offers a user a better promised rate than his own, the
        % user switches with prob. pi_prob(cycle);
        users_new_BS_assoc_vec = users_BS_assoc_vec .* (1-switch_flag) + users_BS_choice .* switch_flag;
        
        % find the users that will actually switch their associations
        switching_users = ~(users_new_BS_assoc_vec == users_BS_assoc_vec);
        switching_users_flags(cycle,:) = switching_users; 
        
        % set the new associations 
        users_BS_assoc_vec=users_new_BS_assoc_vec;

        % obtain the new association matrix
        association_matrix =assoc_indeces_to_matrix(users_BS_assoc_vec,num_cells);
        
        % obtain the new load of each BS
        load = sum(association_matrix.*incremental_load,2);   
    end  
    
    % increment the iteration
    cycle=cycle+1;
    % store the new associations
    users_BS_assoc_indeces(cycle,:)=  users_BS_assoc_vec;
    
    % if we reached the maximum number of interations or Nash, then stop
    % iterating
    if num_iter==cycle, continue_evolution_flag=0; end
    if switch_indicator==0, continue_evolution_flag=0; end
end

% reduce the number of users_BS_assoc_indeces to equal the number of cycles
% that were actually run
if cycle<num_iter, users_BS_assoc_indeces(cycle+1:num_iter,:)=  []; end

% next compute the activity fractions and the corresponding long term rates
[utility_values,long_term_rates,activity_fractions] = BS_assoc_to_LT_rates(users_BS_assoc_indeces,max_rates,max_users_served,gamma);

%create the final iteration BS-user activity_fraction_matrix
activity_fraction_matrix = (ones(num_cells,1)*activity_fractions(end,:)) .* association_matrix;
