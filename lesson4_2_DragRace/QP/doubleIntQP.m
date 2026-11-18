clc;clear;close all;

% 定义参数
m = 1;
dt = 1;
sfinal = 1;% 终点位置
dsfinal = 0;% 终点速度

% 定义符号变量，可以让计算机计算Hession矩阵
syms F1 F2 F3 F4 F5

% 决策向量
w = [F1;F2;F3;F4;F5];

% 代价函数
cost = (F1^2+F2^2+F3^2+F4^2+F5^2)*dt;

% 约束
ds0 = 0;
s0 = 0;

% 前向欧拉
dds0 = F1/m;
s1 = s0+ds0*dt;
ds1 = ds0 + dds0*dt;

dds1 = F2/m;
s2 = s1+ds1*dt;
ds2 = ds1 + dds1*dt;


dds2 = F3/m;
s3 = s2+ds2*dt;
ds3 = ds2 + dds2*dt;


dds3 = F4/m;
s4 = s3+ds3*dt;
ds4 = ds3 + dds3*dt;

dds4 = F5/m;
s5 = s4+ds4*dt;
ds5 = ds4 + dds4*dt;

% 等式约束是s(5)=sfinal，所以等式约束是s(5)-sfinal=0
geq = [s5-sfinal;ds5-dsfinal];

% 计算Hession、梯度和雅可比
H = double(hessian(cost,w));
c = gradient(cost,w);
c = double(subs(c,w,zeros(size(w))));

A = [];
b = [];

Aeq = double(jacobian(geq,w));
beq = double(-subs(geq,w,zeros(size(w))));

w_star = quadprog(H,c,A,b,Aeq,beq)