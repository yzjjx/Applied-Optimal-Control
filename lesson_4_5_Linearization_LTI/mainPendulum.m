clc;clear;close all;

m = 1;
g = 9.8;
L = 1;
tau = 0;

% 将非线性动力学定义为内联方程
odenonlin = @(t,x) [x(2);-g/L*sin(x(1))+tau/(m*L^2)];

tspan = [0 10];

x0 = [pi/4;0];

% 仿真非线性系统
[t_out_nonlin,x_out_nonlin] = ode45(odenonlin,tspan,x0);

plot(t_out_nonlin,x_out_nonlin(:,1),'k-','LineWidth',2);
xlabel('Time(s)')
ylabel('Angle(rads)')

% 定义线性化动力学
A = [0 1; -g/L 0];
B = [0;1/(m*L^2)];

x_star = [0;0];
u_star = 0;
u = tau;
u_tilde = u-u_star;

odelin = @(t,x_tilde) A*x_tilde +B*u_tilde;

x_tilde0 = x0-x_star;

% 对线性动力学公式仿真
[t_out_lin,x_tilde_out_lin] = ode45(odelin,tspan,x_tilde0);

hold on;
theta_out_lin = x_tilde_out_lin(:,1) + x_star(1);
plot(t_out_lin,theta_out_lin,'r--','LineWidth',2);
xlabel('Time(s)')
ylabel('Angle(rads)')
