function[Valid] = activity_constraints(activity,max_users_served)

BS_invalid = length(find(sum(activity,2)>max_users_served));
if(BS_invalid)
    sum(activity,2)
    pause
end
UE_invalid = length(find(sum(activity,1)>1));
invalid = length(find(activity<0));

Valid = (BS_invalid +UE_invalid +invalid) == 0;