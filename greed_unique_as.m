function[assoc, max_utility, max_rates] choosing_best_unique_assocation(schedulable_rates_matrix_frame)
    % Case1: 12-3
    case_num = 1;
    
    r1 = schedulable_rates_matrix_frame(1,1);
    r2 = schedulable_rates_matrix_frame(1,2);
    r3 = schedulable_rates_matrix_frame(2,3);
    
    utility_int(case_num) = sum(log([r1 r2 r3]));
    
    % Case2: 13-2
    case_num = 2;
    r1 = schedulable_rates_matrix_frame(1,1);
    r2 = schedulable_rates_matrix_frame(2,2);
    r3 = schedulable_rates_matrix_frame(1,3);
    
    utility_int(case_num) = sum(log([r1 r2 r3]));
    
    % Case3: 23-1
    case_num = 3;
    r1 = schedulable_rates_matrix_frame(2,1);
    r2 = schedulable_rates_matrix_frame(1,2);
    r3 = schedulable_rates_matrix_frame(1,3);
    
    utility_int(case_num) = sum(log([r1 r2 r3]));
    
    % Case4: 123- empty
    case_num = 4;
    % in this case number of users associated to a BS is more than max
    % users sereved, so optimal distribution of the resources of this
    % single BS is done CVX. In case of PFS it should be activities(k) =
    % 2/3
    [activities,utility] = cvx_assoc_singleBS(schedulable_rates_matrix_frame(1,:),max_users_served,alpha,3)
    
    r1 = activities(1)*schedulable_rates_matrix_frame(1,1);
    r2 = activities(2)*schedulable_rates_matrix_frame(1,2);
    r3 = activities(3)*schedulable_rates_matrix_frame(1,3);
    
    utility_int(case_num) = sum(log([r1 r2 r3]));
    
    % Case5: empty-123
    case_num = 5;
     % in this case number of users associated to a BS is more than max
    % users sereved, so optimal distribution of the resources of this
    % single BS is done CVX. In case of PFS it should be activities(k) =
    % 2/3
    [activities,utility] = cvx_assoc_singleBS(schedulable_rates_matrix_frame(2,:),max_users_served,alpha,3)
    r1 = activities(1)*schedulable_rates_matrix_frame(2,1);
    r2 = activities(2)*schedulable_rates_matrix_frame(2,2);
    r3 = activities(3)*schedulable_rates_matrix_frame(2,3);
    
    utility_int(case_num) = sum(log([r1 r2 r3]));
    
    % Case6: 3-12
    case_num = 6;
    r1 = schedulable_rates_matrix_frame(2,1);
    r2 = schedulable_rates_matrix_frame(2,2);
    r3 = schedulable_rates_matrix_frame(1,3);
    
    utility_int(case_num) = sum(log([r1 r2 r3]));
    
    % Case7: 2-13
    case_num = 7;
    r1 = schedulable_rates_matrix_frame(2,1);
    r2 = schedulable_rates_matrix_frame(1,2);
    r3 = schedulable_rates_matrix_frame(2,3);
    
    utility_int(case_num) = sum(log([r1 r2 r3]));
    
    % Case8: 1-23
    case_num = 8;
    r1 = schedulable_rates_matrix_frame(1,1);
    r2 = schedulable_rates_matrix_frame(2,2);
    r3 = schedulable_rates_matrix_frame(2,3);
    
    utility_int(case_num) = sum(log([r1 r2 r3]));
    
    [max_utility, max_case_num] = max(utility_int);
    
    UE_BS = [1 1 2;
            1 2 1;
            2 1 1;
            1 1 1;
            2 2 2;
            2 2 1;
            2 1 2;
            1 2 2];
   max_UE_BS = UE_BS(max_case_num,:);
   assoc = [max_UE_BS==1; max_UE_BS == 2];
   
    r1 = schedulable_rates_matrix_frame(max_UE_BS(1),1);
    r2 = schedulable_rates_matrix_frame(max_UE_BS(2),2);
    r3 = schedulable_rates_matrix_frame(max_UE_BS(3),3);
    
    max_rates = [r1 r2 r3];