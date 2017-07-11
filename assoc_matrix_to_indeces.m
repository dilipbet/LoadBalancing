function [Assoc_indeces] = assoc_matrix_to_indeces(Assoc_matrix)
% function [Assoc_indeces  ] = assoc_matrix_to_indeces(Assoc_matrix)
%   Given: 
%           Assoc_matrix: JxNU association matrix (J= # of BSs, NU= # of users)
%               Assoc_indeces(j,k)=1  <==>  user k is associated with BS j
%               Assoc_indeces(j,k)=0 for all other (j,k) pairs
%          
%   Produces:
% 
%           Assoc_indeces: vector of length NU (number of users) containing user-BS associations
%               Assoc_indeces(k) = j <==>  user k is associated with BS j
%                   




[Assoc_indeces, User_indeces] =  find(Assoc_matrix);

NUBS = length(Assoc_indeces);   % number of users-BS association pairs;
NU = size(Assoc_matrix,2);      % number of users

if NUBS ~= NU                   % unique user-BS association--> NUBS should equal NU
    disp(['Number of user-BS association pairs: ' num2str(NUBS)]);
    disp(['Number of users: ' num2str(NU)]);
    babis_error;
else
    non_uniq_assoc_indicator =  norm(User_indeces.' - (1:NU));
    if non_uniq_assoc_indicator
        disp(['Each user should be exactly associated with a single BS'])
        babis_error;
    end
end

Assoc_indeces = Assoc_indeces.';


end

