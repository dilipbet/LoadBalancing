function[pathloss] = winner(helper_user_distance)
d = helper_user_distance;
f = 38*10^9;
% LOS
shad_var = 9.4;
alpha = 2.21;
dd = d;
PL_los = 20*log10((4*pi*5*f)/(3*10^8)) + 10*alpha*log10(dd/5) + lognrnd(0,shad_var);

%NLOS
alpha_nlos = 3.18;
shad_var_nlos = 11;
PL_nlos = 20*log10((4*pi*5*f)/(3*10^8)) + 10*alpha_nlos*log10(dd/5) + lognrnd(0,shad_var_nlos);

los_prob = zeros(size(d));
lessthan = (d <= 2.5);
morethan = (d > 2.5);
los_prob(lessthan) = 1;
los_prob(morethan) = 1 - 0.9*((1 - (1.24 - 0.6*log10(d(morethan))).^3).^(1/3));
max(max(los_prob))

N = ones(size(d));
los_components = binornd(N,los_prob);
%pathloss_dB((los_components==1)) = PL_los((los_components==1));
%pathloss_dB((los_components==0)) = PL_nlos((los_components==0));
pathloss_dB = PL_nlos;
pathloss= 10.^(-0.1*pathloss_dB);
%pathloss(d > 80) = 0;

