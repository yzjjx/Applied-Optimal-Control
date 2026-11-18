here are subtypes of "programs" called:

- Linear Program (LP)
- Quadratic Program (QP)
- Convex Program（CP）
- Nolinear Program (NLP)


规划问题有以下子类型：

-线性规划LP

-二次规划QP

-凸规划CP

-非线性规划NLP

## 线性规划LP
Linear programs have a cost function and constraints that are linear in the decision variables in $w$ .

线性规划的代价函数与约束条件关于决策变量 $w$ 是线性的.

视频45：00（https://www.youtube.com/watch?v=eXqsyYngHhY&t=3s）

之所以说凸，是因为约束造成的图形是凸形，即

<div align="center">
    <img src="..\fig\凸图像.png">
    <br>
</div>

如果约束条件构成一个凸集，凸集将会引导进行简单的梯度下降，优化方法会找到最佳的解决方案，因此要考虑凸优化问题

Locally optimal solution to "Convex programs" are as low in cost as the globally optimal solution.

All linear programs are convex!

凸规划的局部最优解，代价和全局最优解一样低。

所有线性规划都是凸规划

常数在代价函数中并不重要

## 二次规划QP

代价函数是二次的，但是约束仍然是线性的

标准形式为：

$$
w^* = \mathop{\arg\min}_{w} w^\top H w + c^\top w
\quad \text{s.t.} \quad
\begin{cases}
A w \le b \\
A_{\text{eq}} w = b
\end{cases}
$$


## 二次型函数的矩阵表示

考虑一个二次型函数，定义变量向量：

$$
w=\begin{bmatrix}w_1\\w_2\end{bmatrix}
$$

定义矩阵：

$$
H=\begin{bmatrix}
h_{11}&h_{12}\\
h_{21}&h_{22}
\end{bmatrix}
$$

二次型函数可以表示为：

$$
f(w)=\frac{1}{2}w^THw
$$

将矩阵展开：

$$
\begin{aligned}
\frac{1}{2}w^THw
&=\frac{1}{2}
\begin{bmatrix}w_1&w_2\end{bmatrix}
\begin{bmatrix}
h_{11}&h_{12}\\
h_{21}&h_{22}
\end{bmatrix}
\begin{bmatrix}w_1\\w_2\end{bmatrix}\\
&=\frac{1}{2}\left(
h_{11}w_1^2+
h_{12}w_1w_2+
h_{21}w_1w_2+
h_{22}w_2^2
\right)
\end{aligned}
$$

当矩阵 $H$ 为对称矩阵时，有：

$$
h_{12}=h_{21}
$$

因此：

$$
f(w)=\frac{1}{2}h_{11}w_1^2+
h_{12}w_1w_2+
\frac{1}{2}h_{22}w_2^2
$$

例如，给定二次型函数：

$$
f(w)=2w_1^2+4w_1w_2+3w_2^2
$$

通过比较系数，可以得到：

$$
\begin{aligned}
\frac{1}{2}h_{11}&=2\\
h_{12}=h_{21}&=4\\
\frac{1}{2}h_{22}&=3
\end{aligned}
$$

最终得到矩阵：

$$
\boxed{
H=\begin{bmatrix}
4&4\\
4&6
\end{bmatrix}
}
$$

因此，原来的二次型函数可以写为：

$$
\boxed{
f(w)=\frac{1}{2}w^T
\begin{bmatrix}
4&4\\
4&6
\end{bmatrix}w
}
$$

其中，H矩阵为Hession矩阵

## 线性规划与二次规划的代码
线性规划的详细代码参考：`lesson4_DragRace\linera_programming\Portfolio0pt.m`

二次规划

凸函数的判断标准是，连接函数图像上任意两点的线段，必须始终位于函数图像的上方或与图像重合，如下图

<div align="center">
    <img src="..\fig\二次规划的凸函数与非凸函数.png">
    <br>
</div>

Not all QPs are convex.

They are convex if the cost is not concave down

并非所有二次规划（QP）都是凸的。

当代价函数不是向下凹时，它才是凸的。

也就是意味着Hession矩阵大于等于0，因为Hession是一个矩阵，因此Hession矩阵必须是半正定的，也就是所有特征值是大于等于0的

常数并不能改变最优化求解的结果，因为最优化求解的是w的值，而不是函数的值，即虽然上下平移，但是结果不变

to find the feedforward controller $F(t)$, that minimizes effort for the following system

为下述系统寻找前馈控制器 $F(t)$，使得控制代价最小：

<div align="center">
    <img src="..\fig\系统描述.png">
    <br>
</div>

