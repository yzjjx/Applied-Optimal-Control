clc;clear;close all

% Number of spline points
N = 10;

% Cost fun
cost = @(w) w(end);

w0 = 10*ones(3*N+1,1);

fmin = -10;
fmax = 10;
lb = -inf(size(w0));
lb(1:N) = fmin;
ub = inf(size(w0));
ub(1:N) = fmax;

options = optimoptions("fmincon",'Display','iter','MaxFunctionEvaluations',10e3);

wstar = fmincon(cost,w0,[],[],[],[],lb,ub,@nonlcon_multi,options)