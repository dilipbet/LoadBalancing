function [ Assoc_matrix ] = assoc_indeces_to_matrix(Assoc_indeces,J)
% function [ Assoc_matrix ] = assoc_indeces_to_matrix(Assoc_indeces,J)
%   Given: 
%           J: number of BSs
%           Assoc_indeces: vector of length NU (number of users) containing user-BS associations
%               Assoc_indeces(k) = j <==>  user k is associated with BS j
%   Produces:
%           Assoc_matrix: JxNU association matrix
%               Assoc_indeces(j,k)=1  <==>  user k is associated with BS j
%               Assoc_indeces(j,k)=0 for all other (j,k) pairs
%                   


Assoc_indeces =  Assoc_indeces(:).';  % make sure this is a row vector

NU = length(Assoc_indeces);   % number of users

if max(Assoc_indeces)> J || min(Assoc_indeces)< 1,
    disp(['A user is associated with BS with index ' num2str(max(Assoc_indeces))]);
    disp(['However, available BSs have indeces between 1 and ' num2str(J)]);
    babis_error; 
end

Assoc_matrix = zeros(J, NU); % initialize Association matrix


% Next, if Assoc_indeces(k)=j, we need to set 
% Assoc_matrix(j,k)=1
% We do this efficiently, by identifying the entries of the matrix
% that need to be 1

One_entries = Assoc_indeces + (0:(NU-1))*J;

Assoc_matrix(One_entries) = 1;

end

