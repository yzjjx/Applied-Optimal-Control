clc;clear;close all;
% 模型参数
m = 10;
Fmin = -10;
Fmax = 10;
speedmin = -1;
speedmax = 1;

% ODE45动力学
Asys = [0 1 0 0;0 0 0 0;0 0 0 1;0 0 0 0];
Bsys = [0 0;1/m 0;0 0;0 1/m];
dynamics = @(t,z,u) Asys*z + Bsys*u;
u = [0;0];
dynamics_call = @(t,z) dynamics(t,z,u);

% 建立优化问题，使用符号计算来获取二次规划参数
N = 10;
zsym = sym('z',[4,N]);
usym = sym('u',[2;N]);

% 定义决策向量
decision_vector_control_column = reshape(usym.',[2*N,1]);
decision_vector_state_column = reshape(zsym.',[4*N,1]);
w = [decision_vector_control_column;decision_vector_state_column];

% 定义代价函数
T = 2;% Time Horizon
xtarget = 5;
ytarget = 2;
dT = T/(N-1);
cost = sum(((zsym(1,:)-xtarget)).^2+((zsym(3,:)-ytarget)).^2+usym(1,:).^2+usym(2,:).^2)*dT;

% 计算hessian矩阵
H = hessian(cost,w);
H = double(H);
c = gradient(cost,w);
c = subs(c,w,zeros(size(w)));
c = double(c);

% 仿真参数
tspan = [0 10];
z0 = [0;0;0;0];

% 约束（前向欧拉）
physics_constraints = zsym(:,2:N)-zsym(:,1:N-1)-(Asys*zsym(:,1:N-1)+Bsys*usym(:,1:N-1))*(T/(N-1));
% 初始条件
initial_condition_constraints = zsym(:,1)-z0;

eq_con = [physics_constraints(:);initial_condition_constraints(:)];
Aconeq = jacobian(eq_con,w);
Aconeq = double(Aconeq);
bconeq = -subs(eq_con,w,zeros(size(w)));
bconeq = double(bconeq);

wstar = quadprog(H,c,[],[],Aconeq,bconeq);

[tout,zout] = ode45(dynamics_call,tspan,z0);

% 绘图
plot(zout(:,1),zout(:,3),'k-')
xlabel('x pos')
ylabel('y pos')

xplan = wstar(2*N+1:3*N);
yplan = wstar(4*N+1:5*N);
plot(xplan,yplan,'kx-');
axis equal
xlabel('x pos')
ylabel('y pos')
