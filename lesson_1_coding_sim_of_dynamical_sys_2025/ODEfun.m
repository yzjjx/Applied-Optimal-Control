function dx = ODEfun(t,x)
% 对于ODE仿真器，必须返回状态向量的导数
% 输入是时间和状态
g = 9.81;
L = 1;

theta = x(1);
dtheta = x(2);

dx = zeros(2,1);

dx(1) = dtheta;
dx(2) = -g/L*sin(theta);
end