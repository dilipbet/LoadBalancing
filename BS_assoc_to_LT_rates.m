function [utility_value,long_term_rates,activity_fractions,incremental_load] = BS_assoc_to_LT_rates(users_BS_assoc_indeces,max_rates,max_users_served,gamma)

% function [utility_value,long_term_rates,activity_fractions,incremental_load] = BS_assoc_to_LT_rates(users_BS_assoc_indeces,max_rates,max_users_served,gamma)
% 
% The function takes as inputs:
%
%       max_rates: a matrix of dimensions N_BS by N_Users
%              max_rates(j,k) contains the peak rate given to user k by BS j
%
%       users_BS_assoc_indeces: a matrix of dimensions N_iter by N_users
%             users_BS_assoc_indeces(n,k) contains the index of BS in the n-th
%             association instance (across all BS-user pairs)
%
%       max_users_served: an N_BS by 1 vector
%            max_users_served(j) = Sj, the number of simultaneously served
%                                   users by BSj
%
%      gamma: this is the alpha-fairness parameter
%`            it should be greater than or equal to 1
%
%
% The function produces as outputs:
% 
%    activity_fractions: a matrix of dimensions N_iter by N_users
%             activity_fractions(n,k) contains the activity fraction
%             provided by BS with index users_BS_assoc_indeces(n,k) to user
%             k in the n-th association instance
%
%    long_term_rates: a matrix of dimensions N_iter by N_users
%             long_term_rates(n,k) contains thelong term rates
%             provided by BS with index users_BS_assoc_indeces(n,k) to user
%             k in the n-th association instance
%     utility_value: an N_iter by 1 vector
%             utility_value(n) provides the network-wide utility value
%             provided by network to its users  in the  n-th
%             association instance (across all BS-user pairs)
%            

% add epsilon to each zero-entry of max_rates to avoid ill-conditioned
% results later
U=find(max_rates==0); max_rates(U)=eps;

% Compute the incremental BS-user load matrix
incremental_load = (max_rates).^(1/gamma-1); 

% make sure max_users_served is a column vector
max_users_served = max_users_served(:);

[N_iter,N_Users] =size(users_BS_assoc_indeces);
[N_BS, N_Usersb] = size(max_rates);

if N_Users ~=N_Usersb
    % the number of users for which BS association information is available
    % must agree with the number of users for which peak-rates are
    % provided!
    % If the two numbers do not agree, the program exits with babis_error
    babis_error;
end

% activity_fractions(i,k) should contain the activity fraction given to
% user k by the base station with index equal to users_BS_assoc_indeces(i,k)
activity_fractions = zeros(N_iter,N_Users);
% long_term_rates(i,k) should contain the long term rate given to
% user k by the base station with index equal to users_BS_assoc_indeces(i,k)
long_term_rates = zeros(N_iter,N_Users);

for ii=1:N_iter
    % obtain the association of each user for assignment ii
    U_BS_Ind = users_BS_assoc_indeces(ii,:);
    for j=1:N_BS  % for each BS
        
        Kj_set = find(U_BS_Ind==j); % set of users associated with BS j
        KjL = length(Kj_set);  % size for the set
        Sj = max_users_served(j);  % BS j serves Sj users at a time
        
        if Sj >= KjL
            % every associated user gets activity fraction 1
            activity_fractions(ii,Kj_set) = 1;
        else
            if gamma==1
                % the PFS case is easier:
                activity_fractions(ii,Kj_set) = Sj*incremental_load(j,Kj_set)/sum(incremental_load(j,Kj_set));
            else
                % the gamma>1 case is trickier
                
                % first order users in terms of increasing incremental load
                [ILj_ordered, Kj_ordered] = sort(incremental_load(j,Kj_set),'ascend');
                
                Svec= 1:Sj;
                
                % the n-th entry of Accum_IL contains the accumulated load of the
                % n users contributing the LOWEST incremental load
                Accum_IL = cumsum(ILj_ordered);
                
                % Kj_ordered(Ij) will denote the indeces of the users with the LARGEST Sj incremental loads
                Ij= KjL-Sj+1:KjL;
                
                % if the n-th element of Ln below is greater than 1, then, ordered users
                % Ij(n), Ij(n+1) ..., KjL have activity fraction equal to 1
                
                Ln = Svec .* ILj_ordered(Ij) ./ Accum_IL(Ij);
               
                UN = find(Ln>1); % indeces of users with projected activity fraction greater than 1.
                if ~isempty(UN)
                    % if the  UN set is non-empty:
                    % the users with indeces in UN can get activity
                    % fraction at most 1
                    activity_fractions(ii,Kj_set(Kj_ordered(Ij(UN(1):end))))=1;
                    % The rest of users get a fraction of the "Sleft" 
                    % resources that is proportional to their relative
                    % incremental load (i.e., their incremental load over  
                    % the sum of the incremental loads of all users not in UN)
                    Sleft = UN(1)-1;
                    Kleft = Kj_set(Kj_ordered(1:Ij((UN(1)-1))));
                    activity_fractions(ii,Kleft) = Sleft*incremental_load(j,Kleft)/sum(incremental_load(j,Kleft));
                else
                    % if the UN set is empty:
                    % Each user gets a fraction of the Sj resources 
                    % proportional to its relative incremental load
                    % (i.e., Sj times its incremental load over the 
                    % sum of the incremental load of all the users 
                    % associated with this BS)
                    activity_fractions(ii,Kj_set) = Sj*incremental_load(j,Kj_set)/sum(incremental_load(j,Kj_set));
                end
                
            end
        end
        % obtain the corresponding long_term_rates
        long_term_rates(ii,Kj_set) = max_rates(j,Kj_set) .* activity_fractions(ii,Kj_set);
    end
end

% utility_value is a collumn vector whose i-th entry contains 
% the nework wide utility obtained at  i-th assocuation instance
if gamma~=1
    utility_value = sum(long_term_rates.^(1-gamma),2)/(1-gamma);
else
    utility_value = sum(log(long_term_rates),2);
end



