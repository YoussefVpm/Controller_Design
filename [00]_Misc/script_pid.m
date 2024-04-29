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
% Design 1  % Design 2  % Ziegler_NicholsFrequencyResponse  % Design 4
close all;

path = 'E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\PID design.mat';
load(path);
designs = ControlSystemDesignerSession.DesignerData;

for i = 1:3
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
    bodemag(1 / (1 + sys_CL),'g.-');
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

close all;

path = 'E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\PID design.mat';
load(path);
designs = ControlSystemDesignerSession.DesignerData;

for i = 1:3
    pid = tf(designs.Designs(i).Data.C);
    numerator_pid = pid.Numerator;
    denominator_pid = pid.Denominator;
    gains = pid.Numerator{1};
    
    pid_tf = tf(numerator_pid, denominator_pid);

    % closed & open loop TF
    sys_OP = series(pid_tf,sys);
    sys_CL = feedback(sys_OP, 1);

    hfig = figure;
    step(sys_CL);
    axis([0 0.12 0 1.7]);
    grid on
    xlabel('Time');
    ylabel('Amplitude, Y(t) (mm)');
    title(['Unit Step Response of Design ' num2str(i)]);
    legend(['Design ' num2str(i)]);
    
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
    print(hfig,[num2str(i) ' Step response'],'-dpdf','-painters','-fillpage')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hfig = figure;
    margin(sys_OP);

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
    print(hfig,[num2str(i) ' margin'],'-dpdf','-painters','-fillpage')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
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
    print(hfig,[num2str(i) ' nyquist'],'-dpdf','-painters','-fillpage')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    hfig = figure;
    bode(sys_CL);

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
    print(hfig,[num2str(i) ' Bode closed loop'],'-dpdf','-painters','-fillpage')

end

%% Sensitivity 

hfig = figure;
Error = 1*5/(1+pid_tf*sys);
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

xData = out_with.PID.time;
yData = out_with.PID.signals(2).values;
xLabel = 'Time (s)';
yLabel = 'Position Error With Disturbance (mm)';
titleText = 'PID Tracking Error';
plotmte(xData, yData, xLabel, yLabel, titleText, 'error with', 'no');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xData = out_without.PID.time;
yData = out_without.PID.signals(2).values;
xLabel = 'Time (s)';
yLabel = 'Position Error Without Disturbance (mm)';
titleText = 'PID Tracking Error';
plotmte(xData, yData, xLabel, yLabel, titleText, 'error without', 'no');

%% _____ROOT MEAN SQAURE ERROR_____
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\PID out with.mat')
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\PID out without.mat')

RMSE_with = sqrt(mean(out_with.PID.signals(2).values.^2));
RMSE_without = sqrt(mean(out_without.PID.signals(2).values.^2));
percentage_variation = ((RMSE_with - RMSE_without)/RMSE_with)*100;

disp(RMSE_with)
disp(RMSE_without)
disp(percentage_variation)

%% _____Fast Fourier Transform_____

signal = out_with.PID.signals(2).values;
plotTitle = 'FFT Tracking Error cascade With Error';
yLabel = 'Position Error With Disturbance (mm)';
plotfft(signal, plotTitle, yLabel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot FFT disturbance 1500
signal = out_with.PID.signals(1).values;
plotTitle = 'FFT Disturbance';
yLabel = 'Position Error of Disturbance';
plotfft(signal, plotTitle, yLabel);

%%
load('E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\cutting forces\Cut1500down.csv')

% Step 1: Load the CSV data into MATLAB
data = Cut1500down(:,2)*(1/ 2871.14); % Replace 'your_data.csv' with the path to your CSV file

% Step 2: Perform FFT on the data
Fs = 2000; % Sampling frequency (you may need to adjust this based on your data)
N = length(data); % Length of the signal
Y = fft(data); % Compute FFT

% Step 3: Plot the FFT
f = Fs*(0:(N/2))/N; % Frequency axis
magnitude = abs(Y(1:N/2+1)); % Compute the magnitude of the FFT
plot(f, magnitude);
title('Single-Sided Amplitude Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

