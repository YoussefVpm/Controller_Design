%% Documentation
% Numerical Validation of robust controller for machine tool Application
% Contributors: 190011138, 190011137, 190011136, 180011251
% Supervisor: Dr. Madihah binti Haji Maharof
% Created Date: February 26, 2024
% Version: 2.0

% Commands:
%   1. ltview (change settings in LT toolbox)
% Recommendation:
%   1. require GM > 6 dB, PM > 60 deg (p45)
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

V_est = tf([942.5, 0],[1 942.5]);
V_series = series(sys,V_est);

% SISO tool initialization Velocity loop
% sisotool(V_series);

%% velocity openloop
pathVelocity = 'E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\Cascade design velocity loop.mat';
load(pathVelocity);
designsVelocity = ControlSystemDesignerSession.DesignerData;

PI = tf(designsVelocity.Designs(1).Data.C);
numerator_PI = PI.Numerator;
denominator_PI = PI.Denominator;
gains_PI = PI.Numerator{1};

gain_V_P = gains_PI(1);
gain_V_I = gains_PI(2);

disp(PI);

% PI transfer function
PI_TF = tf(numerator_PI, denominator_PI);

% velocity open and closed loop
V_OP = PI_TF*V_series;
V_CL = feedback(V_OP, 1);

%% Figure for Thesis book: Velocity

%%_____MARGIN_____%%

hfig = figure;
margin(V_OP);

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
% print(hfig,'margin Velo OL','-dpdf','-painters','-fillpage')

%%_____NYQUIST_____%%

hfig = figure;
nyquist(V_OP);
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
% print(hfig,'nyquist Velo OL','-dpdf','-painters','-fillpage')

%%_____BODE CL_____%%

hfig = figure;
bode(V_CL);

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
% print(hfig,'Bode Velo CL','-dpdf','-painters','-fillpage')

%%_____SENSITIVITY_____%%

hfig = figure;
% Error = 1*5/(1+pid_tf*sys);
% bodemag(Error);
Svl = 1 / (1 + V_OP);
bodemag(Svl);
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

%% Position loop

% position open loop
P_series = (PI_TF*sys)/(1+(PI_TF*sys*V_est));

% siso tool init
% sisotool(P_series);

% position openloop
pathPosition = 'E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\Cascade design position loop.mat';
load(pathPosition);
gain_P = ControlSystemDesignerSession.DesignerData.Designs.Data.C.K;

disp(gain_P);

% position open and closed loop
P_OP = gain_P*P_series;
P_CL = feedback(P_OP, 1);

%% Figure for Thesis book: Position

%%_____MARGIN_____%%

close all

hfig = figure;
margin(P_OP);

h = findall(gcf,'Type','line');

% Modify the linewidth of the lines
newLinewidth = 2;  % Adjust this value as needed
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
% print(hfig,'margin Posi OL','-dpdf','-painters','-fillpage')

%%_____NYQUIST_____%%
hfig = figure;
nyquist(P_OP);
axis([-1.5 1.5 -1 1]);
grid off

h = findall(gcf,'Type','line');

% Modify the linewidth of the lines
newLinewidth = 2;  % Adjust this value as needed
for i = 1:length(h)
    set(h(i), 'LineWidth', newLinewidth);
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
% print(hfig,'nyquist Posi OL','-dpdf','-painters','-fillpage')

%%_____BODE CL_____%%

hfig = figure;
bode(P_CL);

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
% print(hfig,'Bode Velo CL','-dpdf','-painters','-fillpage')

%% Sensitivity and Validation

%%_____SENSITIVITY_____

hfig = figure;
Spl = 1 / (1 + P_OP);
bodemag(Spl);
axis([1 3500 -35 10]);
grid on

h = findall(gcf,'Type','line');

% Modify the linewidth of the lines
newLinewidth = 2;  % Adjust this value as needed
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
% print(hfig,'sensitivity Posi OL','-dpdf','-painters','-fillpage')

%%_____Controller Validation_____

hfig = figure;
Error = 5*(1+(PI_TF*sys*V_est))/(1+(PI_TF*sys*V_est)+(gain_P*PI_TF*sys));
bodemag(Error);
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

%% _____DATA PLOTTING_____

close all;

load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cascade out with.mat')
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cascade out without.mat')

% Disturbance
titleText = 'Cutting Force Input Disturbance at 1500 RPM';
plotn(out_with.cascade.time, out_with.cascade.signals(1).values, titleText)

% Reference
titleText = 'Input Reference';
plotn(out_with.cascade.time, out_with.cascade.signals(3).values, titleText)

%_____ERROR_____%

%_____Maximum Tracking Error_____%

xData = out_with.cascade.time;
yData = out_with.cascade.signals(2).values;
xLabel = 'Time (s)';
yLabel = 'Position Error With Disturbance (mm)';
titleText = 'Cascade Tracking Error';
plotmte(xData, yData, xLabel, yLabel, titleText, 'error with', 'no');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xData = out_without.cascade.time;
yData = out_without.cascade.signals(2).values;
xLabel = 'Time (s)';
yLabel = 'Position Error Without Disturbance (mm)';
titleText = 'Cascade Tracking Error';
plotmte(xData, yData, xLabel, yLabel, titleText, 'error without', 'no');

%% _____ROOT MEAN SQAURE ERROR_____
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cascade out with.mat')
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cascade out without.mat')

RMSE_with = sqrt(mean(out_with.cascade.signals(2).values.^2));
RMSE_without = sqrt(mean(out_without.cascade.signals(2).values.^2));
percentage_variation = ((RMSE_with - RMSE_without)/RMSE_with)*100;

names = categorical({'with disturbance','without disturbance'});
RMSE_values = [RMSE_with RMSE_without];
bar(names,RMSE_values, 0.5, 'FaceColor', "#4DBEEE")
ylim([0 RMSE_with + 0.0015]);
text(names, RMSE_values, num2str(RMSE_values'), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
text(1.5, 0.001, [num2str(percentage_variation), '%'], 'HorizontalAlignment', 'center', 'FontSize', 14);
grid on

%% _____FAST FOURIER TRANSFORM_____

signal = out_with.cascade.signals(2).values;
plotTitle = 'FFT Tracking Error cascade With Error';
yLabel = 'Position Error With Disturbance (mm)';
plotfft(signal, plotTitle, yLabel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot FFT disturbance 1500
signal = out_with.cascade.signals(1).values;
plotTitle = 'FFT Disturbance';
yLabel = 'Position Error of Disturbance';
plotfft(signal, plotTitle, yLabel);

%% _____Cascade FFW_____

close all

load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cascade out ffw.mat')

% Error
hfig = figure;
plot(out_ffw.cascase_ffw.time, out_ffw.cascase_ffw.signals(1).values, 'LineWidth', 1);
hold on
plot(out_ffw.cascase_ffw.time, out_ffw.cascase_ffw.signals(2).values, 'LineWidth', 1, 'Color', 'red');
grid on
axis([0 15 -1 1]);
xlabel('Time (s)')
ylabel('Position Error with and without FFW (mm)');
title('Cutting Force Input Disturbance at 1500 RPM');

pictureWidth = 15;
hw_ratio = 0.65;
set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])
print(hfig,'input disturbance','-dpdf','-painters','-fillpage')