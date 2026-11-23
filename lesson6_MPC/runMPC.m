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


% 建立优化问题，使用符号计算来获取二次规划参数
N = 10;
zsym = sym('z',[4,N]);
usym = sym('u',[2;N]);

% 定义决策向量
decision_vector_control_column = reshape(usym.',[2*N,1]);
decision_vector_state_column = reshape(zsym.',[4*N,1]);
w = [decision_vector_control_column;decision_vector_state_column];

% 定义代价函数
T = 5;% Time Horizon
syms xtarget ytarget;

dT = T/(N-1);
cost = sum(((zsym(1,:)-xtarget)).^2+((zsym(3,:)-ytarget)).^2+usym(1,:).^2+usym(2,:).^2)*dT;

% 计算hessian矩阵
H = hessian(cost,w);

c = gradient(cost,w);
c = subs(c,w,zeros(size(w)));


H_func = matlabFunction(H,'Vars',{xtarget,ytarget});
c_func = matlabFunction(c,'Vars',{xtarget,ytarget});

% 约束（前向欧拉）
physics_constraints = zsym(:,2:N)-zsym(:,1:N-1)-(Asys*zsym(:,1:N-1)+Bsys*usym(:,1:N-1))*(T/(N-1));
% 初始条件
zinit = sym('zinit',[4 1]);
initial_condition_constraints = zsym(:,1)-zinit;

% 创建内联函数用于快速计算
eq_con = [physics_constraints(:);initial_condition_constraints(:)];
Aconeq = jacobian(eq_con,w);
Aconeq_func = matlabFunction(Aconeq,'Vars',{zinit});
bconeq = -subs(eq_con,w,zeros(size(w)));
bconeq_func = matlabFunction(bconeq,'Vars',{zinit});

% 仿真参数
tspan = [0 100];
z0 = [0;0;0;0];

x_target_current = 5;
y_target_current = 2;

x_targ_vec = [];
y_targ_vec = [];

% 存储路径
x_path_store = [];
y_path_store = [];

%% 创建仿真循环
% 每次采样时间dT，获取当前状态z0；进行轨迹优化；
t_current = tspan(1);

t_sim = [];% Running list of all simulation times from all ode45 calls
z_sim = [];% Running list of all simulation states from all ode45 calls
for iter = 1:numel(tspan(1):dT:tspan(2))
    % 加入干扰
    x_target_current = x_target_current + randn*0.1;
    y_target_current = y_target_current + randn*0.1;

    % 更新代价
    H = H_func(x_target_current,y_target_current);
    c = c_func(x_target_current,y_target_current);

    % 更新约束
    Aconeq = Aconeq_func(z0);
    bconeq = bconeq_func(z0);

    options = optimoptions('quadprog','Display','none');
    wstar = quadprog(H,c,[],[],Aconeq,bconeq,[],[],[],options);

    % 从轨迹优化中得到控制输入
    u = [wstar(1);wstar(N+1)];
    dynamics_call = @(t,z) dynamics(t,z,u);

    tspan_iter = [t_current t_current+dT-1e-6];
    [tout,zout] = ode45(dynamics_call,tspan_iter,z0);
    t_current = t_current + dT;

    % 更新当前状态
    z0 = zout(end,:).';

    t_sim = [t_sim;tout];
    z_sim = [z_sim;zout];

    x_targ_vec = [x_targ_vec;x_target_current];
    y_targ_vec = [y_targ_vec;y_target_current];

    x_path_store = [x_path_store,wstar(2*N+1:3*N)];
    y_path_store = [y_path_store,wstar(4*N+1:5*N)];
end

% 绘图
subplot(3,1,1)
plot(z_sim(:,1),z_sim(:,3),'k-')
xlabel('x pos')
ylabel('y pos')
axis equal

subplot(3,1,2)
plot(t_sim,z_sim(:,1),'k-')
xlabel('time(s)')
ylabel('x pos')

subplot(3,1,3)
plot(t_sim,z_sim(:,3),'k-')
xlabel('time(s)')
ylabel('y pos')

% 动画制作
FPS = 20;
SLOMO = 1/5;
t_anim = 0:1/FPS/SLOMO:t_sim(end);
x_anim = interp1(t_sim,z_sim(:,1),t_anim);
y_anim = interp1(t_sim,z_sim(:,3),t_anim);
x_targ_anim = interp1([tspan(1):dT:tspan(2)],x_targ_vec,t_anim);
y_targ_anim = interp1([tspan(1):dT:tspan(2)],y_targ_vec,t_anim);
x_path_anim = interp1([tspan(1):dT:tspan(2)],x_path_store.',t_anim);
y_path_anim = interp1([tspan(1):dT:tspan(2)],y_path_store.',t_anim);

% 动画循环
figure
for iter = 1:numel(t_anim)
    cla;
    hold on
    plot(x_anim(iter),y_anim(iter),'ko','MarkerFaceColor','r','MarkerSize',15);
    plot(x_targ_anim(iter),y_targ_anim(iter),'kx','MarkerSize',15);
    plot(x_path_anim(iter,:),y_path_anim(iter,:),'k-');
    axis equal
    axis([-1 10 -1 10])
    drawnow
end
