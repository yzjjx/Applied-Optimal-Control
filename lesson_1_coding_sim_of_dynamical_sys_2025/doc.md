# 微分方程-物理系统的仿真
如果将微分方程转换为

$$
\dot{x}(t) = f(x(t),u(t))
$$

这种形式，就可以通过ODE（常微分方程）进行模拟仿真

以烤箱为例，定义热量为 $\dot{Q}(t)$ , $T(t)$ 为随时间变化的温度

可以得到微分方程为：

$$
\dot{T}(t) = k(T_{amb}-T(t))+\dot{Q}(t)
$$

需要模拟这个系统就是要将这个公式转换为状态空间方程的形式，也就意味着需要找到状态向量 $x(t)$ ,这里的 $x(t)=[T(t)]$ ，另外假设输入 $u(t) = \dot{Q}(t)$ ，也就是可以决定输入多少热量

下面使用Euler方法近似求解，即： $T(t+\Delta t) = T(t)+\dot{T}(t)\Delta t$

$\Delta t$ 由我们决定， $\Delta t$ 越小越精确

烤箱仿真查看代码文件
`lesson_1_coding_sim_of_dynamical_sys_2025\oven.m`

## 单摆仿真
单摆仿真的公式为： 

$$
\begin{equation}
\ddot{\theta}(t) = -\frac{g}{L}\sin(\theta(t))
\end{equation}
$$

$$
\begin{equation}
x(t) =
\begin{bmatrix}
\theta(t) \\
\dot{\theta}(t)
\end{bmatrix}
\end{equation}
$$

$$
\begin{equation}
\dot{x}(t) =
\begin{bmatrix}
\dot{\theta}(t) \\
-\frac{g}{L}\sin(\theta(t))
\end{bmatrix}
\end{equation}
$$

下面是普通代码形式：

```matlab
clc;
clear;
close all;

% 定义变量
m = 1;
g = 9.81;
L = 1;

dt = 0.001;
time_final = 10;

time_vector = (0:dt:time_final)';
% 需要向量存储theta和dtheta
theta_vector = zeros(size(time_vector));
dtheta_vector = zeros(size(time_vector));

% 初始条件
theta_vector(1) = pi/4;
dtheta_vector(1) = 0;

% Euler Sim Loop
for iter = 1:numel(time_vector)-1
    ddtheta = -g/L * sin(theta_vector(iter));
    theta_vector(iter+1) = theta_vector(iter) + dtheta_vector(iter)*dt;
    dtheta_vector(iter+1) = dtheta_vector(iter) + ddtheta*dt;
end

% theta and time
h = plot(time_vector,theta_vector,'k-');
xlabel('Time(s)');
ylabel('Thtea(rad)');
title('Pendulum sim');
```

代码放在`lesson_1_coding_sim_of_dynamical_sys_2025\pendulum.m`

但是如果能将 $\dot{x}(t)$ 直接放到模拟器就进行模拟，代码就会变得很简单。因此就可以创建一个m-fun，然后将这段代码编写进去，然后告诉模拟器这个函数，用这个函数进行仿真

<div align="center">
    <img src="..\fig\状态向量与时间向量.png">
    <br>
</div>

建立一个函数，先考虑 $\dot{x}(t) = f(x(t))$

详细代码可以查看：`lesson_1_coding_sim_of_dynamical_sys_2025\newpend.m`与函数`lesson_1_coding_sim_of_dynamical_sys_2025\ODEfun.m`

也就是更常用的ODE45方法仿真，关键代码为：
```matlab
% ODE45,tout为时间点向量；state_output为状态向量；第一个参数为函数句柄（@），第二个
% 参数为时间范围，第三个参数为初始状态
% 红色曲线为ODE45方法仿真
[tout,xout] = ode45(@ODEfun,[0 tf],x0);
```