<div align="center">
    <img src="..\fig\每一步的最优代价.png">
    <br>
</div>

定义决策向量：

$$
w = [F_1;F_2;F_3;F_4;F_5]
$$

有代价函数：

$$
\begin{aligned}
f(w)
&= \int_0^T F(t)^2\,dt \\[8pt]
&\approx F_1^2\Delta t+F_2^2\Delta t+\cdots+F_N^2\Delta t \\[8pt]
&= \left(\sum_{i=1}^{N}F_i^2\right)\Delta t
\end{aligned}
$$

限制：5s内到达，并且在静止条件下，位置为1,即：

$$
\begin{aligned}
s(0) &= 0 \quad \text{start at the starting line} \\
\dot{s}(0) &= 0 \quad \text{starts at rest} \\
s(5) &= s(4) + \dot{s}(4)\Delta t
\end{aligned}
$$

继续

$$
\begin{aligned}
\dot{s}(5) &= \dot{s}(4) + \ddot{s}(4)\Delta t \\
s(5) &= s(4) + \dot{s}(4)\Delta t \\
\dot{s}(4) &= \dot{s}(3) + \ddot{s}(3)\Delta t \\
s(4) &= s(3) + \dot{s}(3)\Delta t
\end{aligned}
$$

并且必须满足：

$$
s(5)=2;\dot{s}(5)=0
$$

且：

$$
\begin{aligned}
m\ddot{s}(t) &= F(t) \\
\ddot{s}(t) &= F(t)/m
\end{aligned}
$$

最终相关代码可以参考`lesson4_DragRace\QP\doubleIntQP.m`

# 轨迹优化
Nonlinear Program (NLP)  
if $f(w), g(w), g_{eq}(w)$ are generally nonlinear.

若目标函数 $f(w)$、不等式约束 $g(w)$、等式约束 $g_{eq}(w)$ 一般为非线性函数。

用来解决非线性规划的函数为fmincon

最优化与轨迹规划的区别：最优化是找一个最有数值，轨迹优化是找一段时间内的完整运动过程

Trajectory optimization is an optimal control problem that optimizes the time-varying trajectory of a dynamical system. Typically, integration of the system dynamics is required in the cost function, constraints, or both.

轨迹优化是一类最优控制问题，用于优化动力学系统随时间变化的轨迹。通常，代价函数、约束条件（或二者同时）需要对系统动力学进行积分。

<div align="center">
    <img src="..\fig\simlation.png">
    <br>
</div>

如果表现为非线性，可以使用ODE45放在约束条件之中

Having simulation in your cost/constraint complicates the process of finding partial derivatives for gradient-based solvers.

若代价函数 / 约束中包含仿真环节，会增加基于梯度的求解器求取偏导数的难度。

有限差分：

Finite Differencing（有限差分法）

有限差分法通过差分近似函数的真实导数。

$$
\frac{\partial f(x)}{\partial x}
=
\lim_{\Delta x \to 0}
\frac{f(x+\Delta x)-f(x)}{\Delta x}
$$

与选择计算大型符号导数计算，有限差分的优势：只需要计算 $f(x)$ 就可以了，将一个函数运行两次，使用两个不同的参数。

有限差分的缺点：如果dx取得太大，精度就会大打折扣；并且要求函数具有连续性

Formulations of Trajectory Optimization Problems.

- Shooting Methods
- Collocation / Transcription Methods


轨迹优化问题的建模形式

- 打靶法（Shooting Methods）
- 配点法 / 转录法（Collocation / Transcription Methods）

# 打靶法（Shooting Methods）
只需要运行仿真程序就可以评估结果，射击，看看结果如何

Shooting methods evaluate the evolution of system dynamics via time-marching integration (Forward Euler / ode45 RK).

打靶法通过时间推进积分（前向欧拉法 /ode45 龙格–库塔法）求解系统动力学的演化过程

缺点：每次仿真的时候，都需要花费一定时间

- Intuitive
- Take a lot of time
- Derivatives can be noisy.
- Can be challenging for unstable systems (underactuated systems) to solve.


- 直观易懂
- 耗时较长
- 导数容易带有噪声。
- 对于不稳定系统（欠驱动系统），求解难度较大。

# collocation方法
这种方法不需要进行仿真

Collocation methods enforce the dynamics as "constraints" at "collocation points" along the trajectory.

配点法在轨迹上的各个配点处，将动力学方程作为约束条件进行施加。

<div align="center">
    <img src="..\fig\两种方法的区别.png">
    <br>
</div>

如果希望模拟到精确的结果，并且又能享受局部化计算带来的优势，可以使用多重打靶