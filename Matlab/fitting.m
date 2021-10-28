% Regression coefficient using linear regression

clear;
close all;

data_RSSI = readtable('Cenario 2.csv');

% Calculates means 
d_RSSI = [1 2 4 6 8 10 12 14 16 18 20 30 40 50 60 70 80 90 100];
RSSI_mean = zeros(1,length(d_RSSI));
% LOG = zeros(1,length(d_RSSI));
for i = 1:length(d_RSSI)
    RSSI_mean(i) = mean(data_RSSI{:,i},'omitnan');
end
figure;
scatter(d_RSSI,RSSI_mean);
legend('RSSI');


f = fitlm (10*log10(d_RSSI),RSSI_mean)
y_linear = f.Coefficients{2,1}*10*log10(d_RSSI)+f.Coefficients{1,1}; 
figure;
plot(10*log10(d_RSSI),RSSI_mean,10*log10(d_RSSI),y_linear);
legend('Measured','Linear Regression');

% Values for Regression Coefficient Model
B = f.Coefficients{1,1};
n = f.Coefficients{2,1};
pl_regression_coefficient = B + 10*n*log10(d_RSSI);

figure;
scatter(d_RSSI,RSSI_mean);
hold;
plot(d_RSSI,pl_regression_coefficient);