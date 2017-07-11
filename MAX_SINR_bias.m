function [activity_maxS_frame,User_Rates_maxS_frame,utility_maxS_frame]  = MAX_SINR_bias(bias_flag,path_loss_frame,SC_NumPoints,UE_NumPoints,schedulable_rates_matrix_frame,MC_power, SC_power,max_users_served)

if(bias_flag==0)
    %MAX-SINR = maxS
    PM = [MC_power; SC_power*ones(SC_NumPoints,1)];
    PM = repmat(PM,1,UE_NumPoints);
    [n,max_BS] = max(PM.*path_loss_frame,'',1);
    
    max_BS = repmat(max_BS,SC_NumPoints+1,1);
    xx = (1:SC_NumPoints+1)';
    xx = repmat(xx,1,UE_NumPoints);
    
    BS_load = sum((max_BS == xx),2);
    
    % what if BS_load is equal to 0 or it is less than max_users served by
    % that BS?
    
    BS_load = (BS_load == zeros(SC_NumPoints+1,1))*(-1)+(BS_load > zeros(SC_NumPoints+1,1)).*(BS_load);
    
    
    sharing_load_factor = max_users_served./BS_load;
    
    sharing_load_factor = (sharing_load_factor>=1)+(abs(sharing_load_factor)<1).*sharing_load_factor;
    
    activity_maxS_frame = (repmat(sharing_load_factor,1,UE_NumPoints)).*(max_BS == xx);
    User_Rates_maxS_frame = sum(activity_maxS_frame.*schedulable_rates_matrix_frame,1);
    utility_maxS_frame= sum(log( User_Rates_maxS_frame));
    
    
    
else
    biasdBV = 0:12;
    
    bisection = 3;
    
    bi = 1;
    while(bi<=bisection)
        i = 1;
        for biasdB = biasdBV
            PM = [MC_power; 10^(0.1*biasdB)*SC_power*ones(SC_NumPoints,1)];
            PM = repmat(PM,1,UE_NumPoints);
            [n,max_BS] = max(PM.*path_loss_frame,'',1);
            
            max_BS = repmat(max_BS,SC_NumPoints+1,1);
            xx = (1:SC_NumPoints+1)';
            xx = repmat(xx,1,UE_NumPoints);
            
            BS_load = sum((max_BS == xx),2);
            
            % what if BS_load is equal to 0 or it is less than max_users served by
            % that BS?
            
            BS_load = (BS_load == zeros(SC_NumPoints+1,1))*(-1)+(BS_load > zeros(SC_NumPoints+1,1)).*(BS_load);
            
            
            sharing_load_factor = max_users_served./BS_load;
            
            sharing_load_factor = (sharing_load_factor>=1)+(abs(sharing_load_factor)<1).*sharing_load_factor;
            
            activity_maxS_frame = (repmat(sharing_load_factor,1,UE_NumPoints)).*(max_BS == xx);
            User_Rates_maxS_frame = sum(activity_maxS_frame.*schedulable_rates_matrix_frame,1);
            utility_maxS_frame(i)= sum(log( User_Rates_maxS_frame));
            i = i +1;
        end
        
        [value, index] = max(utility_maxS_frame);
        
        biasdBV = linspace(biasdBV(max(1,index-1)),biasdBV(min(index+1,length(biasdBV))),12);
        bi = bi+1;
        utility_maxS_frame = [];
        %pause
        
    end
    bias_factor = biasdBV(index);
    utility_maxS_frame = value;
    
    
end