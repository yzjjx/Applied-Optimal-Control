# 直接配点法

Direct Collocation is more effective than Single Shooting for unstable / underactuated systems.

对于不稳定系统或欠驱动系统，直接配点法比单重打靶法更加有效。

给出例子为小车移动：

<div align="center">
    <img src="..\fig\小车移动到指定位置.png">
    <br>
</div>

Transcribe our optimization problem (program) using Direct Collocation and solve the optimization problem.

Assume Explicit Euler integration.

使用**直接配点法（Direct Collocation）**可以将我们的优化问题转录为数学优化规划问题，并求解该优化问题。

假设采用显式欧拉积分法（Explicit Euler Integration）。

使用配点法，需要将节点的状态加入决策变量中，因此现在的决策变量有：

$F_1,\ldots,F_N$ ：每个离散节点的控制力。

$s_1,\ldots,s_N$ ：每个离散节点的位置。

$\dot{s}_1,\ldots,\dot{s}_N$ ：每个离散节点的速度。

$T$ ：总运动时间，也是需要优化的变量

代价函数为时间最小，即 $f(w) = T$

给出约束条件：初始位置为0，初始速度为0，终端位置等于目标位置，终端速度为0，控制力在允许范围内，离散节点满足动力学方程

约束和前向欧拉可以参见：

<div align="center">
    <img src="..\fig\物理约束.png">
    <br>
</div>

<div align="center">
    <img src="..\fig\前向欧拉.png">
    <br>
</div>

在编程方面，首先需要一个优化器fmincon，同时需要非线性约束（nonlcon）、代价函数  
在非线性约束中不需要ODE45进行仿真，不需要写欧拉循环仿真