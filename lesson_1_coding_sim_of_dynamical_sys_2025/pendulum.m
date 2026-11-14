clc;
clear;
close all;

% 定义变量
m = 1;
g = 9.81;
L = 1;

dt = 0.001;
time_final = 10;

time_vector = (0:dt:time_final)';
% 需要向量存储theta和dtheta
theta_vector = zeros(size(time_vector));
dtheta_vector = zeros(size(time_vector));

% 初始条件
theta_vector(1) = pi/4;
dtheta_vector(1) = 0;

% Euler Sim Loop
for iter = 1:numel(time_vector)-1
    ddtheta = -g/L * sin(theta_vector(iter));
    theta_vector(iter+1) = theta_vector(iter) + dtheta_vector(iter)*dt;
    dtheta_vector(iter+1) = dtheta_vector(iter) + ddtheta*dt;
end

% theta and time
h = plot(time_vector,theta_vector,'k-');
xlabel('Time(s)');
ylabel('Thtea(rad)');
title('Pendulum sim');