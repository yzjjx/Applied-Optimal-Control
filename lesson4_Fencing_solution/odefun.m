function [dx] = odefun(t,x,w)
% 给当前时间，当前状态和决策向量

m =1;
Tf = w(end);
N = numel(w)-1;
t_list = linspace(0,Tf,N);
u_list = w(1:end-1);
u = interp1(t_list,u_list,t);

dx = [x(2);(1/m)*u];