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

%% Plots Analysis
close all

figure
grid on
subplot(5,1,1);
margin(V_OP);
subplot(5,1,2);
nyquist(V_OP,'r-');
subplot(5,1,3);
step(V_CL,'r-');
subplot(5,1,4);
bode(V_CL)
subplot(5,1,5);
bodemag(1 / (1 + V_OP),'g-');
newPosition = [50, 50, 450, 900]; % [left, bottom, width, height]
set(gcf, 'Position', newPosition,'Name','Design');


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

%% Plots Analysis
close all

figure
grid on
subplot(5,1,1);
margin(P_OP);
subplot(5,1,2);
nyquist(P_OP,'r-');
subplot(5,1,3);
step(P_CL,'r-');
subplot(5,1,4);
bode(P_CL)
subplot(5,1,5);
bodemag(1 / (1 + P_OP),'g-');
newPosition = [50, 50, 450, 900]; % [left, bottom, width, height]
set(gcf, 'Position', newPosition,'Name','Design');

%% Figure for Thesis book: Velocity

%%__________MARGIN__________%%

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
print(hfig,'margin Velo OL','-dpdf','-painters','-fillpage')

%%__________NYQUIST__________%%

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
print(hfig,'nyquist Velo OL','-dpdf','-painters','-fillpage')

%%__________BODE CL__________%%

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
print(hfig,'Bode Velo CL','-dpdf','-painters','-fillpage')

%%__________SENSITIVITY__________%%

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

%% Figure for Thesis book: Position

%%__________MARGIN__________%%

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

%%__________NYQUIST__________%%

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

%%__________BODE CL__________%%

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

%%__________SENSITIVITY__________%%

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

%% Error Validation

hfig = figure;
Error = 5*(1+(PI_TF*sys*V_est))/(1+(PI_TF*sys*V_est)+(gain_P*PI_TF*sys));
bodemag(Error);
% Spid = 1 / (1 + sys_OP);
% bodemag(Spid);
% axis([1 2000 -35 10]);
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

%% ______________Data Plotting___________________

% check: plot TF with and without delay
% bode(sys, 'b', sys_no_delay, 'r');
% legend ('TF', 'TF_no_delay','Location','southwest');

close all;

% addpath('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab')
% out = sim('Googol_XY_machine_test.slx');
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cascade out with.mat')
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cascade out without.mat')

% Disturbance
hfig = figure;
plot(out_with.cascade.time, out_with.cascade.signals(1).values, 'LineWidth', 1);
grid on
xlabel('Time (s)')
ylabel('Input disturbance (V)');
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


% Reference
hfig = figure;
plot(out_with.cascade.time, out_with.cascade.signals(3).values, 'LineWidth', 2);
grid on
xlabel('Time (s)');
ylabel('Input Reference (mm)');
title('Input Reference');

pictureWidth = 15;
hw_ratio = 0.65;
set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])
print(hfig,'reference','-dpdf','-painters','-fillpage')


%__________________________________ERROR_________________________________%

%________Maximum Tracking Error_________%

hfig = figure;
plot(out_with.cascade.time, out_with.cascade.signals(2).values, 'LineWidth', 1);
hold on
grid on
xlabel('Time (s)')
ylabel('position Error With Disturbance (mm)')
title('Cascade Tracking Error');

xSubset = out_with.cascade.time(out_with.cascade.time > 0.5);
ySubset = out_with.cascade.signals(2).values(out_with.cascade.time > 0.5);
[maxY, maxIndex] = max(ySubset);
maxX = xSubset(maxIndex);

% Plot a red dot at the maximum point
plot(maxX, maxY, 'ro', 'MarkerSize', 7);

% Trace a horizontal line at the maximum point
plot([0, 15], [maxY, maxY], '--', 'Color', 'red');

% Display the maximum point
text(6, maxY+0.003, [' MTE = ' num2str(maxY) ' mm'], 'Color', 'red');

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
print(hfig,'error with','-dpdf','-painters','-fillpage')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hfig = figure;
plot(out_without.cascade.time, out_without.cascade.signals(2).values, 'LineWidth', 2);
% axis([0 15 -0.005 0.005]);
hold on
grid on
xlabel('Time (s)')
ylabel('position Error Without Disturbance (mm)')
title('Cascade Tracking Error');


