clc;clear;close all;

N = 7;
w0 = 500*ones(N+1,1);
w0(end) = 20;

% 线性约束都没有
% Linear constraints and bounds
A = [];
b = [];
Aeq=[];
beq = [];
lb = [];
ub = [];
% lb = -inf(size(w0));
% lb(end) = 0;
% ub = inf(size(w0));

% Sets the options of the optimization
% -- we want to display the progress of the optimization
% over each iterations (Display = 'iter')
options = optimoptions('fmincon','Display','iter','MaxFunctionEvaluations',10e3);

% Run our nonlinear programming (NLP) solver (fmincon)
[w_star,fvel,exitflag] = fmincon(@cost_fun,w0,A,b,Aeq,beq,lb,ub,@nonlcon,options);

T = w_star(end);
t_vec = linspace(0,T,N);
F_vec = w_star(1:N);

% 计算最优力矩轨迹
plot(t_vec(1:end),F_vec(1:end),'k-x','LineWidth',2)
title('Optimal force trajectory')
xlabel('time(s)');
ylabel('Froce(N)')

dynamics = @(t,z) jetpackControlDynamics(t,z,w_star);
tspan = [0 T];
z0 = [0;1;0;1];

[t_check,z_check] = ode45(dynamics,tspan,z0);
x_sim = z_check(:,1);
dx_sim = z_check(:,2);
y_sim = z_check(:,3);
dy_sim = z_check(:,4);

figure
plot(x_sim,y_sim,'k-')
xlabel('x pos(m)')
ylabel('y pos(m)')
title('Cartisian Trajectory')
axis equal

figure
subplot(4,1,1)
plot(t_check,x_sim,'k-','LineWidth',2)
xlabel('time(s)')
ylabel('x pos(m)')

subplot(4,1,2)
plot(t_check,dx_sim,'k-','LineWidth',2)
xlabel('time(s)')
ylabel('x v(m/s)')

subplot(4,1,3)
plot(t_check,y_sim,'k-','LineWidth',2)
xlabel('time(s)')
ylabel('y pos(m)')

subplot(4,1,4)
plot(t_check,dy_sim,'k-','LineWidth',2)
xlabel('time(s)')
ylabel('y v(m/s)')

% 制作动画
FPS = 20;
SLOMO = 1/4;
t_anim = 0:1/FPS/SLOMO:T;

x_anim = interp1(t_check,x_sim,t_anim);
y_anim = interp1(t_check,y_sim,t_anim);

% 动画循环
figure
set(gcf,'color',[1,1,1]);
for iter = 1:numel(t_anim)
    cla
    hold on
    plot([-5 25],[0 0],'k-','LineWidth',2)% 地平线
    plot(x_anim(1:iter),y_anim(1:iter),'k-');
    plot(x_anim(iter),y_anim(iter),'rs','MarkerSize',15,'MarkerFaceColor','r')
    axis equal
    axis([-5 25 -5 150])
    drawnow
    pause(1/FPS)
end

