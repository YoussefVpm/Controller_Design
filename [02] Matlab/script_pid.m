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

% SISO tool initialization PID
% sisotool(sys);
% pidtool(sys)

%% For iteration procedure
% Design 1
% Design 2 
% Ziegler_NicholsFrequencyResponse
% Design 4

close all;

path = 'E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\PID design.mat';
load(path);
designs = ControlSystemDesignerSession.DesignerData;

for i = 1:4
    pid = tf(designs.Designs(i).Data.C);
    numerator_pid = pid.Numerator;
    denominator_pid = pid.Denominator;
    gains = pid.Numerator{1};
    
    pid_tf = tf(numerator_pid, denominator_pid);

    % closed & open loop TF
    sys_OP = series(pid_tf,sys);
    sys_CL = feedback(sys_OP, 1);
    
    % plot
    figure
    grid on
    subplot(3,1,1);
    step(sys_CL,'.-');
    subplot(3,1,2);
    nyquist(sys_CL,'r-');
    subplot(3,1,3);
    margin(sys_OP)
%     bodemag(1 / (1 + sys_CL),'g.-');
    hold on
    newPosition = [-425+(i/0.99)*450, 50, 450, 900]; % [left, bottom, width, height]
    set(gcf, 'Position', newPosition,'Name','Design');
end


%% Manual Procedure
% load designs
path = 'E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\PID design.mat';
load(path);
designs = ControlSystemDesignerSession.DesignerData;

% select design data
designChoice = input('Enter a Controller choice (1-4): ');

% PID TF
switch designChoice
    case 1
        pid_1 = tf(designs.Designs(1).Data.C);
        numerator_pid = pid_1.Numerator;
        denominator_pid = pid_1.Denominator;
        gains = pid_1.Numerator{1};
    case 2
        pid_2 = tf(designs.Designs(2).Data.C);
        numerator_pid = pid_2.Numerator;
        denominator_pid = pid_2.Denominator;
        gains = pid_2.Numerator{1};
    case 3
        pid_3 = tf(designs.Designs(3).Data.C);
        numerator_pid = pid_3.Numerator;
        denominator_pid = pid_3.Denominator;
        gains = pid_3.Numerator{1};
    case 4
        pid_4 = tf(designs.Designs(4).Data.C);
        numerator_pid = pid_4.Numerator;
        denominator_pid = pid_4.Denominator;
        gains = pid_4.Numerator{1};
    otherwise
        disp('Invalid choice. Please enter a number between 1 and 5!');
end

pid_tf = tf(numerator_pid, denominator_pid);

% closed & open loop TF
sys_OP = series(pid_tf,sys);
sys_CL = feedback(sys_OP, 1);

% Extract PID gains for simulink
% PID gains
new_kp = gains(2);
new_ki = gains(3);
new_kd = gains(1);

%% Responds Analysis
close all;

% Frequency vector for Bode and Nyquist plots
figure;
grid on
newPosition = [300, 100, 1200, 800]; % [left, bottom, width, height]
set(gcf, 'Position', newPosition,'Name','Design');

% Margin plot
subplot(2,2,1);
bode(sys_CL);

% Nyquist plot
subplot(2,2,2);
nyquist(sys_OP);
axis([-1 1 -1 1]);
title('Nyquist Plot');

% sensitivity plot
subplot(2,2,3);
bodemag(1 / (1 + sys_OP));
ax = gca;
ax.XScale = 'log'; % Set x-axis to log scale if desired
grid on;
xlim([0, 10]); % Set x-axis limits
ylim([-5, 3]); % Set y-axis limits
title('sensitivity CL');

% step response
subplot(2,2,4);
step(sys_CL,'.-');
title('Step response');

%% plots for thesis book
close all

hfig = figure;
margin(sys_OP);

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
print(hfig,'margin','-dpdf','-painters','-fillpage')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hfig = figure;
nyquist(sys_OP);
axis([-1.5 1.5 -1 1]);
grid off

h = findall(gcf,'Type','line');

% Modify the linewidth of the lines
newLinewidth = 1.5;  % Adjust this value as needed
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
print(hfig,'nyquist','-dpdf','-painters','-fillpage')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Sensitivity 

hfig = figure;
Spid = 1 / (1 + sys_OP);
bodemag(Spid);
axis([1 3500 -35 10]);
grid off

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

%% Data Plotting

% check: plot TF with and without delay
% bode(sys, 'b', sys_no_delay, 'r');
% legend ('TF', 'TF_no_delay','Location','southwest');

close all;

% addpath('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab')
% out = sim('Googol_XY_machine_test.slx');
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\PID out with.mat')
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\PID out without.mat')

% Disturbance
hfig = figure;
plot(out_with.PID.time, out_with.PID.signals(1).values);
grid on
title('PID Disturbance');

pictureWidth = 15;
hw_ratio = 0.65;
set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])

% Reference
hfig = figure;
plot(out_with.PID.time, out_with.PID.signals(3).values);
grid on
title('PID Reference');

pictureWidth = 15;
hw_ratio = 0.65;
set(findall(hfig, '-property', 'Fontsize'), 'Fontsize', 12)
set(findall(hfig, '-property', 'Box'), 'Box', 'on')
set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(hfig, 'Units', 'Centimeters', 'Position', [3 3 pictureWidth hw_ratio*pictureWidth])
pos = get(hfig, 'Position');
set (hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters','Papersize',[pos(3),pos(4)])

%__________________________________ERROR_________________________________%

% Error
hfig = figure;
plot(out_with.PID.time, out_with.PID.signals(2).values, 'LineWidth', 1);
hold on
grid on
title('PID Error');


xSubset = out_with.PID.time(out_with.PID.time > 0.5);
ySubset = out_with.PID.signals(2).values(out_with.PID.time > 0.5);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hfig = figure;
plot(out_without.PID.time, out_without.PID.signals(2).values, 'LineWidth', 2);
hold on
grid on
title('PID Error');


xSubset = out_without.PID.time(out_without.PID.time > 0.5);
ySubset = out_without.PID.signals(2).values(out_without.PID.time > 0.5);
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

%__________________ROOT MEAN SQAURE ERROR________________________________%

RMSE = sqrt(mean(out_with.PID.signals(2).values.^2));

%__________________Fast Fourier Transform________________________________%


% Example time-domain data
Fs = 500; % Sampling frequency (Hz)
signal = out_with.PID.signals(2).values;

% Perform FFT
N = length(out_with.PID.signals(2).values);
frequencies = Fs*(0:(N/2))/N;
fft_result = fft(out_with.PID.signals(2).values);
amplitude_spectrum = 2/N * abs(fft_result(1:N/2+1));

fft_result_2 = fft(out_without.PID.signals(2).values);
amplitude_spectrum_2 = 2/N * abs(fft_result_2(1:N/2+1));

% Plot the time-domain signal and its frequency spectrum
figure;
plot(frequencies, amplitude_spectrum);
hold on 
plot(frequencies, amplitude_spectrum_2);
title('Frequency Spectrum');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

% Show the plot
grid on;



