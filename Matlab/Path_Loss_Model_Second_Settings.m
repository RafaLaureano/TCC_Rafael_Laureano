% Comparison of Path Loss Models for LoRA in second setting
% By Rafael Antonio Laureano de Souza
% Trabalho de conclusão de curso - 30/11/2021
% Prof. Dr. Natassya Barlate Floro da Silva



clear;
close all;

%                           PART 1 - SET UP's                            %
% ---------------------------------------------------------------------- %

% LoRA frequency in MHz
frequency = 433; 

% Calc wave length
c = 299792.458;
lambda = c/frequency;

% Set antena height in meters
h_sender = 0.797;
h_receiver = 0.769;

% Read datatable
data_RSSI = readtable('Cenario 2.csv');

% Set vector of distances
distance = [1 2 4 6 8 10 12 14 16 18 20 30 40 50 60 70 80 90 100];

% Calculates means 
RSSI_mean = zeros(1,length(distance));
for i = 1:length(distance)
    RSSI_mean(i) = mean(data_RSSI{:,i},'omitnan');
end
% ********************************************************************** %




%               PART 2 - TRACING PATH LOSS CURVES                        %
% ---------------------------------------------------------------------- %

% Free-space path loss
PL_FREE = 20-(20*log10(frequency)+20*log10(distance/1000)+32.45); 

% Log-distance with work related values
n_RC = 2.3;
B_RC = 128;
PL_REG_COEF = -(B_RC + 10*n_RC*log10(distance/1000));

% Log-distance (fitting)
f = fitlm(10*log10(distance),RSSI_mean);
n_Fitting = f.Coefficients{2,1};
b_Fitting = f.Coefficients{1,1};
PL_FITTING = b_Fitting + 10*n_Fitting*log10(distance);

% Okumura-Hata in sub-urban region
a = 3.2*(log10(11.75*h_receiver)^2)-4.97;
LU = -(69.55 + 26.16*log10(frequency)-13.82*log10(h_sender)-a+(44.9-6.55*log10(h_sender))*log10(distance/1000));
PL_OKUMURA_SUB_URBAN = LU - 2*(log10(frequency))^2 - 5.4

% 2-ray (region 2)
pl = 1;
PL_2_RAY=zeros(1,length(distance))
dc=4*h_sender*h_receiver/lambda;
for i=1:length(distance)
    if (distance(i)<h_sender)
        PL_2_RAY (i) = 20-log10((((4*pi)^2)*pl*((distance(i))^2 + (h_sender/1000)^2))/(3*3*lambda^2));
    elseif (distance(i)<=dc)
        PL_2_RAY (i) = 20-log10((((4*pi)^2)*pl*((distance(i))^2))/(3*3*lambda^2));
    else
        PL_2_RAY (i) = 20-log10(((distance(i))^4)*pl/(3*3*lambda^2*(h_sender/1000)^2*(h_receiver/1000)^2));
    end
end
% ********************************************************************** %




%                PART 3 - CALC ACCURACY AND ERROR                        %
% ---------------------------------------------------------------------- %    

% Creating error vectors
dif_free = zeros(1,length(distance));
dif_rc = zeros(1,length(distance));
dif_fitting = zeros(1,length(distance));
dif_2r = zeros(1,length(distance));
dif_ok = zeros(1,length(distance));

%measuring distance between measured values and calculated 
for i=1:length(distance)
    dif_free(i) = sqrt((RSSI_mean(i) - PL_FREE(i))^2);
    dif_rc(i) = sqrt((RSSI_mean(i) - PL_REG_COEF(i))^2);
    dif_fitting(i) = sqrt((RSSI_mean(i) - PL_FITTING(i))^2);
    dif_2r(i) = sqrt((RSSI_mean(i) - PL_2_RAY(i))^2);
    dif_ok(i) = sqrt((RSSI_mean(i) - LU(i))^2);
end

%Calc mean error
mean_free = mean(dif_free);
mean_rc = mean(dif_rc);
mean_fitting = mean(dif_fitting);
mean_2r = mean(dif_2r);
mean_ok = mean(dif_ok);
mean = [mean_free mean_rc mean_fitting mean_ok mean_2r];
hold;

%Calc Accuracy
acc_free = std(dif_free);
acc_rc = std(dif_rc);
acc_fitting = std(dif_fitting);
acc_2r = std(dif_2r);
acc_ok = std(dif_ok);
acc = [acc_free acc_rc acc_fitting acc_ok acc_2r];
hold;

%Correcting the curves with the error values
Correct_free = PL_FREE - mean_free;
Correct_rc = PL_REG_COEF - mean_rc;
Correct_fitting = PL_FITTING;
Correct_2r = PL_2_RAY - mean_2r;
Correct_ok = PL_OKUMURA_SUB_URBAN - mean_ok;
Correct = [Correct_free Correct_rc Correct_fitting Correct_ok Correct_2r];
hold;
% ********************************************************************** %




%                           PART 4 - PLOTS GRAPHS                        %
% ---------------------------------------------------------------------- %

%Curves
figure(1);
scatter(distance,RSSI_mean);
legend('Measured');
hold on;
plot(distance,PL_FREE,'g',distance,PL_REG_COEF,'m',distance,LU,'y',distance,PL_2_RAY,'b',distance,PL_FITTING,'r');
legend('Measured','Free Space','Regression Coefficient','Okumura-Hata','2-Ray','Linear Regression');
title('Curves');
ylabel('RSSI');
xlabel('Distance in Meters');

saveas(figure(1),'Curvas_Second_Settings.jpg');

%Accuracy
figure(2);
x = categorical({'Free Space','Regression Coefficient','Linear Regression','Okumura-Hata','2-Ray'});
b = bar(x,acc,'FaceColor','flat');

xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

b.CData(1,:) = [0 0 1];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [1 0 0];
b.CData(4,:) = [1 1 0];
b.CData(5,:) = [1 0 1];

title('Accuracy');
ylabel('Standard deviation');

saveas(figure(2),'Precisão_Second_Settings.jpg');

%error
figure(3);
x = categorical({'Free Space','Regression Coefficient','Linear Regression','Okumura-Hata','2-Ray'});
b = bar(x,mean,'FaceColor','flat');

xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

b.CData(1,:) = [0 0 1];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [1 0 0];
b.CData(4,:) = [1 1 0];
b.CData(5,:) = [1 0 1];

title('Error');
ylabel('Average Differenc');

saveas(figure(3),'Diferença_Media_Second_Settings.jpg');

%Boxplot;
figure(4);
vetor_box_plot = zeros(size(data_RSSI));
for i = 1:size(data_RSSI,2)
    for j = 1:size(data_RSSI,1)
        vetor_box_plot(j,i) = data_RSSI{j,i};
    end
end

bp = boxplot(vetor_box_plot,'Labels',{1,2,4,6,8,10,12,14,16,18,20,30,40,50,60,70,80,90,100});
ylabel('RSSI');
xlabel('Distance in Meters');
title('Boxplot - Second Settings Dates');

saveas(figure(4),'Boxplot_Second_Settings.jpg');

%Corrected curves
figure(5);
scatter(distance,RSSI_mean);
legend('Measured');
hold on;
plot(distance,Correct_free,'g',distance,Correct_rc,'m',distance,Correct_ok,'y',distance,Correct_2r,'b',distance,Correct_fitting,'r');
legend('Measured','Free Space','Regression Coefficient','Okumura-Hata','2-Ray','Linear Regression');
title('Corrected Curves');
ylabel('RSSI');
xlabel('Distance in Meters');

saveas(figure(5),'Corrected_Curvas_Second_Settings.jpg');
% ********************************************************************** %