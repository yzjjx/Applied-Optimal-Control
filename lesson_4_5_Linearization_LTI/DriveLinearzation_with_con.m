clc;clear;close all;

% 使用符号工具箱推导线性化
x = sym('x',[2 1]);
u = sym('u',[1 1]);

m = 1;
g = 9.8;
L = 1;

% 极点配置
K = [-7.8 3];

f = [x(2);-g/L*sin(x(1))+u(1)/(m*L^2)];

% 线性化
% 第一步：定义固定点
x_star = [0;0];
u_star = [0];

% 第二步：计算矩阵A和B
A = jacobian(f,x);
A = subs(A,x,x_star);
A = subs(A,u,u_star);
A = double(A);

B = jacobian(f,u);
B = subs(B,x,x_star);
B = subs(B,u,u_star);
B = double(B);

% 仿真线性化动力学
u = 0;
u_tilde = u-u_star;

tspan = [0 10];

odelin = @(t,x_tilde) A*x_tilde +B*(-K*x_tilde);

x0 = [pi/4;0];

x_tilde0 = x0-x_star;

% 对线性动力学公式仿真
[t_out_lin,x_tilde_out_lin] = ode45(odelin,tspan,x_tilde0);

hold on;
theta_out_lin = x_tilde_out_lin(:,1) + x_star(1);
plot(t_out_lin,theta_out_lin,'r--','LineWidth',2);
xlabel('Time(s)')
ylabel('Angle(rads)')