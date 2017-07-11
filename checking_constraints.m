%PLOTTING RESULTS

clear all
close all
rand('seed',42); % meaning of life = 42


% This is the code to setup a simple layout for ITA 2014 load balancing
% simulations.

%In this code, we consider a square single macro cell with wrap around
%assumption.

% two-tiers
% single macro cell simulated with the only macro BS located in the center
% of the cell
% wrap around
% square region
% Tier 2 is the small cell BSs, they are located according to PPP. Density
% will be a parameter
% Users will be also located according to PPP, with another denstity
% parameter
% Tier distributions are independent
%

% each frame corresponds to a new sample path for PPPs. ie. at each frame
% the number of points is chosen according to the Poisson distribution with
% parameter density*area, and then that many users are uniformly
% distributed in the area.

cell_type = 'square9'
% Define the area
if(strcmp(cell_type,'square'))
    cell_side = 900 %in meters
elseif(strcmp(cell_type,'square9'))
    cell_side = 900 %in meters
    MC_square_number = 1+1*sqrt(-1);
    hotspot_density_multiplier = 10;
else
    missing_cell_type;
end

SC_relative_density = 20;% relative density wrt Macro (which is 1)
UE_relative_density = 2000;% relative density wrt Macro (which is 1) % ralted to the toal number of  users
% in Square scenario these many users will be uniformly distributed
% but in square9 scenario, hotspot_density_multiplier = h

% h/(9+h-1) of them will be uniformly distributed in the center small
% square.





%---------------------
% subgradient search parameters
a = 1;
b = 0;
imax = 10000;
%----------------------
delta = 0.01; %for reduced LP

%---------------

NumFrames = 100; % A frame corresponds to one layout.

MC_powerdBm = 46 %dBm
SC_powerdBm = 35 %dBm
Noise_powerdBm = -104 %dBM

MC_M = 100;
SC_M = 40;

MC_S = 10;
SC_S = 4;

PathlossModel = 'Simple'

if(strcmp(PathlossModel,'Caramannis'))
    MC_A = 34;
    MC_B = 40;
    SC_A = 37;
    SC_B = 30;
    shad_var = 8;%log normal shadowing deviation
    
    pm1 = MC_A;
    pm2 = MC_B;
    pm3 = SC_A;
    pm4 = SC_B;
    pm5 = shad_var;
elseif(strcmp(PathlossModel,'WINNER'))
    how_to_differentiate_tiers;
    
    pm1 = [];
    pm2 = [];
    pm3 = [];
    pm4 = [];
    pm5 = [];
elseif(strcmp(PathlossModel,'Simple'))
    MC_alpha = 3.5;
    MC_delta = 40;
    SC_alpha = 4;
    SC_delta = 40;
    
    pm1 = MC_alpha;
    pm2 = MC_delta;
    pm3 = SC_alpha;
    pm4 = SC_delta;
    pm5 = [];
else
    missing_pathloss_model;
end



% ------------------- COMMON PARAMETERS FOR VARIOUS FIGURES


threshold = 0.0001

alpha = 4;
filename = sprintf('alpha%d_celltype_%s_cellside%d_MCs%d+i%d_h%d_SC%d_UE%d_NF%d_MCP%d_SCP%d_NP%d_MCM%d_MCS%d_SCM%d_SCS%d_PLmodel_%s_pm1_%dpm2_%dpm3_%dpm4_%dpm5_%d_subgradient_a%d_b%d_imax%d_delta%d.mat',alpha,cell_type,cell_side,real(MC_square_number),imag(MC_square_number),hotspot_density_multiplier,SC_relative_density,UE_relative_density,NumFrames,MC_powerdBm,SC_powerdBm,Noise_powerdBm,MC_M,MC_S,SC_M,SC_S,PathlossModel,pm1,pm2,pm3,pm4,pm5,a,b,imax,delta);
load(filename)


for frame = 1:NumFrames
    activity = squeeze(activity_rand(1:(SC_NumPoints(frame)+1),1:UE_NumPoints(frame),frame));
    
    valid(frame)= activity_constraints(activity,max_users_served+0.0001);
    sum(valid)
end


