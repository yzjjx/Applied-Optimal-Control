# 简单控制系统
lesson实现的系统只有 $\dot{x}(t) = f(x(t))$ ，其中并没有控制系统，加入控制系统的公式为 $\dot{x}(t) = f(x(t),u(t))$ 

在连接处加入一个电机，公式修改为：

$$
\ddot{\theta}(t) = -\frac{g}{L}\sin\theta(t) + \frac{\tau(t)}{mL^2}
$$

转换为状态空间的形式，为：

$$
x(t) = \begin{bmatrix}
\theta(t) \\
\dot{\theta}(t)
\end{bmatrix}
$$

$$
\dot{x}(t) =
\begin{bmatrix}
\dot{\theta}(t) \\
\ddot{\theta}(t)
\end{bmatrix}
=
\begin{bmatrix}
\dot{\theta}(t) \\
-\dfrac{g}{L}\sin\theta(t) + \dfrac{\tau(t)}{mL^2}
\end{bmatrix}
$$

根据欧拉方程：

$$
\theta(t+\Delta t) = \theta(t) + \dot{\theta}(t)\Delta t
$$

$$
\dot{\theta}(t+\Delta t) = \dot{\theta}(t) + \ddot{\theta}(t)\Delta t
$$

开环控制的主要代码为：
```matlab
for iter = 1:numel(time_vector)-1
    % 直接给一个固定力矩，相当于开环
    tau = 1;
    ddtheta = -g/L*sin(theta_vector(iter)) + tau/(m*L^2);

    theta_vector(iter+1) = theta_vector(iter) + dtheta_vector(iter)*dt;
    dtheta_vector(iter+1) = dtheta_vector(iter) + ddtheta*dt;
end
```

下面要加入一个闭环控制器，将期望值减去实际值的量定义为误差，加入简单的PD控制

```MATLAB
% 定义增益
Kp = 10;% 比例增益
Kd = 1;% 微分增益

% 期望位置和期望速度
theta_des = pi;
dtheta_des = 0;

% 将初始角度设置为0，然后给一个外部力矩
theta_vector(1) = 0;
dtheta_vector(1) = 0;

for iter = 1:numel(time_vector)-1
    % PD控制器
    tau = Kp*(theta_des-theta_vector(iter)) + Kd*(dtheta_des - dtheta_vector(iter));
    ddtheta = -g/L*sin(theta_vector(iter)) + tau/(m*L^2);

    theta_vector(iter+1) = theta_vector(iter) + dtheta_vector(iter)*dt;
    dtheta_vector(iter+1) = dtheta_vector(iter) + ddtheta*dt;
end
```

EOM：运动方程，描述物体受到力或者力矩之后，运动状态如何随着时间变化

具体代码可以参考：`lesson_2_add_control_sys_2025\Pendulum_control.m`

# 飞船运行
定义动力学方程有：
$$
\ddot{x}(t) = \frac{-GM\,x(t)}{\big(x(t)^2 + y(t)^2\big)^{3/2}} + \frac{F(t)\cos\theta(t)}{m}
$$

$$
\ddot{y}(t) = \frac{-GM\,y(t)}{\big(x(t)^2 + y(t)^2\big)^{3/2}} + \frac{F(t)\sin\theta(t)}{m}
$$

$$
\ddot{\theta}(t) = \frac{\tau(t)}{I}
$$

以上的所有公式会带来六个状态，给出： $z(t) = [x(t),\dot{x}(t),y(t),\dot{y}(t),\theta(t),\dot{\theta}(t)] $

<div align="center">
    <img src="..\fig\6个状态.png">
    <br>
</div>

可以用fill命令绘制飞船

<div align="center">
    <img src="..\fig\飞船的绘制.png">
    <br>
</div>

完整代码参考：`lesson_2_add_control_sys_2025\spaceshipcontrol.m`