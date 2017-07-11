
function BS_Power = Pathloss_Calculation(DistanceM,model,MC_power, SC_power, Noise_power)

if(strcmp(model,'WINNER'))
    pathloss = winner(DistanceM);
    pathloss = 10.^(-pathloss/10);
    
elseif(strcmp(model,'simple'))
    alpha = 3.5;
    delta = 40;
    pathloss = 1./(1+(DistanceM/delta).^alpha);
elseif(strcmp(model,'caramannis'))
    %L(d) = A+B*log(d)+sqrt(shad_var)*randn(1)
    MC_A = 34;
    MC_B = 40;
    SC_A = 37;
    SC_B = 30;
    sigma_s = 8;%log normal shadowing deviation
    
    
    pathloss = zeros(DistanceM);
    pathloss(1,:,:) = MC_A+MC_B*log(DistanceM(1,:,:))+sqrt(shad_var)*randn(1,size(Distance_M,2),size(Distance_M,3));
    pathloss(2:size(DistanceM,1),:,:) = SC_A+SC_B*log(DistanceM(2:size(DistanceM,1),:,:))+sqrt(shad_var)*randn(size(Distance_M,1)-1,size(Distance_M,2),size(Distance_M,3));

  
 
  

    
end



BS_power = [MC_power; SC_power*ones(size(DistanceM,1)-1,1)];
BS_power = repmat(BS_power,1,size(DistanceM,2));

received_power = BS_power.*pathloss;

% signal_plus_int_power = sum(received_power,1);
% int_power = repmat(signal_plus_int_power,num_AP,1)- received_power;
% pathloss_SINR = received_power./(noise_power + int_power);
