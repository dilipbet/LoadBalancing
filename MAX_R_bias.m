function [activity_maxR_frame,User_Rates_maxR_frame,utility_maxR_frame,frac_users, association]  = MAX_R_bias(bias_flag,SC_NumPoints,UE_NumPoints,schedulable_rates_matrix_frame,max_users_served,threshold,alpha)
num_cells = SC_NumPoints+1;
max_rates = schedulable_rates_matrix_frame;
num_users = UE_NumPoints;
if(bias_flag==0)
    %MAX-R
   
     if(alpha==1)
    [n,max_BS] = max(schedulable_rates_matrix_frame,'',1);
    
    max_BS = repmat(max_BS,SC_NumPoints+1,1);
    xx = (1:SC_NumPoints+1)';
    xx = repmat(xx,1,UE_NumPoints);
    
    BS_load = sum((max_BS == xx),2);
    
    % what if BS_load is equal to 0 or it is less than max_users served by
    % that BS?
    
    BS_load = (BS_load == zeros(SC_NumPoints+1,1))*(-1)+(BS_load > zeros(SC_NumPoints+1,1)).*(BS_load);
    
    
    sharing_load_factor = max_users_served./BS_load;
    
    sharing_load_factor = (sharing_load_factor>=1)+(abs(sharing_load_factor)<1).*sharing_load_factor;
    
    activity_maxR_frame = (repmat(sharing_load_factor,1,UE_NumPoints)).*(max_BS == xx);
    User_Rates_maxR_frame = sum(activity_maxR_frame.*schedulable_rates_matrix_frame,1);
    utility_maxR_frame= utility(User_Rates_maxR_frame,alpha);
     else
       temp1 = (max_rates == repmat(max(max_rates,[],1),num_cells,1));
       temp2 = (cumsum(temp1,1) == 1);
       needed = repmat((sum(temp2,1)>1),num_cells,1);
       temp3 = (cumsum(temp2.*needed,1)==1);
       temp2(logical(needed))=temp3(logical(needed));
       association_matrix = temp2;
       [r c] = find(association_matrix);
       users_BS_assoc_indeces = r';
      [utility_value,long_term_rates,activity_fractions,...
       incremental_load] = BS_assoc_to_LT_rates(users_BS_assoc_indeces,...
       max_rates,max_users_served,alpha);
   activity_maxR_frame = zeros(num_cells,num_users);
   for iii = 1:num_users
       activity_maxR_frame(r(iii),iii) = activity_fractions(iii);
   end
       User_Rates_maxR_frame = long_term_rates;
       utility_maxR_frame= utility_value;
     end
        
        

    
else
    biasrateV = linspace(1,2,10);
    
    bisection = 3;
    
    bi = 1;
    while(bi<=bisection)
        i = 1;
        for biasrate = biasrateV
            [n,max_BS] = max(schedulable_rates_matrix_frame.*repmat([1;biasrate*ones(SC_NumPoints,1)],1,UE_NumPoints),'',1);
            
            
            max_BS = repmat(max_BS,SC_NumPoints+1,1);
            xx = (1:SC_NumPoints+1)';
            xx = repmat(xx,1,UE_NumPoints);
            
            BS_load = sum((max_BS == xx),2);
            
            % what if BS_load is equal to 0 or it is less than max_users served by
            % that BS?
            
            BS_load = (BS_load == zeros(SC_NumPoints+1,1))*(-1)+(BS_load > zeros(SC_NumPoints+1,1)).*(BS_load);
            
            
            sharing_load_factor = max_users_served./BS_load;
            
            sharing_load_factor = (sharing_load_factor>=1)+(abs(sharing_load_factor)<1).*sharing_load_factor;
            
            activity_maxR_frame = (repmat(sharing_load_factor,1,UE_NumPoints)).*(max_BS == xx);
            User_Rates_maxR_frame = sum(activity_maxR_frame.*schedulable_rates_matrix_frame,1);
            utility_maxR_frame(i)= utility(User_Rates_maxR_frame,alpha);
            
          
            i = i +1;
        end
        
        [value, index] = max(utility_maxR_frame);
        
        biasrateV = linspace(biasrateV(max(1,index-1)),biasrateV(min(index+1,length(biasrateV))),12);
        bi = bi+1;
        utility_maxR_frame = [];
        %pause
        
    end
    bias_factor = biasrateV(index);
    utility_maxR_frame = value;
    
    
    
    
    
end

% association and fractional users
association = activity_maxR_frame>threshold;

user_edge_num = sum(association,1);

BS_edge_num = sum(association,2)';

[max_users_per_BS,which_BS] = max(BS_edge_num);

[frac_users] = find(user_edge_num>1);
