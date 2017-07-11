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

FLEG=14;  % legend font
LWD =2;   % linewidth
MSZ =7;   % markersize
FXYL =15; % XY label font
FTIT =16; % Title Font
FAXS =12; % Title Font

scrsz = get(0,'ScreenSize');



frame_by_frame = 0;

if(frame_by_frame == 0)
    % In this one, we can plot the CDF's for
    % utility
    % 5 percentile rates
    % geometric mean
    % average rate
    
    % utility comparisons--------------------------------
    figure(1)
    
    alpha = 1;
    filename = sprintf('alpha%d_celltype_%s_cellside%d_MCs%d+i%d_h%d_SC%d_UE%d_NF%d_MCP%d_SCP%d_NP%d_MCM%d_MCS%d_SCM%d_SCS%d_PLmodel_%s_pm1_%dpm2_%dpm3_%dpm4_%dpm5_%d_subgradient_a%d_b%d_imax%d_delta%d.mat',alpha,cell_type,cell_side,real(MC_square_number),imag(MC_square_number),hotspot_density_multiplier,SC_relative_density,UE_relative_density,NumFrames,MC_powerdBm,SC_powerdBm,Noise_powerdBm,MC_M,MC_S,SC_M,SC_S,PathlossModel,pm1,pm2,pm3,pm4,pm5,a,b,imax,delta);
    load(filename)
    %load('gamma4newfulldata.mat')
    h = plot(sort(utility_dual),(1:NumFrames)/NumFrames,'c--');
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none')
    hold on
    h = plot(sort(utility_cvx),(1:NumFrames)/NumFrames,'r');
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none')
    hold on
    h = plot(sort(utility_dual_huniq),(1:NumFrames)/NumFrames,'b-o');
    set(h,'LineWidth',1,'MarkerSize',4,'MarkerFaceColor','none')
    hold on
    h = plot(sort(utility_rand),(1:NumFrames)/NumFrames,'g--');
    set(h,'LineWidth',1,'MarkerSize',4,'MarkerFaceColor','none')
    hold on
    h = plot(sort(utility_maxRB),(1:NumFrames)/NumFrames,'k+-');
    set(h,'LineWidth',1,'MarkerSize',4,'MarkerFaceColor','none')
    
    set_plot_specs
    grid on
    ylabel('Fraction of realizations with network utility < x')
    xlabel('x')
    title(sprintf('Utility gamma'))
    legend('Centralized-subgradient/dual objective','Centralized-CVX','Centralized-subgradient/primal objective','Distributed',' Max peak rate w/ Biasing ')
    %fig_title = sprintf('Utility gamma = %d', alpha)
    %print('-depsc',fig_title);
    
    figure(2)
    %average user rate comparisons-----------------------------------------------------------------------------
    
    
    %filename = sprintf('alpha%d_celltype_%s_cellside%d_MCs%d+i%d_h%d_SC%d_UE%d_NF%d_MCP%d_SCP%d_NP%d_MCM%d_MCS%d_SCM%d_SCS%d_PLmodel_%s_pm1_%dpm2_%dpm3_%dpm4_%dpm5_%d_subgradient_a%d_b%d_imax%d_delta%d.mat',alpha,cell_type,cell_side,real(MC_square_number),imag(MC_square_number),hotspot_density_multiplier,SC_relative_density,UE_relative_density,NumFrames,MC_powerdBm,SC_powerdBm,Noise_powerdBm,MC_M,MC_S,SC_M,SC_S,PathlossModel,pm1,pm2,pm3,pm4,pm5,a,b,imax,delta);
    %load(filename)
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'mean');
    h = plot(x,(1:NumFrames)/NumFrames,'r');
    hold on
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_dual_huniq,UE_NumPoints,NumFrames,'mean');
    h = plot(x,(1:NumFrames)/NumFrames,'b-o');
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_rand,UE_NumPoints,NumFrames,'mean');
    h = plot(x,(1:NumFrames)/NumFrames,'g--');
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_maxRB,UE_NumPoints,NumFrames,'mean');
    h = plot(x,(1:NumFrames)/NumFrames,'k+-');
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none');
    %
    set_plot_specs
    grid on
    ylabel('Frac. of realizations with arith. mean of user throughputs < x')
    xlabel('x')
    title(sprintf('Arithmetic Mean'))
    legend('Centralized-CVX','Centralized-subgradient','Distributed',' Max peak rate w/ Biasing ')
    %fig_title = sprintf('Arithmetic Mean gamma = %d', alpha)
    %print('-depsc',fig_title);
    
    figure(3)
    %
    %geometric mean user rate comparisons-----------------------------------------------------------------------------
    
    
    
    %filename = sprintf('alpha%d_celltype_%s_cellside%d_MCs%d+i%d_h%d_SC%d_UE%d_NF%d_MCP%d_SCP%d_NP%d_MCM%d_MCS%d_SCM%d_SCS%d_PLmodel_%s_pm1_%dpm2_%dpm3_%dpm4_%dpm5_%d_subgradient_a%d_b%d_imax%d_delta%d.mat',alpha,cell_type,cell_side,real(MC_square_number),imag(MC_square_number),hotspot_density_multiplier,SC_relative_density,UE_relative_density,NumFrames,MC_powerdBm,SC_powerdBm,Noise_powerdBm,MC_M,MC_S,SC_M,SC_S,PathlossModel,pm1,pm2,pm3,pm4,pm5,a,b,imax,delta);
    %load(filename)
    %load('gamma4newfulldata.mat')
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'geomean');
    h = plot(x,(1:NumFrames)/NumFrames,'r');
    hold on
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_dual_huniq,UE_NumPoints,NumFrames,'geomean');
    h = plot(x,(1:NumFrames)/NumFrames,'b-o');
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_rand,UE_NumPoints,NumFrames,'geomean');
    h = plot(x,(1:NumFrames)/NumFrames,'g--');
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_maxRB,UE_NumPoints,NumFrames,'geomean');
    h = plot(x,(1:NumFrames)/NumFrames,'k+-');
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none');
    %
    set_plot_specs
    grid on
    ylabel('Frac. of realizations with geo. mean of user throughputs < x')
    xlabel('x')
    title(sprintf('Geometric Mean'))
    legend('Centralized-CVX','Centralized-subgradient','Distributed',' Max peak rate w/ Biasing ')
    %fig_title = sprintf('Geometric Mean gamma = %d', alpha)
    %print('-depsc',fig_title);
    
    figure(4)
    %5 percentile user rate comparisons-----------------------------------------------------------------------------
    
    
    
    %filename = sprintf('alpha%d_celltype_%s_cellside%d_MCs%d+i%d_h%d_SC%d_UE%d_NF%d_MCP%d_SCP%d_NP%d_MCM%d_MCS%d_SCM%d_SCS%d_PLmodel_%s_pm1_%dpm2_%dpm3_%dpm4_%dpm5_%d_subgradient_a%d_b%d_imax%d_delta%d.mat',alpha,cell_type,cell_side,real(MC_square_number),imag(MC_square_number),hotspot_density_multiplier,SC_relative_density,UE_relative_density,NumFrames,MC_powerdBm,SC_powerdBm,Noise_powerdBm,MC_M,MC_S,SC_M,SC_S,PathlossModel,pm1,pm2,pm3,pm4,pm5,a,b,imax,delta);
    %load(filename)
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'fivep');
    h = plot(x,(1:NumFrames)/NumFrames,'r');
    hold on
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_dual_huniq,UE_NumPoints,NumFrames,'fivep');
    h = plot(x,(1:NumFrames)/NumFrames,'b-o');
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_rand,UE_NumPoints,NumFrames,'fivep');
    h = plot(x,(1:NumFrames)/NumFrames,'g--');
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_maxRB,UE_NumPoints,NumFrames,'fivep');
    h = plot(x,(1:NumFrames)/NumFrames,'k+-');
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none');
    %
    
    set_plot_specs
    grid on
    ylabel('Frac. of realizations with 5 percentile throughput < x')
    xlabel('x')
    title(sprintf('5 percentile'))
    legend('Centralized-CVX','Centralized-subgradient','Distributed',' Max peak rate w/ Biasing ')
    %fig_title = sprintf('5% percentile gamma = %d', alpha)
    %print('-depsc',fig_title);
    
    %-----
    
    % FIGURES FOR THE PAPER
    
    figure(5)
    alpha = 1;
    %filename = sprintf('alpha%d_celltype_%s_cellside%d_MCs%d+i%d_h%d_SC%d_UE%d_NF%d_MCP%d_SCP%d_NP%d_MCM%d_MCS%d_SCM%d_SCS%d_PLmodel_%s_pm1_%dpm2_%dpm3_%dpm4_%dpm5_%d_subgradient_a%d_b%d_imax%d_delta%d.mat',alpha,cell_type,cell_side,real(MC_square_number),imag(MC_square_number),hotspot_density_multiplier,SC_relative_density,UE_relative_density,NumFrames,MC_powerdBm,SC_powerdBm,Noise_powerdBm,MC_M,MC_S,SC_M,SC_S,PathlossModel,pm1,pm2,pm3,pm4,pm5,a,b,imax,delta);
    %load(filename)
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'fivep');
    h = plot(x,(1:NumFrames)/NumFrames,'r-');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    hold on
    [x] = necessary_rate_function(rates_maxRB,UE_NumPoints,NumFrames,'fivep');
    h = plot(x,(1:NumFrames)/NumFrames,'k-');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'geomean');
    h = plot(x,(1:NumFrames)/NumFrames,'r--');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_maxRB,UE_NumPoints,NumFrames,'geomean');
    h = plot(x,(1:NumFrames)/NumFrames,'k--');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'mean');
    h = plot(x,(1:NumFrames)/NumFrames,'r:');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_maxRB,UE_NumPoints,NumFrames,'mean');
    h = plot(x,(1:NumFrames)/NumFrames,'k:');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    %
    set_plot_specs
    grid on 
    ylabel('CDF')
    xlabel('throughput')
    %title(sprintf('Arithmetic Mean gamma = %d', alpha))
    legend('5-percentile user throughput with Centralized Alg.','5-percentile user throughput with Max peak rate w/ Biasing','Geo. Mean of user throughputs with Centralized Alg.','Geo. Mean of user rates with Max peak rate w/ Biasing','Arith. Mean of user throughputs with Centralized Alg.','Arith. Mean of user throughputs with Max peak rate w/ Biasing')
    fig_title = sprintf('journal-gamma = %d', alpha)
    print('-depsc',fig_title);
    
    %---------
    
    figure(6)
    alpha = 4;
    %filename = sprintf('alpha%d_celltype_%s_cellside%d_MCs%d+i%d_h%d_SC%d_UE%d_NF%d_MCP%d_SCP%d_NP%d_MCM%d_MCS%d_SCM%d_SCS%d_PLmodel_%s_pm1_%dpm2_%dpm3_%dpm4_%dpm5_%d_subgradient_a%d_b%d_imax%d_delta%d.mat',alpha,cell_type,cell_side,real(MC_square_number),imag(MC_square_number),hotspot_density_multiplier,SC_relative_density,UE_relative_density,NumFrames,MC_powerdBm,SC_powerdBm,Noise_powerdBm,MC_M,MC_S,SC_M,SC_S,PathlossModel,pm1,pm2,pm3,pm4,pm5,a,b,imax,delta);
    load('gamma4newfulldata.mat')
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'fivep');
    h = plot(x,(1:NumFrames)/NumFrames,'r');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    hold on
    [x] = necessary_rate_function(rates_rand,UE_NumPoints,NumFrames,'fivep');
    h = plot(x,(1:NumFrames)/NumFrames,'b');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_maxRB,UE_NumPoints,NumFrames,'fivep');
    h = plot(x,(1:NumFrames)/NumFrames,'k');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'geomean');
    h = plot(x,(1:NumFrames)/NumFrames,'r--');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_rand,UE_NumPoints,NumFrames,'geomean');
    h = plot(x,(1:NumFrames)/NumFrames,'b--');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_maxRB,UE_NumPoints,NumFrames,'geomean');
    h = plot(x,(1:NumFrames)/NumFrames,'k--');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'mean');
    h = plot(x,(1:NumFrames)/NumFrames,'r:');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_rand,UE_NumPoints,NumFrames,'mean');
    h = plot(x,(1:NumFrames)/NumFrames,'b:');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_maxRB,UE_NumPoints,NumFrames,'mean');
    h = plot(x,(1:NumFrames)/NumFrames,'k:');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    %
    set_plot_specs
    grid on
    ylabel('CDF')
    xlabel('throughput')
    %title(sprintf('Arithmetic Mean gamma = %d', alpha))
    legend('Centralized 5 percentile','Distributed 5 percentile','Max peak rate w/ Biasing 5 percentile','Centralized Geo. Mean','Distributed Geo. Mean','Max peak rate w/ Biasing Geo. Mean','Centralized Arith. Mean','Distributed Arith. Mean','Max peak rate w/ Biasing Arith. Mean')
    %fig_title = sprintf('journal-gamma = %d', alpha)
    %print('-depsc',fig_title);
    
    %---------
    %clear all
    figure(7)
    alpha = 1;
    a=1;
    filename = sprintf('alpha%d_celltype_%s_cellside%d_MCs%d+i%d_h%d_SC%d_UE%d_NF%d_MCP%d_SCP%d_NP%d_MCM%d_MCS%d_SCM%d_SCS%d_PLmodel_%s_pm1_%dpm2_%dpm3_%dpm4_%dpm5_%d_subgradient_a%d_b%d_imax%d_delta%d.mat',alpha,cell_type,cell_side,real(MC_square_number),imag(MC_square_number),hotspot_density_multiplier,SC_relative_density,UE_relative_density,NumFrames,MC_powerdBm,SC_powerdBm,Noise_powerdBm,MC_M,MC_S,SC_M,SC_S,PathlossModel,pm1,pm2,pm3,pm4,pm5,a,b,imax,delta);
    load(filename)
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'fivep');
    h = plot(x,(1:NumFrames)/NumFrames,'r');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    hold on
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'geomean');
    h = plot(x,(1:NumFrames)/NumFrames,'r--');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'mean');
    h = plot(x,(1:NumFrames)/NumFrames,'r:');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    
    alpha = 4;
    %filename = sprintf('alpha%d_celltype_%s_cellside%d_MCs%d+i%d_h%d_SC%d_UE%d_NF%d_MCP%d_SCP%d_NP%d_MCM%d_MCS%d_SCM%d_SCS%d_PLmodel_%s_pm1_%dpm2_%dpm3_%dpm4_%dpm5_%d_subgradient_a%d_b%d_imax%d_delta%d.mat',alpha,cell_type,cell_side,real(MC_square_number),imag(MC_square_number),hotspot_density_multiplier,SC_relative_density,UE_relative_density,NumFrames,MC_powerdBm,SC_powerdBm,Noise_powerdBm,MC_M,MC_S,SC_M,SC_S,PathlossModel,pm1,pm2,pm3,pm4,pm5,a,b,imax,delta);
    %load(filename)
    load('gamma4newfulldata.mat')
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'fivep');
    h = plot(x,(1:NumFrames)/NumFrames,'b');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'geomean');
    h = plot(x,(1:NumFrames)/NumFrames,'b--');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    [x] = necessary_rate_function(rates_cvx,UE_NumPoints,NumFrames,'mean');
    h = plot(x,(1:NumFrames)/NumFrames,'b:');
    set(h,'LineWidth',3,'MarkerSize',2,'MarkerFaceColor','none');
    
    %
    set_plot_specs
    grid on
    ylabel('CDF')
    xlabel('throughput')
    %title(sprintf('Arithmetic Mean gamma = %d', alpha))
    legend('Centralized 5 percentile, \gamma = 1','Centralized Geo. Mean, \gamma = 1','Centralized Arith. Mean, \gamma = 1','Centralized 5 percentile, \gamma = 4','Centralized Geo. Mean, \gamma = 4','Centralized Arith. Mean, \gamma = 4')
        legend('5-percentile user throughput with Centralized Alg., \gamma = 1','Geo. Mean of user rates with Centralized Alg., \gamma = 1','Arith. Mean of user rates with Centralized Alg., \gamma = 1','5-percentile user rates with Centralized Alg., \gamma = 4','Geo. Mean of user rates with Centralized Alg., \gamma = 4','Arith. Mean of user rates with Centralized Alg., \gamma = 4')

    fig_title = sprintf('journal-centralized')
    print('-depsc',fig_title);
    
    
    
