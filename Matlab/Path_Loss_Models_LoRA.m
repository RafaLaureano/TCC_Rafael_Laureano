% Comparison of Path Loss Models for LoRA 
clear;
close all;

% LoRA frequency in MHz
frequency = 433; 

% Define lambda
c = 299792.458
lambda = c/frequency

d = (0:1:100)

data_RSSI = readtable('cenario 2.csv');

% Calculates means 
d_RSSI = [1 2 4 6 8 10 12 14 16 18 20 30 40 50 60 70 80 90 100]
RSSI_mean = zeros(1,length(d_RSSI));
% LOG = zeros(1,length(d_RSSI));
for i = 1:length(d_RSSI)
    RSSI_mean(i) = mean(data_RSSI{:,i},'omitnan');
end
scatter(d_RSSI,RSSI_mean);
legend('RSSI');

% Free-space path loss
pl_free_space = -(20*log10(frequency)+20*log10(d/1000)+32.45); 

% Regression coefficient
n = 2.3;
B = 128; 
pl_regression_coefficient = - (B + 10*n*log10(d/1000));

% Regression coefficient (fitting)
% n = 2;
% B = 2; 
% pl_regression_coefficient_fitting = fitlm(d_RSSI,LOG)

% Okumura-Hata 
h_send = 0.077;
h_node = 0.069;
a = 3.2*(log10(11.75*h_node)^2)-4.97;
pl_okumura_hata = -(69.55 + 26.16*log10(frequency)-13.82*log10(h_send)-a+(44.9-6.55*log10(h_send))*log10(d/1000));


% % 2-ray (region 2)
% up = 3*3*(lambda)^2
% down = (4*pi*d).^2
% pl_2_ray = up./down


% figure; 
plot(d,pl_free_space,d,pl_regression_coefficient,d,pl_okumura_hata);
% plot(d,pl_free_space,d,pl_regression_coefficient,d,pl_okumura_hata,d,pl_2_ray);

hold;