xSubset = out_without.cascade.time(out_without.cascade.time > 0.5);
ySubset = out_without.cascade.signals(2).values(out_without.cascade.time > 0.5);
[maxY, maxIndex] = max(ySubset);
maxX = xSubset(maxIndex);

% Plot a red dot at the maximum point
plot(maxX, maxY, 'ro', 'MarkerSize', 7);

% Trace a horizontal line at the maximum point
plot([0, 15], [maxY, maxY], '--', 'Color', 'red');

% Display the maximum point
text(6, maxY+0.003, [' MTE = ' num2str(maxY) ' mm'], 'Color', 'red');

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
print(hfig,'error without','-dpdf','-painters','-fillpage')


%% __________________ROOT MEAN SQAURE ERROR____________________%
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cascade out with.mat')
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cascade out without.mat')

RMSE_with = sqrt(mean(out_with.cascade.signals(2).values.^2));
RMSE_without = sqrt(mean(out_without.cascade.signals(2).values.^2));

percentage_variation = ((RMSE_with - RMSE_without)/RMSE_without)*100;
disp(percentage_variation)

%% _________________Fast Fourier Transform____________________%

% Example time-domain data
Fs = 2000; % Sampling frequency (Hz)
signal = out_with.cascade.signals(2).values;

% Perform FFT
N = length(out_with.cascade.signals(2).values);
frequencies = Fs*(0:(N/2))/N;
fft_result = fft(out_with.cascade.signals(2).values);
amplitude_spectrum = 2/N * abs(fft_result(1:N/2+1));

fft_result_2 = fft(out_without.cascade.signals(2).values);
amplitude_spectrum_2 = 2/N * abs(fft_result_2(1:N/2+1));

% Plot the frequency spectrum
hfig = figure;
plot(frequencies, amplitude_spectrum, 'LineWidth', 2);
axis([0 1000 0 0.08]);
title('FFT Tracking Error cascade Without Error');
xlabel('Frequency (Hz)');
ylabel('Position Error Without Disturbance (mm)');
hold on

[maxY, maxIndex] = max(amplitude_spectrum);
maxX = frequencies(maxIndex);

% Plot a red dot at the maximum point
plot(maxX, maxY, 'ro', 'MarkerSize', 7);

% Display the maximum point
text(maxX+2, maxY, [' Amplitude = ' num2str(maxY) ' mm'], 'Color', 'red');

% Show the plot
grid on;

pictureWidth = 15;
hw_ratio = 0.65;
set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])
print(hfig,'FFT without','-dpdf','-painters','-fillpage')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hfig = figure;
plot(frequencies, amplitude_spectrum_2, 'LineWidth', 2);
axis([0 1000 0 0.08]);
title('FFT Tracking Error cascade With Error');
xlabel('Frequency (Hz)');
ylabel('Position Error With Disturbance (mm)');
hold on

[maxY, maxIndex] = max(amplitude_spectrum_2);
maxX = frequencies(maxIndex);

% Plot a red dot at the maximum point
plot(maxX, maxY, 'ro', 'MarkerSize', 7);

% Display the maximum point
text(maxX+2, maxY, [' Amplitude = ' num2str(maxY) ' mm'], 'Color', 'red');

% Show the plot
grid on;
% Show the plot
grid on;

pictureWidth = 15;
hw_ratio = 0.65;
set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])
print(hfig,'FFT with','-dpdf','-painters','-fillpage')

%% Cascade FFW

close all

load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cascade out ffw.mat')

% Error
hfig = figure;
plot(out_ffw.cascase_ffw.time, out_ffw.cascase_ffw.signals(1).values, 'LineWidth', 1);
hold on
plot(out_ffw.cascase_ffw.time, out_ffw.cascase_ffw.signals(2).values, 'LineWidth', 1, 'Color', 'red');
grid on
axis([0 5 -1 1]);
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