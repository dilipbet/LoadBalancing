function [X,Y,frac_users,max_edges,Int_MC_users,Int_SC_users,BS_edge_num] = getXY(activity_frame, threshold,BS_Locs, UE_Locs, frame,UE_NumPoints)

cell_side = 900
edge_matrix = activity_frame>threshold;
[rows, cols] = find(edge_matrix);

BS_points = BS_Locs(frame,rows);
UE_points = UE_Locs(frame,cols);



X = zeros(2,length(cols));
Y = zeros(2,length(cols));
X(1,:) = real(UE_points);
Y(1,:) = imag(UE_points);
X(2,:) = real(BS_points);
Y(2,:) = imag(BS_points);

for col = 1:length(cols)
    if(abs(X(1,col)-X(2,col))> (cell_side-abs(X(1,col)-X(2,col))))
        %wrap-around
        X(2,col) = X(2,col)+cell_side*sign(X(1,col)-X(2,col));
    end
    if(abs(Y(1,col)-Y(2,col))> (cell_side-abs(Y(1,col)-Y(2,col))))
        %wrap-around
        Y(2,col) = Y(2,col)+cell_side*sign(Y(1,col)-Y(2,col));
    end
    
end



user_edge_num = sum(edge_matrix,1);

BS_edge_num = sum(edge_matrix,2)';

[max_users_per_BS,which_BS] = max(BS_edge_num);

[frac_users] = find(user_edge_num>1);
[int_users] = find(user_edge_num==1);

max_edges = max(user_edge_num(frac_users));

Int_MC_users = sum(edge_matrix(1,int_users));
Int_SC_users = UE_NumPoints-Int_MC_users-length(frac_users);

%---------

%  association = activity_fractions>threshold;
%  
%     
%     user_edge_num_cvx = sum(association,1);
%     
%     BS_edge_num_cvx = sum(association,2)';
%     
%     [max_users_per_BS_cvx,which_BS_cvx] = max(BS_edge_num_cvx);
%     
%     [frac_users] = find(user_edge_num_cvx>1);
%     
%     edge_frac_users_cvx = user_edge_num_cvx(frac_users);
%    