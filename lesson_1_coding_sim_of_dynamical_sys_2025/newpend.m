clc;clear;close all;

% 定义变量
m = 1;
g = 9.81;
L = 1;

dt = 0.001;
tf = 10;

time_vector = (0:dt:tf)';

% 初始值
x0 = [pi/4;0];

state_output = zeros(numel(time_vector),2);
state_output(1,:) = x0';

% Euler Simluation
for iter = 1:numel(time_vector)-1
    state_output(iter+1,:) = state_output(iter,:) + ...
    ODEfun(time_vector(iter),state_output(iter,:)')'*dt;
end

% ODE45,tout为时间点向量；state_output为状态向量；第一个参数为函数句柄（@），
% 第二个参数为时间范围，第三个参数为初始状态
% 红色曲线为ODE45方法仿真
[tout,xout] = ode45(@ODEfun,[0 tf],x0);

% 绘图
hold on
plot(time_vector,state_output(:,1),'k-');
plot(tout,xout(:,1),'r-');
xlabel('time(s)');
ylabel('angle(rads)');
