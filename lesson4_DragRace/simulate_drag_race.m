function [sf,dsf] = simulate_drag_race(w)

Tf = w(end);
tspan = [0 Tf];
x0 = [0;0];

% 劫持函数，变成两个变量
ode2 = @(t,x) odefun(t,x,w);

[tout,xout] = ode45(ode2,tspan,x0);

sf = xout(end,1);
dsf = xout(end,2);


N = numel(w)-1;
force_vector = w(1:N);
time_points = linspace(0,w(end),N);

% 每次优化都会运行仿真，用来查看约束是否有效
% plot the control input
figure(1)
plot(time_points,force_vector,'k-x','LineWidth',3)
xlabel('Time(s)')
ylabel('Force(N)')
axis([0 1 -10 10])
drawnow
% plot(tout,xout(:,1),'k-')
% xlabel('Time(s)')
% ylabel('Car pos(m)')