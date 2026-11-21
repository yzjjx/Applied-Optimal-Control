# LTI线性时不变系统
为了仿真，我们需要将系统的动力学方程表示为状态空间的形式，即：

$$
\dot{x}(t)=f(x(t),u(t))
$$

其中f可以是非线性函数

there are a subset of dynamical systems (continuous) that are Linear Time Invariant (LTI).

在连续时间动力系统（Continuous Dynamical Systems）中，有一类系统被称为线性时不变系统（Linear Time-Invariant Systems，LTI）

LTI状态空间可以表示为：
$$
\dot{x}(t) = Ax(t)+Bu(t)
$$

$$
y(t) = Cx(t)+Du(t)
$$

A: System Matrix

B: Input Matrix

C: Output Matrix (Sensor)

D: Feedforward Matrix

A：系统矩阵

B：输入矩阵

C：输出矩阵（传感器）

D：前馈矩阵（直接传递矩阵）


如果没有控制输入，公式可以改为：$\dot{x}(t) = Ax(t)$

也就是说，在没有控制输入的时候，A矩阵驱动整个系统动力学

例子：假如 $\dot{x}(t)$ 是一个标量

并且可以检查稳定性，即检查A矩阵的特征值就可以判断线性系统的稳定性，如图：

<div align="center">
    <img src="..\fig\实数状态.png">
    <br>
</div>

如果是矩阵，则可以推导：

<div align="center">
    <img src="..\fig\矩阵指数.png">
    <br>
</div>

<div align="center">
    <img src="..\fig\检查特征值.png">
    <br>
</div>

其中 $v$ 为特征向量，$\lambda$ 为特征值

If all $\lambda$'s have negative real components, then the state will decay to zero.

如果所有特征值 $\lambda$ 的实部均为负数，那么系统的状态将逐渐衰减至零。

对于方程：

$$
\dot{x}(t) = Ax(t)+Bu(t)
$$

We can define feedback controllers so we can drive our state to a desired state (typically zero).

我们可以设计反馈控制器，使系统状态逐渐趋近于期望状态（通常为零）。

<div align="center">
    <img src="..\fig\设置增益.png">
    <br>
</div>

代入推导，可以得到下面的公式：

$$
\begin{aligned}
\dot{x}(t) &= Ax(t) + B(-Kx(t)) \\[8pt]
\dot{x}(t) &= Ax(t) - BKx(t) \\[8pt]
\dot{x}(t) &= (A-BK)x(t) \\[12pt]
\tilde{A} &= A-BK \\[8pt]
\dot{x}(t) &= \tilde{A}x(t)
\end{aligned}
$$

通过设计反馈增益矩阵 K，可以改变闭环系统的特征值，从而控制系统的稳定性。

可控性矩阵，如果C矩阵是满秩的，则系统可控，如下图所示

<div align="center">
    <img src="..\fig\可控性矩阵.png">
    <br>
</div>

If the system is controllable, then you have a wide array of LTI control methods available.

如果系统是可控的，那么你就可以采用多种线性时不变（LTI）系统的控制方法。

Ex. – Pole Placement (Ackermann's Formula)

例题——极点配置（阿克曼公式）

LQR控制：

定义代价函数为：

$$
f(x(t),u(t))
=\int_{0}^{t_f}
\left[
x(t)^TQx(t)+u(t)^TRu(t)
\right]dt
$$

也就是说矩阵 $(A,B,Q,R)$ 定义了增益 $K$

也就是求解Riccati方程，因此现在就不需要fmincon等

## 线性化非线性系统

核心原理是在曲线上找到一个点，然后在点附近进行线性化，画一条大致的切线

<div align="center">
    <img src="..\fig\线性化.png">
    <br>
</div>

斜率就是对函数进行线性化的结果，相当于一阶泰勒展开

也就是两个步骤：1、寻找到一个线性点；2、寻找到斜率

同时，偏移量为0很重要，假设线性点为 $x^*,u^*$ ，即：

$$
\dot{x}(t)=f(x(t),u(t))
\Rightarrow f(x^*,u^*)=0
$$

$x^*,u^*$ must be a “fixed point”, which means that all state derivatives $\dot{x}(t)$ must be zero at $x^*,u^*$.

$x^*,u^*$ 必须构成一个“固定点”（平衡点），这意味着当系统处于状态 $x^*$ 、控制输入为 $u^*$ 时，所有状态变量对时间的导数 $\dot{x}(t)$ 都必须为零。

例子：

<div align="center">
    <img src="..\fig\线性点例子.png">
    <br>
</div>

也就是说：

$$
\dot{x}(t)
=
\begin{bmatrix}
\dot{\theta}(t) \\
\ddot{\theta}(t)
\end{bmatrix}
=
\underbrace{
\begin{bmatrix}
\dot{\theta}(t) \\[6pt]
-\dfrac{g}{L}\sin\theta(t)
+\dfrac{\tau(t)}{mL^2}
\end{bmatrix}
}_{f(x(t),u(t))}
$$

可以得到两组固定值：

$$
\dot{\theta}^* = 0,\theta^* = 0;\tau^* = 0
$$

$$
\dot{\theta}^* = \pi,\theta^* = 0;\tau^* = 0
$$

在选定线性化点之后，第二个步骤就是计算slopes

$$
\begin{aligned}
\tilde{x}(t) &= x(t)-x^* \\[6pt]
\tilde{u}(t) &= u(t)-u^* \\[12pt]
\dot{\tilde{x}}(t) &= A\tilde{x}(t)+B\tilde{u}(t) \\[12pt]
A &= \left.\frac{\partial f}{\partial x}\right|_{x^*,u^*} \\[12pt]
B &= \left.\frac{\partial f}{\partial u}\right|_{x^*,u^*}
\end{aligned}
$$

为什么要相减：

<div align="center">
    <img src="..\fig\为什么要相减.png">
    <br>
</div>


同时希望截距为0：

<div align="center">
    <img src="..\fig\截距需要为0.png">
    <br>
</div>


## 代码实例：线性化与LTI系统控制器

以上面的钟摆为例

距离固定点越远，线性化程序就越差，如果初始点为pi/4，得到的仿真为：

<div align="center">
    <img src="..\fig\pi4的仿真.png">
    <br>
</div>

如果初始点为pi/8，得到：

<div align="center">
    <img src="..\fig\pi8的仿真.png">
    <br>
</div>


可以用第二个固定点，推导一遍雅可比矩阵A和B

这样一来，系统变得不稳定，得到的仿真结果为：

线性化系统使得我们原理指数级别的变化，矩阵A决定了稳定性

之后，可以计算极点配置，以及通过矩阵A判断稳定性

<div align="center">
    <img src="..\fig\矩阵A判断稳定性.png">
    <br>
</div>

矩阵不稳定如下

<div align="center">
    <img src="..\fig\矩阵不稳定.png">
    <br>
</div>

计算极点如下：

<div align="center">
    <img src="..\fig\极点配置.png">
    <br>
</div>
