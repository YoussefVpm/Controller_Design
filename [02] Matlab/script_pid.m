%% Documentation
% Numerical Validation of robust controller for machine tool Application
% Contributors: 190011138, 190011137, 190011136, 180011251
% Supervisor: Dr. Madihah binti Haji Maharof
% Date: February 15, 2024
% Version: 1.0

% Commands:
%   1. ltview (change settings in LT toolbox)

% Recommendation:
%   1. require GM > 2 dB, PM > 30 deg (p45)

% Selected data:
%   PID design 1: 01
%   PID design 2: 01, 02, 03*, 04
%   PID design 3: 02*, 03*
%   Best Four: 1-01, 2-01, 2-02, 2-04 
%% Transfer Function

close all; clc; clear;

% SISO tool
% Constants of Transfer Function
A = 78020;
B = 163;
C = 193.3;
Td = 0.0012;

% SISO tool initialization
% s = tf('s')
% sisotool((A/s^2+B*s+C)*exp(-s*Td), 1)

% load cutting force data
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cutting forces\Cut1500down.csv')

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

% SISO tool initialization PID
% sisotool(sys);
% pidtool(sys)

%% plots for thesis book

close all;

% load designs
path = 'E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\PID design.mat';
load(path);
designs = ControlSystemDesignerSession.DesignerData;


pid = tf(designs.Designs(1).Data.C);
numerator_pid = pid.Numerator;
denominator_pid = pid.Denominator;
gains = pid.Numerator{1};

pid_tf = tf(numerator_pid, denominator_pid);

% closed & open loop TF
sys_OP = series(pid_tf,sys);
sys_CL = feedback(sys_OP, 1);

% Extract PID gains for simulink
% PID gains
new_kp = gains(2);
new_ki = gains(3);
new_kd = gains(1);

%%

%_____STEP_____

hfig = figure;
step(sys_CL);
axis([0 0.12 0 1.7]);
grid on
xlabel('Time');
ylabel('Amplitude, Y(t) (mm)');
title('Unit Step Response of Design');
legend('Design 2');

step_info = stepinfo(sys_CL);

% Extract required metrics
percentage_overshoot = step_info.Overshoot;
rise_time = step_info.RiseTime;
settling_time = step_info.SettlingTime;
[response, time] = step(sys_CL);
steady_state_error = 1 - response(end);

text(0.04, 0.6, [' Steady state error = ' num2str(steady_state_error) ' mm'], 'Color', '[0 0.4470 0.7410]');
text(0.04, 0.5, [' Rise time = ' num2str(rise_time) ' s'], 'Color', '[0 0.4470 0.7410]');
text(0.04, 0.4, [' Settling time = ' num2str(settling_time) ' s'], 'Color', '[0 0.4470 0.7410]');
text(0.04, 0.3, [' \% OS = ' num2str(percentage_overshoot) ' \%'], 'Color', '[0 0.4470 0.7410]');

h = findall(gcf,'Type','line');

newLinewidth = 2;  % Adjust this value as needed
for j = 1:length(h)
    set(h(j), 'LineWidth', newLinewidth);
end

pictureWidth = 15;
hw_ratio = 0.65;
set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])
print(hfig,'Step response','-dpdf','-painters','-fillpage')

%_____MARGIN_____

hfig = figure;
margin(sys_OP);
grid on

h = findall(gcf,'Type','line');

% Modify the linewidth of the lines
newLinewidth = 2;  % Adjust this value as needed
for j = 1:length(h)
    set(h(j), 'LineWidth', newLinewidth);
end

pictureWidth = 15;
hw_ratio = 0.65;
set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])
print(hfig,'margin','-dpdf','-painters','-fillpage')

%_____NYQUIST_____

hfig = figure;
nyquist(sys_OP);
axis([-1.5 1.5 -1 1]);
grid off

h = findall(gcf,'Type','line');

% Modify the linewidth of the lines
newLinewidth = 1.5;  % Adjust this value as needed
for j = 1:length(h)
    set(h(j), 'LineWidth', newLinewidth);
end

% Plot a circle at (0,0) with radius 1
hold on;
rectangle('Position', [-1, -1, 2, 2], 'Curvature', [1, 1], 'EdgeColor', 'r', 'LineStyle', ':', 'LineWidth', 1);
hold off;

pictureWidth = 15;
hw_ratio = 0.65;
set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])
print(hfig,'nyquist','-dpdf','-painters','-fillpage')

