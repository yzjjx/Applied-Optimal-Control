单重打靶采用时间步进积分方法，例如ODE45，从初始条件出发，然后向前推进进行积分

直接配置法在于对关键点进行检查，找到中间点，并且检查这些导数的斜率是否符合物理归规律

$\dot{x}$ 就是状态随时间变化，这个就是斜率

因此直接配置法的作用就是检查关键处的物理规律

Collocation methods check the physics along the trajectory at collocation points.

配点法（Collocation Methods）在轨迹上的各个配点处，检查系统是否满足物理动力学方程。

Trajectory optimization thus far we have used to calculate open-loop control (feedforward), $u(t)$.

到目前为止，我们一直使用轨迹优化来计算开环控制（前馈控制）的控制输入 $u(t)$。

也就是说目前控制器没有来自状态的反馈

If Trajectory Optimization can be made fast enough, then it can be used for closed-loop (feedback) control.

如果能够使轨迹优化的计算速度足够快，那么就可以将其用于闭环控制（反馈控制）。

Model-Predictive Control: Process of generating closed-loop control inputs via trajectory optimizations on LTI system dynamics with evolving initial conditions and a receding time horizon.

模型预测控制（MPC）：通过对线性时不变（LTI）系统的动力学进行轨迹优化，并结合不断更新的初始条件和滚动变化的预测时域，生成闭环控制输入的过程。

Sampling time is the interval between measurements.

采样时间是指相邻两次测量之间的时间间隔。

MPC (Model Predictive Control)
1. Measure state $x(t)$.
2. Perform trajectory optimization with fixed time horizon, \(T\).
3. Execute optimized control input, \(u(t)\), for \(T_s\) seconds.
4. Go to ①.

MPC（模型预测控制）
1. 测量状态：获取系统当前的状态。
2. 执行轨迹优化：在固定的预测时间范围 \(T\) 内进行轨迹优化。
3. 执行最优控制输入：将优化得到的控制输入 \(u(t)\) 施加到系统上，持续 \(T_s\) 秒。
4. 返回第一步：重新测量状态，重复上述过程。

在轨迹优化的时候会使用一个变量来表示T，通常是轨迹优化的最后阶段

If your problem has:
1. LTI dynamics
2. Fixed time horizon, \(T\),  
then direct collocation will create a set of physical constraints that are linear!

如果你的优化问题满足以下两个条件：
1. 线性时不变系统动力学（LTI Dynamics）
2. 固定的时间范围 \(T\)（Fixed Time Horizon）  
那么，直接配点法（Direct Collocation）所建立的一组物理动力学约束将是线性的！

To achieve a convex quadratic programming formulation, the cost must be quadratic, i.e., positive constant Hessian

为了将优化问题构造成一个凸二次规划（Convex Quadratic Programming，凸 QP）问题，代价函数必须是二次型的，即其 Hessian 矩阵（海森矩阵）应当是常数矩阵，并且具有非负的曲率

## MPC代码（直接配点法）
使用MPC控制器将物体移动到指定的位置

构建决策向量，假设节点数量为N，因为使用配点法，决策向量需要包含输入力和状态，为：

$$
w = \begin{bmatrix}
F_{x1} \\
... \\
F_{xN} \\
F_{y1} \\
... \\
F_{yN} \\
x_1 \\
 ...\\
x_N \\
 ...\\
dx_1 \\
 ...\\
dx_N \\
 ...\\
y_1 \\
 ...\\
y_N \\
 ...\\
dy_1 \\
 ...\\
dy_N \\

\end{bmatrix}
$$

Physics (defect) constraints.

Use Explicit (Forward) Euler Integration.

物理（缺陷）约束。

使用显式（前向）欧拉积分法。

使用前线欧拉进行物理约束：

$$
s_{k+1} = s_k + \dot{s}_k\Delta t
$$

可以得到：

$$
z_{k+1}  = z_k + (Az_k+Bu_k)(T/(N+1))
$$

将等式右边的移动到左边，就是等式约束

首先是仿真代码

```matlab
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
dynamics = @(t,z,u) Asys*z+Bsys*u;
u = [0;0];
dynamics_call = @(t,z) dynamics(t,z,u);

% 仿真参数
tspan = [0 10];
z0 = [0;0;0;0];

[tout,zout] = ode45(dynamics_call,tspan,z0);

% 绘图
plot(zout(:,1),zout(:,3),'k-')
xlabel('x pos')
ylabel('y pos')
```

对于二次规划，有标准式子：

$$
w^{*} = argmin \frac{1}{2} w^THw+c^Tw
$$

其中，H为hessian矩阵，c为gradint

限制条件为：

$$
A_{con}w\le b_{con}
$$

$$
A_{coneq}w =  b_{coneq}
$$


MPC基本代码如下：

```matlab
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

%% 创建仿真循环
% 每次采样时间dT，获取当前状态z0；进行轨迹优化；
t_current = tspan(1);

t_sim = [];% Running list of all simulation times from all ode45 calls
z_sim = [];% Running list of all simulation states from all ode45 calls
for iter = 1:numel(0:dT:10)

    % 更新约束
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
end

% 绘图
plot(z_sim(:,1),z_sim(:,3),'k-')
xlabel('x pos')
ylabel('y pos')

xplan = wstar(2*N+1:3*N);
yplan = wstar(4*N+1:5*N);
plot(xplan,yplan,'kx-');
axis equal
xlabel('x pos')
ylabel('y pos')
```

