clc;clear;close all

% cost fun
cost  = @(w) -w(1)*w(2);
w0 = [0;0];

A = [];
b = [];
Aeq = [];
beq = [];
lb = [0;0];
ub = [inf;inf];

options = optimoptions("fmincon","Display","iter");

% 使用fmincon解决优化问题
% 最佳决策向量w_star
% 需要函数句柄，也就是如果直接w_star = fmincon(cost,w0,A,b,Aeq,beq,lb,ub,nonlcon_fencing)
% 它会认为是一个变量，必须前面加@表示是一个函数句柄
w_star = fmincon(cost,w0,A,b,Aeq,beq,lb,ub,@nonlcon_fencing,options)