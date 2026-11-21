clc;clear;close all

m = 1;

% Direct collocation parameters
N = 10;
w0 = zeros(3*N+1,1);
w0(end) = 10;

% cost fun
cost = @(w) w(end);

options = optimoptions("fmincon",'Display','iter');
w_out = fmincon(cost,w0,[],[],[],[],[],[],@nonlcon,options);

% 绘图
F_opt = w_out(1:N);
s_opt = w_out(N+1:2*N);
ds_opt = w_out(2*N+1:3*N);
T_opt = w_out(end);
t_plot = linspace(0,T_opt,N);

subplot(3,1,1)
plot(t_plot,s_opt,'k-','LineWidth',2)
xlabel("time(s)")
ylabel("m")
title("POS")

subplot(3,1,2)
plot(t_plot,ds_opt,'k-','LineWidth',2)
xlabel("time(s)")
ylabel("m/s")
title("Velocity")

subplot(3,1,3)
plot(t_plot,F_opt,'k-','LineWidth',2)
xlabel("time(s)")
ylabel("N")
title("Force")