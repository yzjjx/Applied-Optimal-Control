% Minimum-time double integrator trajectory optimization
% 最小时间双重积分轨迹规划
clc;clear;close all

% cost fun是决策向量的最后一个
cost = @(w) w(end);

% 优化问题的初始猜测
N = 10;
w0 = [zeros(N,1);1];
fmin = -10;
fmax = 10;
lb = [ones(N,1)*fmin;0];
ub = [ones(N,1)*fmax;Inf];

options = optimoptions("fmincon","Display","iter");
wstar = fmincon(cost,w0,[],[],[],[],lb,ub,@nonlcon_dragrace,options);

% force points
force_vector = wstar(1:N);
time_points = linspace(0,wstar(end),N);
plot(time_points,force_vector,'k-x','LineWidth',3)
xlabel('Time(s)')
ylabel('Force(N)')