else
    % single frame plots
    
    
    alpha = 1 % as in alpha fairness
    filename = sprintf('alpha%d_celltype_%s_cellside%d_MCs%d+i%d_h%d_SC%d_UE%d_NF%d_MCP%d_SCP%d_NP%d_MCM%d_MCS%d_SCM%d_SCS%d_PLmodel_%s_pm1_%dpm2_%dpm3_%dpm4_%dpm5_%d_subgradient_a%d_b%d_imax%d_delta%d.mat',alpha,cell_type,cell_side,real(MC_square_number),imag(MC_square_number),hotspot_density_multiplier,SC_relative_density,UE_relative_density,NumFrames,MC_powerdBm,SC_powerdBm,Noise_powerdBm,MC_M,MC_S,SC_M,SC_S,PathlossModel,pm1,pm2,pm3,pm4,pm5,a,b,imax,delta);
    load(filename)
    %load('gamma4newfulldata.mat')
    
    frame = 1
    
    % gather data-----------------------------------------------
    activity_frame = activity_cvx(1:(SC_NumPoints(frame)+1),1:UE_NumPoints(frame),frame);
    [X,Y,frac_users,max_edges,Int_MC_users,Int_SC_users,BS_edge_num_cvx] = getXY(activity_frame, threshold,BS_Locs, UE_Locs, frame,UE_NumPoints(frame));
    Num_frac_users_cvx = length(frac_users);
    max_edges_cvx = max_edges;
    Int_MC_users_cvx = Int_MC_users;
    Int_SC_users_cvx = Int_SC_users;
    frac_users_to_plot_cvx = frac_users;
    
    activity_frame = activity_maxRB(1:(SC_NumPoints(frame)+1),1:UE_NumPoints(frame),frame);
    [X,Y,frac_users,max_edges,Int_MC_users,Int_SC_users,BS_edge_num_maxRB] = getXY(activity_frame, threshold,BS_Locs, UE_Locs, frame,UE_NumPoints(frame));
    Num_frac_users_maxRB = length(frac_users)
    max_edges_maxRB = max_edges;
    Int_MC_users_maxRB = Int_MC_users;
    Int_SC_users_maxRB = Int_SC_users;
    
    
    % Subset of users to be plotted 10 % of the users
    random_users = randi([1 UE_NumPoints(frame)],UE_NumPoints(frame)/5,1);
    
    % ------------- FIGURE 1 : Layout with all of the users
    
    all_users = 1:UE_NumPoints(frame);% randi([1 UE_NumPoints(frame)],UE_NumPoints(frame)/10,1)
    
    %random_users = all_users;
    
    figure('Position',[1 scrsz(4) scrsz(4) scrsz(4)])
    set(gca,'XLim',[0 cell_side])
    set(gca,'YLim',[0 cell_side])
    grid(gca)
    activity_frame = activity_cvx(1:(SC_NumPoints(frame)+1),1:UE_NumPoints(frame),frame);
    [X,Y] = getXY(activity_frame, threshold,BS_Locs, UE_Locs(:,1:UE_NumPoints(frame)), frame,length(random_users));
    %line(X,Y)
    hold on
    plot(real(MC_location),imag(MC_location),'ks','MarkerSize',20,'LineWidth',2)
    plot(real(SC_Locs(frame,1:SC_NumPoints(frame))),imag(SC_Locs(frame,1:SC_NumPoints(frame))),'bo','MarkerSize',10,'LineWidth',2);
    plot(real(UE_Locs(frame,1:UE_NumPoints(frame))),imag(UE_Locs(frame,1:UE_NumPoints(frame))),'r*');
    %title(sprintf('Fractional Assocation'))
    xlabel('meters')
    ylabel('meters')
    set_plot_specs
    fig_title = 'Layout'
    print('-depsc',fig_title);
    
    
    
    % ------------- FIGURE 2 : Association accroding to CVX
    
    
    figure('Position',[1 scrsz(4) scrsz(4) scrsz(4)])
    set(gca,'XLim',[0 cell_side])
    set(gca,'YLim',[0 cell_side])
    grid(gca)
    activity_frame = activity_cvx(1:(SC_NumPoints(frame)+1),random_users,frame);
    [X,Y] = getXY(activity_frame, threshold,BS_Locs, UE_Locs(:,random_users), frame,length(random_users));
    line(X,Y)
    hold on
    plot(real(MC_location),imag(MC_location),'ks','MarkerSize',20,'LineWidth',2)
    plot(real(SC_Locs(frame,1:SC_NumPoints(frame))),imag(SC_Locs(frame,1:SC_NumPoints(frame))),'bo','MarkerSize',10,'LineWidth',2);
    plot(real(UE_Locs(frame,random_users)),imag(UE_Locs(frame,random_users)),'r*');
    %title(sprintf('Fractional Assocation'))
    xlabel('meters')
    ylabel('meters')
    set_plot_specs
    fig_title = 'CVX-based-Association'
    print('-depsc',fig_title);
    
     % ------------- FIGURE 3 : Association accroding to RAND
    
    
    figure('Position',[1 scrsz(4) scrsz(4) scrsz(4)])
    set(gca,'XLim',[0 cell_side])
    set(gca,'YLim',[0 cell_side])
    grid(gca)
    activity_frame = activity_cvx(1:(SC_NumPoints(frame)+1),random_users,frame);
    [X,Y] = getXY(activity_frame, threshold,BS_Locs, UE_Locs(:,random_users), frame,length(random_users));
    line(X,Y)
    hold on
    plot(real(MC_location),imag(MC_location),'ks','MarkerSize',20,'LineWidth',2)
    plot(real(SC_Locs(frame,1:SC_NumPoints(frame))),imag(SC_Locs(frame,1:SC_NumPoints(frame))),'bo','MarkerSize',10,'LineWidth',2);
    plot(real(UE_Locs(frame,random_users)),imag(UE_Locs(frame,random_users)),'r*');
    %title(sprintf('Fractional Assocation'))
    xlabel('meters')
    ylabel('meters')
    set_plot_specs
    %fig_title = 'RAND-based-Association'
    %print('-depsc',fig_title);
    
    
    
    % ------------- FIGURE 4 : Association accroding to maxRB
    
    
    
    figure('Position',[1 scrsz(4) scrsz(4) scrsz(4)])
    
    set(gca,'XLim',[0 cell_side])
    set(gca,'YLim',[0 cell_side])
    grid(gca)
    %title(sprintf('MaxRB - Num. of SCs: %d  Num. of UEs: %d ',SC_NumPoints(frame),UE_NumPoints(frame)))
    activity_frame = activity_maxRB(1:(SC_NumPoints(frame)+1),random_users,frame);
    [X,Y] = getXY(activity_frame, threshold,BS_Locs, UE_Locs(:,random_users), frame,length(random_users));
    line(X,Y)
    hold on
    plot(real(MC_location),imag(MC_location),'ks','MarkerSize',20,'LineWidth',2)
    plot(real(SC_Locs(frame,1:SC_NumPoints(frame))),imag(SC_Locs(frame,1:SC_NumPoints(frame))),'bo','MarkerSize',10,'LineWidth',2);
    plot(real(UE_Locs(frame,random_users)),imag(UE_Locs(frame,random_users)),'r*');
    %title(sprintf('Max Rate based association with biasing'))
    xlabel('meters')
    ylabel('meters')
    set_plot_specs
    fig_title = 'Max peak rate w Biasing'
    print('-depsc',fig_title);
    
    
    % ------------- FIGURE 5: Only Fractional Associations
    
    figure('Position',[1 scrsz(4) scrsz(4) scrsz(4)])
    
    
    set(gca,'XLim',[0 cell_side])
    set(gca,'YLim',[0 cell_side])
    grid(gca)
    activity_frame = activity_cvx(1:(SC_NumPoints(frame)+1),frac_users_to_plot_cvx,frame);
    [X,Y] = getXY(activity_frame, threshold,BS_Locs, UE_Locs(:,frac_users_to_plot_cvx), frame,length(random_users));
    line(X,Y)
    hold on
    plot(real(MC_location),imag(MC_location),'ks','MarkerSize',20,'LineWidth',2)
    plot(real(SC_Locs(frame,1:SC_NumPoints(frame))),imag(SC_Locs(frame,1:SC_NumPoints(frame))),'bo','MarkerSize',10,'LineWidth',2);
    plot(real(UE_Locs(frame,random_users)),imag(UE_Locs(frame,random_users)),'r*');
    plot(real(UE_Locs(frame,frac_users_to_plot_cvx)),imag(UE_Locs(frame,frac_users_to_plot_cvx)),'r^','MarkerSize',10,'LineWidth',2);
    
    %title(sprintf('Fractional Association: Only users with fractional associations'))
    xlabel('meters')
    ylabel('meters')
    set_plot_specs
    fig_title = 'Fractional-Association-Only-users-with-fractional-associations'
    print('-depsc',fig_title);
    
    
    % ------------- FIGURE 6:  PLOTTING USER ASSOC DISTRIBUTION
    
    figure('Position',[1 scrsz(4) scrsz(4) scrsz(4)])
    
    MM = [Int_MC_users_cvx Int_SC_users_cvx Num_frac_users_cvx;
        Int_MC_users_maxRB Int_SC_users_maxRB Num_frac_users_maxRB;
        ] ;
    bar(MM)
    colormap summer
    set(gca,'YLim',[0 2000])
    set(gca,'XTickLabel',[ 'Centralized Alg. ';'MAX-RATE w/ Bias.'])
    
    
    legend('Num. of Users uniquely assoc. to Macro BS','Num. of Users uniquely assoc. to a single small cell BS','Num. of Users with fract. assoc.','Location','North')
    set_plot_specs
    fig_title = 'UserAssociationDistribution';
    print('-depsc',fig_title);
    %%%%%%%%%%%%%%%%%
    
    
    
    
    
    % ------------- FIGURE 7: Ratio of average edge user
    % rates
    
    
    figure('Position',[1 scrsz(4) scrsz(4) scrsz(4)])
    
    Rates_cvx = getRates(rates_cvx(frame,1:UE_NumPoints(frame)));
    Rates_maxRB = getRates(rates_maxRB(frame,1:UE_NumPoints(frame)));
    
    
    
    h = plot(100*(1:length(Rates_cvx))/length(Rates_cvx),cumsum(sort(Rates_cvx))./cumsum(sort(Rates_maxRB)),'r--');
    set(h,'LineWidth',3,'MarkerSize',4,'MarkerFaceColor','none')
    hold on
    
    grid on
    ylabel('Ratio of avearage user rates')
    xlabel('User Percentile')
    legend('Max peak rate w/ Biasing','Load Based Association')
    
    
    set_plot_specs
    
    fig_title = 'Ratio-of-user-rates'
    print('-depsc',fig_title);
    
    
    
    
    % ------------- FIGURE 8:
    figure('Position',[1 scrsz(4) scrsz(4) scrsz(4)])
    
    MM = [sort(BS_edge_num_cvx,'descend');
        sort(BS_edge_num_maxRB,'descend');
        ] ;
    
    subplot(2,1,1)
    bar(MM(1,1))
    colormap(summer)
    hold on
    bar([0 MM(1,2:size(MM,2))],'g');
    
    set(gca,'YLim',[0 800])
    set(gca,'XTickLabel',[])
    ylabel('Num. of users associated')
    xlabel('BSs sorted according to load')
    grid on
    legend('# users associated with Macro BS - Centralized Alg.','# users associated with each small Cell BS - Centralized Alg.','Location','North')
    set_plot_specs
    
    subplot(2,1,2)
    bar(MM(2,1))
    colormap(summer)
    hold on
    bar([0 MM(2,2:size(MM,2))],'g');
    
    set(gca,'YLim',[0 800])
    set(gca,'XTickLabel',[])
    ylabel('Num. of users associated')
    xlabel('BSs sorted according to load')
    grid on
    legend('# users associated with Macro BS - Max peak rate w/ Bias.','# users associated with each small Cell BS - Max peak rate w/ Bias.','Location','North')
    
    set_plot_specs
    fig_title = 'Style2_UserAssociationDistribution_per_BS';
    print('-depsc',fig_title);
    
end
