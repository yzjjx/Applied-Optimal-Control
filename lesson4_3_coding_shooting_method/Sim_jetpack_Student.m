clc;clear;close all;

tspan = [0 10];
x0 = 0;
dx0 = 1;
y0 = 0;
dy0 = 1;

z0 = [x0;dx0;y0;dy0];

% 使用ODE45仿真
[tout,zout] = ode45(@jetpackDynamics,tspan,z0);

% 绘图
xout = zout(:,1);
yout = zout(:,3);
plot(xout,yout,'k-','LineWidth',2)
axis equal