%% Documentation
% Numerical Validation of robust controller for machine tool Application
% Contributors: 190011138, 190011137, 190011136, 180011251
% Supervisor: Dr. Madihah binti Haji Maharof
% Date: February 26, 2024
% Version: 1.0

% Commands:
%   1. ltview (change settings in LT toolbox)
% Recommendation:
%   1. require GM > 2 dB, PM > 30 deg (p45)
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

s = tf('s');
V_est = 100*s/(s+100);
V_series = series(sys,V_est);

% SISO tool initialization Velocity loop
% sisotool(V_series);

% velocity openloop
pathVelocity = 'E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\Cascade design.mat';
load(pathVelocity);
designsVelocity = ControlSystemDesignerSession.DesignerData;

PI = tf(designsVelocity.Designs(1).Data.C);
numerator_PI = PI.Numerator;
denominator_PI = PI.Denominator;
gains_PI = PI.Numerator{1};

disp(PI);

% PI transfer function
PI_TF = tf(numerator_PI, denominator_PI);

% velocity open and closed loop
V_OP = PI_TF*V_series;
V_CL = feedback(V_OP, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots
close all

hfig = figure;
margin(V_OP);

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
% print(hfig,'margin','-dpdf','-painters','-fillpage')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hfig = figure;
nyquist(V_OP);
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
% print(hfig,'margin','-dpdf','-painters','-fillpage')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hfig = figure;
Spid = 1 / (1 + V_OP);
bodemag(Spid);
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
% print(hfig,'margin','-dpdf','-painters','-fillpage')

%% Position loop

% position open loop
P_series = (PI_TF*sys)/(1+PI_TF*sys*V_est);

%siso tool init
sisotool(P_series);


% velocity openloop
pathPosition = 'E:\[003] Undergrad\7TH SEMESTER\Bachelor Thesis\Controller_Design\[02] Matlab\Cascade design position loop.mat';
load(pathPosition);
designsPosition = ControlSystemDesignerSession.DesignerData;

P = tf(designsPosition.Designs(1).Data.C);
numerator_P = P.Numerator;
denominator_P = P.Denominator;
gains_P = PI.Numerator{1};

disp(P);

% PI transfer function
PI_TF = tf(numerator_P, denominator_P);

% velocity open and closed loop
P_OP = PI_TF*V_series;
P_CL = feedback(V_OP, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots
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
% print(hfig,'margin','-dpdf','-painters','-fillpage')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
% print(hfig,'margin','-dpdf','-painters','-fillpage')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hfig = figure;
Spid = 1 / (1 + P_OP);
bodemag(Spid);
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
% print(hfig,'margin','-dpdf','-painters','-fillpage')


