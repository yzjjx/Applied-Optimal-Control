# Sigle shooting
Single shooting is a method of transcribing trajectory optimization problems that assesses costs & constraints with a single time-marching integration from the initial to final time.

**单重打靶法（Single shooting）** 是一种对轨迹优化问题进行转录的方法：它通过**单次从初始时刻到终止时刻的时间推进积分**，来计算代价函数并检验约束条件

# 问题

给一个例子如下，假设喷气背包只能施加向上的力

<div align="center">
    <img src="..\fig\例子.png">
    <br>
</div>

然后需要将方程转换为状态空间的形式

<div align="center">
    <img src="..\fig\系统建模.png">
    <br>
</div>

因为我们还需要得到最终的位置，即 $x(t),y(t)$ ，因此可以得到四个状态，如下图所示：

<div align="center">
    <img src="..\fig\状态数量计算.png">
    <br>
</div>

$$
u(t) = F(t)
$$

$$
\dot{\boldsymbol{z}}(t) =
\begin{bmatrix}
\dot{x}(t) \\
\ddot{x}(t) \\
\dot{y}(t) \\
\ddot{y}(t)
\end{bmatrix}
=
\begin{bmatrix}
\dot{x}(t) \\
0 \\
\dot{y}(t) \\
-g + \dfrac{F(t)}{m}
\end{bmatrix}
$$

以上就是所有的状态空间模型

之后，首先就根据状态空间模型建立仿真模型，如下代码所示：

```matlab
clc;clear;close all;

tspan = [0 10];
x0 = 0;
dx0 = 1;
y0 = 0;
dy0 = 1;

z0 = [x0;dx0;y0;dy0];

% 使用ODE45仿真
[tout,zout] = ode45(@jetpackDynamics,tspan,z0);

% 绘图
xout = zout(:,1);
yout = zout(:,3);
plot(xout,yout,'k-','LineWidth',2)
axis equal
```

函数如下

```matlab
function [dz] = jetpackDynamics(t,z)
    % 函数得到当前时间和状态，为什么这么做：因为ODE45函数要求
    % z = [x;dx;y;dy]
    m = 75;
    g = 9.81;
    F = 700;

    dz = zeros(4,1);
    dz(1) = z(2);
    dz(2) = 0;
    dz(3) = z(4);
    dz(4) = -g+F/m;
end
```

We need to represent our control inputs as a decision vector:

我们需要将控制输入表示为一个决策向量

为了进行轨迹优化，必须将控制策略F作为决策变量  
如何将这些量表示出来，就可以将它表示称为一条样条曲线

<div align="center">
    <img src="..\fig\决策变量的演化.png">
    <br>
</div>

然后将最终时间作为最后一个决策变量

We need a decision vector that fully decides the controller.

Commonly achieved for feedforward controllers using splines.

我们需要一个决策向量，能够完全确定控制器。  
前馈控制器通常借助样条（spline）实现该目的。

最后，需要定义约束条件

<div align="center">
    <img src="..\fig\约束条件.png">
    <br>
</div>

最后得到 $F_1 \ge 0,\ F_2 \ge 0,\ \dots,\ F_N \ge 0$ 是因为将F定义为了样条曲线

代价函数：

平方用来避免负推力的产生

<div align="center">
    <img src="..\fig\代价函数推导.png">
    <br>
</div>

使用fmincon解决问题，等式约束的终点需要仿真来得到。这就是为什么需要打靶法，因为需要仿真得到约束或者代价函数

<div align="center">
    <img src="..\fig\代价函数推导.png">
    <br>
</div>

等式约束如下：

<div align="center">
    <img src="..\fig\等式约束.png">
    <br>
</div>

其中需要仿真的等式约束为：

<div align="center">
    <img src="..\fig\需要仿真的等式约束.png">
    <br>
</div>

主脚本调用优化器函数，优化器函数需要调用代价函数和约束条件，而约束条件需要进行仿真，仿真代码需要调用ODE45

首先看可行性，正确的计算可行性应该逐渐收敛为0，如下图为不正确的

<div align="center">
    <img src="..\fig\可行性判断.png">
    <br>
</div>

<div align="center">
    <img src="..\fig\另一种看法.png">
    <br>
</div>

<div align="center">
    <img src="..\fig\报错1.png">
    <br>
</div>

解决该问题的代码为：  
`lesson4_3_coding_shooting_method\main.m`  
调用的函数为：  
`lesson4_3_coding_shooting_method\jetpackControlDynamics.m、lesson4_3_coding_shooting_method\cost_fun.m、lesson4_3_coding_shooting_method\nonlcon.m`

最后一个时刻的巨大上升与什么有关

<div align="center">
    <img src="..\fig\最后时刻的巨大上升.png">
    <br>
</div>

使用矩形计算cost_fun

```matlab
function cost = cost_fun(w)
% input:决策向量decision vector
%[F1,F2,...FN,T]

    F_vec = w(1:end-1);
    T = w(end);
    N = numel(w)-1;
    dt = T/(N-1);

    cost = sum(F_vec(1:end-1).^2)*dt; 
end
```

因为中间的矩形计算忽略了最后一点

将矩形计算改为梯形计算可以优化这一点

## 继续添加约束
