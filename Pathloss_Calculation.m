
function [path_loss,pathloss_dB] = Pathloss_Calculation(DistanceM,model,pm1,pm2,pm3,pm4,pm5)

if(strcmp(model,'WINNER'))
    path_lossdB = winner(DistanceM);
    path_loss = 10.^(-path_lossdB/10);
    WINNER_check_before_using;
    
elseif(strcmp(model,'Simple'))
    alpha = pm1;
    delta = pm2;
    path_loss = 1./(1+(DistanceM/delta).^alpha);
    pathloss_dB = -10*log10(path_loss);
    
elseif(strcmp(model,'Caramannis'))
    %L(d) = A+B*log(d)+sqrt(shad_var)*randn(1)
    MC_A = pm1;
    MC_B = pm2;
    SC_A = pm3;
    SC_B = pm4;
    shad_var = pm5;
    
    
    path_loss_dB = zeros(size(DistanceM));
    path_loss_dB(1,:,:) = MC_A+MC_B*log(DistanceM(1,:,:))+sqrt(shad_var)*randn(1,size(DistanceM,2),size(DistanceM,3));
    path_loss_dB(2:size(DistanceM,1),:,:) = SC_A+SC_B*log(DistanceM(2:size(DistanceM,1),:,:))+sqrt(shad_var)*randn(size(DistanceM,1)-1,size(DistanceM,2),size(DistanceM,3));

  path_loss= 10.^(-0.1*path_loss_dB);
 
  

    
end



