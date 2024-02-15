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
inputt = 'R(s)';
output = 'Y(s)';
sys = tf(numerator, denominator, 'InputName', inputt, ...
                                 'OutputName', output, 'InputDelay', time_delay);
sys_no_delay = tf(numerator, denominator, 'InputName', inputt, ...
                                 'OutputName', output);
                             
% Display the transfer function with time delay
disp('Transfer Function:');
disp(sys);

% SISO tool initialization PID
% sisotool(sys);
% pidtool(sys)

%% Export from Design to TF
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

% Disturbance
subplot(2, 2, 1);
plot(out.PID.time, out.PID.signals(1).values);
title('PID Disturbance');

% Error
subplot(2, 2, 2);
plot(out.PID.time, out.PID.signals(2).values);
title('PID Error');

% Reference
subplot(2, 2, 3);
plot(out.PID.time, out.PID.signals(3).values);
title('PID Reference');

% Ouput
subplot(2, 2, 4);
plot(out.PID.time, out.PID.signals(4).values);
title('PID Ouput');