%_____BODE_____

hfig = figure;
bode(sys_CL);
grid on

h = findall(gcf,'Type','line');

% Modify the linewidth of the lines
newLinewidth = 2;  % Adjust this value as needed
for j = 1:length(h)
    set(h(j), 'LineWidth', newLinewidth);
end

pictureWidth = 15;
hw_ratio = 0.65;
set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])
print(hfig,'Bode closed loop','-dpdf','-painters','-fillpage')


%% Sensitivity and Validation 

%_____SENSITIVITY_____
hfig = figure;
Spid = 1 / (1 + sys_OP);
bodemag(Spid);
title('Sensitivity function');
axis([1 2000 -35 10]);
grid on

h = findall(gcf,'Type','line');

% Modify the linewidth of the lines
newLinewidth = 1.5;  % Adjust this value as needed
for i = 1:length(h)
    set(h(i), 'LineWidth', newLinewidth);
end

pictureWidth = 15;
hw_ratio = 0.65;
set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])
% print(hfig,'sensitivity','-dpdf','-painters','-fillpage')

%_____VALIDATION_____

hfig = figure;
Error = 1*5/(1+pid_tf*sys);
bodemag(Error);
title('Controller validation');
grid on

h = findall(gcf,'Type','line');

% Modify the linewidth of the lines
newLinewidth = 1.5;  % Adjust this value as needed
for i = 1:length(h)
    set(h(i), 'LineWidth', newLinewidth);
end

pictureWidth = 15;
hw_ratio = 0.65;
set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])
% print(hfig,'sensitivity','-dpdf','-painters','-fillpage')

%% Data Plotting

close all;

load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\PID out with.mat')
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\PID out without.mat')

% Disturbance
titleText = 'Cutting Force Input Disturbance at 1500 RPM';
plotn(out_with.PID.time, out_with.PID.signals(1).values, titleText)

% Reference
titleText = 'Input Reference';
plotn(out_with.PID.time, out_with.PID.signals(3).values, titleText)

%_____ERROR_____%

%_____Maximum Tracking Error_____%

save = 'yes';
xData = out_with.PID.time;
yData = out_with.PID.signals(2).values;
xLabel = 'Time (s)';
yLabel = 'Position Error With Disturbance (mm)';
titleText = 'PID Tracking Error';
plotmte(xData, yData, xLabel, yLabel, titleText, 'error with', save);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xData = out_without.PID.time;
yData = out_without.PID.signals(2).values;
xLabel = 'Time (s)';
yLabel = 'Position Error Without Disturbance (mm)';
titleText = 'PID Tracking Error';
plotmte(xData, yData, xLabel, yLabel, titleText, 'error without', save);

%% _____ROOT MEAN SQAURE ERROR_____
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\PID out with.mat')
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\PID out without.mat')

RMSE_with = sqrt(mean(out_with.PID.signals(2).values.^2));
RMSE_without = sqrt(mean(out_without.PID.signals(2).values.^2));
percentage_variation = ((RMSE_with - RMSE_without)/RMSE_with)*100;

names = categorical({'with disturbance','without disturbance'});
RMSE_values = [RMSE_with RMSE_without];
bar(names,RMSE_values, 0.5, 'FaceColor', "#4DBEEE")
ylim([0 RMSE_with + 0.001]);
text(names, RMSE_values, num2str(RMSE_values'), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
text(1.5, 0.001, [num2str(percentage_variation), '%'], 'HorizontalAlignment', 'center', 'FontSize', 14);
grid on

%% _____Fast Fourier Transform_____

signal = out_with.PID.signals(2).values;
plotTitle = 'FFT Tracking Error of PID';
yLabel = 'Position Error With Disturbance (mm)';
plotfft(signal, plotTitle, yLabel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot FFT disturbance 1500 rpm
signal = out_with.PID.signals(1).values;
plotTitle = 'FFT of Cutting Disturbance Force at 1500 rpm';
yLabel = 'Position Error of Disturbance';
plotfft(signal, plotTitle, yLabel);

%% disturbance plot

load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cutting forces\Cut1500down.csv')
signal = Cut1500down(:,2)*(1/ 2871.14); % Replace 'your_data.csv' with the path to your CSV file
plotTitle = 'FFT Tracking Error PID With Error';
yLabel = 'Position Error With Disturbance (mm)';
plotfft(signal, plotTitle, yLabel);

