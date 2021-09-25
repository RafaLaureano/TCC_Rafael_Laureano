% Comparison of Path Loss Models for LoRA 
clear;
close all;

% LoRA frequency in MHz
frequency = 433; 

% Define wave length
c = 299792.458;
lambda = c/frequency;

% Set antena height in meters
h_sender = 0.077;
h_receiver = 0.069;


% Read datatable
data_RSSI = readtable('cenario 2.csv');

% Set vector of distances
distance = [1 2 4 6 8 10 12 14 16 18 20 30 40 50 60 70 80 90 100];

% Calculates means 
RSSI_mean = zeros(1,length(distance));
for i = 1:length(distance)
    RSSI_mean(i) = mean(data_RSSI{:,i},'omitnan');
end
scatter(distance,RSSI_mean);
legend('RSSI');

% Free-space path loss
PL_FREE = -(20*log10(frequency)+20*log10(distance/1000)+32.45); 

% Regression coefficient with work related values
n_RC = 2.3;
B_RC = 128;
PL_REG_COEF = - (B_RC + 10*n_RC*log10(distance/1000));

% Regression coefficient (fitting)
f = fitlm(10*log10(distance),RSSI_mean);
n_Fitting = f.Coefficients{2,1};
b_Fitting = f.Coefficients{1,1};
PL_FITTING = b_Fitting + 10*n_Fitting*log10(distance);

% Okumura-Hata in sub-urban region
a = 3.2*(log10(11.75*h_receiver)^2)-4.97;
LU = -(69.55 + 26.16*log10(frequency)-13.82*log10(h_sender)-a+(44.9-6.55*log10(h_sender))*log10(distance/1000));
PL_OKUMURA_SUB_URBAN = LU - 2*(log10(frequency))^2 - 5.4


% 2-ray (region 2)




% PLOT CURVES
scatter(distance,RSSI_mean);
legend('Measured');
hold on;
plot(distance,PL_FREE,distance,PL_REG_COEF,distance,LU,distance,PL_FITTING);
legend('Measured','Free Space','Regression Coefficient','Okumura-Hata','Linear Regression');



% calc accuracy

% Creating vectors
dif_free = zeros(1,length(distance));
dif_rc = zeros(1,length(distance));
dif_fitting = zeros(1,length(distance));
% dif_2r = zeros(1,length(d_RSSI));
dif_ok = zeros(1,length(distance));


%measuring distance between measured values and calculated 
for i=1:length(distance)
    dif_free(i) = sqrt((RSSI_mean(i) - PL_FREE(i))^2);
    dif_rc(i) = sqrt((RSSI_mean(i) - PL_REG_COEF(i))^2);
    dif_fitting(i) = sqrt((RSSI_mean(i) - PL_FITTING(i))^2);
%     dif_2r(i) = sqrt((RSSI_mean(i) - pl_2_ray(i))^2);
    dif_ok(i) = sqrt((RSSI_mean(i) - LU(i))^2);
end


%Getting Standard Deviation
acc_free = std(dif_free);
acc_rc = std(dif_rc);
acc_fitting = std(dif_fitting);
% acc_2r = std(dif_2r);
acc_ok = std(dif_ok);


%Making accuracy vector 
acc = [acc_free acc_rc acc_fitting acc_ok];
hold;

%Plot bar graph with accuracy vector
x = categorical({'Free Space','Regression Coefficient','Linear Regression','Okumura-Hata'});
b = bar(x,acc,'FaceColor','flat');

xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

b.CData(1,:) = [0 0 1];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0 1 1];
b.CData(4,:) = [1 0 0];
