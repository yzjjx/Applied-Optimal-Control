% 模拟并且施加一个力矩
clc;clear;close all;

m = 1;
g = 9.81;
L = 1;

dt = 0.001;
time_final = 10;

time_vector = (0:dt:time_final)';
theta_vector = zeros(size(time_vector));
dtheta_vector = zeros(size(time_vector));

% 定义增益
Kp = 10;% 比例增益
Kd = 1;% 微分增益

% 期望位置和期望速度
theta_des = pi;
dtheta_des = 0;

% 将初始角度设置为0，然后给一个外部力矩
theta_vector(1) = 0;
dtheta_vector(1) = 0;

for iter = 1:numel(time_vector)-1
    % PD控制器
    tau = Kp*(theta_des-theta_vector(iter)) + Kd*(dtheta_des - dtheta_vector(iter));
    ddtheta = -g/L*sin(theta_vector(iter)) + tau/(m*L^2);

    theta_vector(iter+1) = theta_vector(iter) + dtheta_vector(iter)*dt;
    dtheta_vector(iter+1) = dtheta_vector(iter) + ddtheta*dt;
end


%% 绘图
figure(1)
plot(time_vector,theta_vector,'k.')
xlabel ('Time(s)');
ylabel ('Angle(rad)');
hold on;

FPS = 20;
time_anim = 0:1/FPS:time_vector(end);
theta_anim = interp1(time_vector,theta_vector,time_anim);

figure(2)
for iter = 1:numel(time_anim)
    x_points = [0 L*sin(theta_anim(iter))];
    y_points = [0 -L*cos(theta_anim(iter))];
    plot(x_points,y_points,'k-','LineWidth',2)
    axis([-2 2 -2 2])
    drawnow;
end