function [sf,dsf] = simulate_multi(w,x0,tspan)
% 除了发送决策向量之外，还要发送时间跨度
% tspan = [0 Tf]，这个就是整个轨迹进行一次射击，现在要改成在一定时间范围内多次射击
% 并且需要初始状态
% 返回每段射击状态的最终s的最终ds

Tf = w(end);

% 劫持函数，变成两个变量
ode2 = @(t,x) odefun_multi(t,x,w);

% 龙格库塔积分，ode2向ode45返回dx
[tout,xout] = ode45(ode2,tspan,x0);

% 返回最终位置和最终速度
sf = xout(end,1);
dsf = xout(end,2);

N = (numel(w)-1)/3;
force_vector = w(1:N);
time_points = linspace(0,w(end),N);

% plot the control input
% figure(1)
% plot(time_points,force_vector,'k-x','LineWidth',3)
% xlabel('Time(s)')
% ylabel('Force(N)')
% axis([0 1 -10 10])
% drawnow
% % plot(tout,xout(:,1),'k-')
% xlabel('Time(s)')
% ylabel('Car pos(m)')