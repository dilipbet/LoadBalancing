function schedulable_rates_matrix= Massive_MIMO_rate_calculation(path_loss,MC_powerdBm, SC_powerdBm,Noise_powerdBm,SC_NumPoints,UE_NumPoints,DistanceM,NumFrames,MC_M,MC_S,SC_M,SC_S)
MC_power = 10^(0.1*MC_powerdBm);
SC_power = 10^(0.1*SC_powerdBm);
Noise_power = 10^(0.1*Noise_powerdBm);

pathloss_SINR = zeros(size(DistanceM));

BS_power = [MC_power; SC_power*ones(size(DistanceM,1)-1,1)];
BS_power = repmat(BS_power,1,size(DistanceM,2));

for frame = 1:NumFrames
    BS_power_frame = BS_power;
    if(size(DistanceM,1)>2)
        BS_power_frame((SC_NumPoints(frame)+2):size(DistanceM,1),1:size(DistanceM,2)) = zeros(size(DistanceM,1)-SC_NumPoints(frame)-1,size(DistanceM,2));
    end
    received_power = BS_power_frame.*path_loss(:,:,frame);
    
    signal_plus_int_power = sum(received_power,1);
    int_power = repmat(signal_plus_int_power,size(DistanceM,1),1)- received_power;
    pathloss_SINR(:,1:UE_NumPoints(frame),frame) = received_power(:,1:UE_NumPoints(frame))./(Noise_power + int_power(:,1:UE_NumPoints(frame)));
    
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %*******RATE CALCULATIONS FROM MASSIVE MIMO***************

MC_DF = (MC_M +1 - MC_S)/MC_S; %DF is the dimension factor in the rate calculation
SC_DF = (SC_M +1 - SC_S)/SC_S;

num_symbols = 1;

% IMPORTNAT NOTE:The rate calculation is done wrt MC_S and SC_S values. I
% am not checking whether in the corresponding frame we have enough users
% to satisfy MC_S or SC_S.

%schedulable_rates_matrix = num_symbols*log2(1 + repmat(pathloss_SINR,[1 1 length(set_of_s)]).*dimension_factor);
%
schedulable_rates_matrix = zeros(size(DistanceM));
schedulable_rates_matrix = num_symbols*log2(1+SC_DF*pathloss_SINR);
schedulable_rates_matrix(1,:,:) = num_symbols*log2(1+MC_DF*pathloss_SINR(1,:,:));