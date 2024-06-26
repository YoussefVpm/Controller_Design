%% Documentation
% Numerical Validation of robust controller for machine tool Application
% Contributors: 190011138, 190011137, 190011136, 180011251
% Supervisor: Dr. Madihah binti Haji Maharof
% Created Date: April 18, 2024
% Version: 2.0

% Commands:
%% Transfer Function

close all; clc; clear;

% SISO tool
% Constants of Transfer Function
A = 78020;
B = 163;
C = 193.3;
Td = 0.0012;

% load cutting force data
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cutting forces\Cut1500down.csv')
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cutting forces\Cut2500down.csv')
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cutting forces\Cut3500down.csv')

% Define a transfer function with time delay
numerator = A;             
denominator = [1, B, C];      % 1, B, C respectively
time_delay = Td;               % Time delay in seconds

% Create the transfer function with time delay
inputt = 'R(s)';
output = 'Y(s)';
sys = tf(numerator, denominator, 'InputDelay', time_delay);
sys_no_delay = tf(numerator, denominator, 'InputName', inputt, ...
                                 'OutputName', output);
                             
% Display the transfer function with time delay
disp('Transfer Function:');
disp(sys);

%% Gains
% Classical SMC
k = 0.01;
lamda = 600;
% ST-SMC
lamdast = 850;

%% Data Plots
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\SMC out with.mat')
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\SMC out without.mat')

%________Maximum Tracking Error_________%

save = 'yes';
% classical SMC
xData = SMC_out_with.SMC_out.time;
yData = SMC_out_with.SMC_out.signals(1).values;
xLabel = 'Time (s)';
yLabel = 'Position Error Classical SMC (mm)';
title = 'Tracking Error of Classical SMC';
plotmte(xData, yData, xLabel, yLabel, title, 'CSMC error with', save);

% Simoid SMC
yData = SMC_out_with.SMC_out.signals(2).values;
xLabel = 'Time (s)';
yLabel = 'Position Error Sigmoid SMC (mm)';
title = 'Tracking Error of Sigmoid SMC';
plotmte(xData, yData, xLabel, yLabel, title, 'SSMC error with', save);

% ST SMC
yData = SMC_out_with.SMC_out.signals(3).values;
xLabel = 'Time (s)';
yLabel = 'Position Error ST-SMC (mm)';
title = 'Tracking Error of ST-SMC';
plotmte(xData, yData, xLabel, yLabel, title, 'STSMC error with', save);

% Bar chart
figure
names = categorical({'Classical SMC','Sigmoid SMC','ST-SMC'});
RMSE_values = [0.0069986 0.001654 0.0054748];
bar(names,RMSE_values, 0.5, 'FaceColor', "#4DBEEE")
ylim([0 0.008]);

ylabel('Position Error MTE (mm)');

%% MTE without
% classical SMC
xData = SMC_out_without.SMC_out.time;
yData = SMC_out_without.SMC_out.signals(1).values;
xLabel = 'Time (s)';
yLabel = 'Position Error Classical SMC (mm)';
title = 'Tracking Error of Classical SMC';
plotmte(xData, yData, xLabel, yLabel, title, 'CSMC error without', save);

% Simoid SMC
yData = SMC_out_without.SMC_out.signals(2).values;
xLabel = 'Time (s)';
yLabel = 'Position Error Sigmoid SMC (mm)';
title = 'Tracking Error of Sigmoid SMC';
plotmte(xData, yData, xLabel, yLabel, title, 'SSMC error without', save);

% ST SMC
yData = SMC_out_without.SMC_out.signals(3).values;
xLabel = 'Time (s)';
yLabel = 'Position Error ST-SMC (mm)';
title = 'Tracking Error of ST-SMC';
plotmte(xData, yData, xLabel, yLabel, title, 'STSMC error without', save);

%% _ROOT MEAN SQAURE ERROR_%
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\SMC out with.mat')
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\SMC out without.mat')

RMSE_C_SMC = sqrt(mean(SMC_out_with.SMC_out.signals(1).values.^2));
RMSE_S_SMC = sqrt(mean(SMC_out_with.SMC_out.signals(2).values.^2));
RMSE_ST_SMC = sqrt(mean(SMC_out_with.SMC_out.signals(3).values.^2));

% Bar chart
names = categorical({'Classical SMC','Sigmoid SMC','ST-SMC'});
RMSE_values = [RMSE_C_SMC RMSE_S_SMC RMSE_ST_SMC];
bar(names,RMSE_values, 0.5, 'FaceColor', "#4DBEEE")
ylim([0 0.006]);
grid on

ylabel('Position Error RMSE (mm)');
disp(RMSE_C_SMC)
disp(RMSE_S_SMC)
disp(RMSE_ST_SMC)

%% RMSE Without

RMSE_C_SMC = sqrt(mean(SMC_out_without.SMC_out.signals(1).values.^2));
RMSE_S_SMC = sqrt(mean(SMC_out_without.SMC_out.signals(2).values.^2));
RMSE_ST_SMC = sqrt(mean(SMC_out_without.SMC_out.signals(3).values.^2));

% Bar chart
names = categorical({'Classical SMC','Sigmoid SMC','ST-SMC'});
RMSE_values = [RMSE_C_SMC RMSE_S_SMC RMSE_ST_SMC];
bar(names,RMSE_values, 0.5, 'FaceColor', "#4DBEEE")
ylim([0 0.006]);
grid on

ylabel('Position Error RMSE (mm)');
disp(RMSE_C_SMC)
disp(RMSE_S_SMC)
disp(RMSE_ST_SMC)


%% _Fast Fourier Transform_%

signal = SMC_out_with.SMC_out.signals(1).values;
plotTitle = 'FFT Tracking Error Classical SMC';
yLabel = 'Position Error With Disturbance (mm)';
plotfft(signal, plotTitle, yLabel);

signal = SMC_out_with.SMC_out.signals(2).values;
plotTitle = 'FFT Tracking Error Sigmoid-SMC';
yLabel = 'Position Error With Disturbance (mm)';
plotfft(signal, plotTitle, yLabel);

signal = SMC_out_with.SMC_out.signals(3).values;
plotTitle = 'FFT Tracking Error ST-SMC';
yLabel = 'Position Error With Disturbance (mm)';
plotfft(signal, plotTitle, yLabel);

% % plot FFT disturbance 1500
% signal = SMC_out.SMC_out.signals(3).values;
% plotTitle = 'FFT Disturbance';
% yLabel = 'Position Error of Disturbance';
% plotfft(signal, plotTitle, yLabel);

%% line graph

% Define the data points
points = [0.001, 0.03, 0.888]; % y-values
labels = {'A', 'B', 'C'}; % Corresponding labels

% Generate x-values (assuming they are equally spaced for simplicity)
x = 1:length(points);

% Create the plot
figure; % Create a new figure window
plot(x, points, 'b-o', 'LineWidth', 2, 'MarkerSize', 10); % Plot the data with a blue line and circle markers

% Add titles and labels
title('Line Graph of Given Points');
xlabel('Index');
ylabel('Value');

% Add text labels to the points
for i = 1:length(points)
    text(x(i), points(i), labels{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 12);
end

% Add grid lines
grid on;

% Display the plot
shg; % Show graph window