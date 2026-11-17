clc;clear;close all;

% 第三个初始向量为lambda
wk = [6 6 1];
% 定义步长
alpha = 0.5;

% 阈值
threshold = 1e-2;

% 梯度函数
mygradint = @(H,L,lambda) [-H+2*lambda,-L+2*lambda,2*L+2*H-40];

% 梯度下降循环
for iter = 1:10
    wk = wk-alpha*mygradint(wk(1),wk(2),wk(3))
end
