% 模拟烤箱的加热过程
clc;
clear;
close all;

% 定义变量
k = 1;% 热交换的常数
Tamb = 25;%Ambient 环境温度
dQ = 1;

% 仿真时间步长
dt = 0.001;

% 定义仿真什么时候结束
% 仿真结束时间
time_final = 10;

% 中间有一万个dt
numrows = time_final/dt+1;

% 创建一个温度向量
time_vector = (0:dt:time_final)';
temp_vector = zeros(numrows,1);

% 每个状态的初始条件
temp_initial = Tamb;

% 将初始条件设置为第一个变量
temp_vector(1) = temp_initial;

%% 仿真
% 欧拉循环
for iter = 1:numel(time_vector)-1
    % dT的方程是ODE
    dtemp = k*(Tamb-temp_vector(iter)) + dQ;
    temp_vector(iter+1) = temp_vector(iter) + dtemp*dt;
end

% 仿真绘图
% 绘制温度
h = plot(time_vector,temp_vector,'k-');
xlabel('Time(s)');
ylabel('Temperature(C)');
title('Temperature over time');

% 可以允许将绘制的内容保存为一个句柄（handle），就是可以获取并且改变它的属性
% h = plot(time_vector,temp_vector,'k-');