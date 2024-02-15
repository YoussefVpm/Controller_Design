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

%% Transfer Function

close all; clc;

% SISO tool
% Constants of Transfer Function
A = 78020;
B = 163;
C = 193.3;
Td = 0.0012;

% SISO tool initialization
% s = tf('s')
% sisotool((A/s^2+B*s+C)*exp(-s*Td), 1)

% Define a transfer function with time delay
numerator = A;             
denominator = [1, B, C];      % 1, B, C respectively
time_delay = Td;               % Time delay in seconds

% Create the transfer function with time delay
input = 'R(s)';
output = 'Y(s)';
sys = tf(numerator, denominator, 'InputName', input, ...
                                 'OutputName', output, 'InputDelay', time_delay);
sys_no_delay = tf(numerator, denominator, 'InputName', input, ...
                                 'OutputName', output);
                             
% Display the transfer function with time delay
disp('Transfer Function:');
disp(sys);

% SISO tool initialization PID
sisotool(sys);
% pidtool(sys)

%% Export from Design to TF
pid_1 = tf(C_Design1);
pid_2 = tf(C_Design2);

% PID TF
numerator_pid = pid_2.Numerator;
denominator_pid = pid_2.Denominator;
pid_tf = tf(numerator_pid, denominator_pid);

% closed & open loop TF
sys_OP = series(pid_tf,sys);
sys_CL = feedback(sys_OP, 1);

% Alternative PID
% kp = 1; ki = 1; kd = 1;
% s = tf('s');
% pid_tf = kp + ki/s + kd*s;

%% Responds Analysis
close all;

% Frequency vector for Bode and Nyquist plots
% Bode plot
figure;
margin(sys_CL);
title('Bode Plot');

% Nyquist plot
figure;
nyquist(sys_CL);
title('Nyquist Plot');

figure;
step(sys_CL);
title('Step response');


%% Extract PID gains for simulink
gains = pid_2.Numerator{1};
% PID gains
new_kp = gains(2);
new_ki = gains(3);
new_kd = gains(1);

% Alternative
% a = 0.014898;
% b = 2.073;
% new_kp = a*b;
% new_ki = a*b^2;
% new_kd = a;

%% Data Plotting

% check: plot TF with and without delay
bode(sys, 'b', sys_no_delay, 'r');
legend ('TF', 'TF_no_delay','Location','southwest');