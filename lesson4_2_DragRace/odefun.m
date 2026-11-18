function [dx] = odefun(t,x,w)
% 给当前时间，当前状态和决策向量
% 这个是给初始状态，初始状态是指系统的状态空间；初始猜测是为了优化
% 需要写出状态空间方程才能进行ODE

m = 1;
Tf = w(end);
N = numel(w)-1;

t_list = linspace(0,Tf,N);
u_list = w(1:end-1);
u = interp1(t_list,u_list,t);

dx = [x(2);(1/m)*u];