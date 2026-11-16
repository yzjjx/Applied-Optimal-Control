clc;clear;close all;

% Paramaters
m = 1000;
M = 5.97*10^24;
G = 6.67*10^-11;
I = 1;
params = struct;
params.m = m;
params.M = M;
params.G = G;
params.I = I;

R = 6.4*10^6;

% 使用ODE45进行仿真
dynamics = @(t,z) spaceshipcontrol(t,z,params);
z0 = [2*R;0;0;1e3;0;0.002];
tspan = [0 1e4];
[tout,zout] = ode45(dynamics,tspan,z0);

plot(zout(:,1),zout(:,3),'k-');
axis equal

% 动画
time_anim = linspace(0,tout(end),100);
x_anim = interp1(tout,zout(:,1),time_anim);
y_anim = interp1(tout,zout(:,3),time_anim);
theta_anim = interp1(tout,zout(:,chao5),time_anim);

figure(2)

x_points_ship = [1 -1 -0.5 -1]*R/5;
y_points_ship = [0 0.5 0 -0.5]*R/5;

x_points_earth = R*cos(linspace(0,2*pi,100));
y_points_earth = R*sin(linspace(0,2*pi,100));

for iter = 1:numel(time_anim)
    theta = theta_anim(iter);
    rotmat = [cos(theta) -sin(theta);sin(theta) cos(theta)];
    rotated_points = rotmat*[x_points_ship;y_points_ship];
    cla
    hold on

    fill(x_points_earth,y_points_earth,'b')  
    
    plot(x_anim(1:iter),y_anim(1:iter),'k-','LineWidth',2)
    % 绘制
    fill(rotated_points(1,:)+x_anim(iter),rotated_points(2,:)+y_anim(iter),'r')    
    axis equal
    axis([-3*R 5*R -3*R 3*R])
    drawnow
end