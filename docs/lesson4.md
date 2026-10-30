Trajectory optimization is a method for generating a feedforward trajectory for a dynamical system while minimizing a cost function and satisfying constraints.

轨迹优化是一种为动力学系统生成前馈轨迹的方法，旨在满足约束条件的同时，使代价函数最小化。

Define the optimization problem:
- Decision vector
- Cost function
- Constraints

定义优化问题：
- 决策向量
- 代价函数
- 约束条件

在所有的优化问题中，可以将最后的约束条件变为gw和geqw，构成了所有的非线性约束

求最大面积问题：
决策变量为：w = [L H]^T
代价函数为：J（w） = -LH
约束条件为：2W+2H≤40；
也就是gw=2L+2H-40小于等于0

Single shooting requires simulating an entire trajectory to evaluate the cost and/or constraints.

单重打靶法需要对整条轨迹进行仿真，以评估代价和／或约束条件。

Formulations — Single Shooting:
- Less effective for nonlinear, unstable, or underactuated systems.
- Fewer decision variables and constraints than other methods. At a minimum, you only need to define control inputs along the trajectory.


问题构建方式——单重打靶法：
- 对于非线性、不稳定或欠驱动系统，效果较差。
- 与其他方法相比，决策变量和约束条件更少。最基本的情况下，只需定义沿轨迹的控制输入。

Local optimization algorithms evaluate the gradient of the cost function and the Jacobian of the constraints to determine which direction to move the decision vector \(w\).

局部优化算法通过计算代价函数的梯度和约束条件的雅可比矩阵，确定决策向量 \(w\) 的更新方向。默认情况下，这些梯度是通过有限差分的方法去计算的

除非必要，否则为什么要多增加决策变量

If you are performing trajectory optimization on nonlinear dynamical systems, the local derivatives can be misleading when solving the problem.

对非线性动力学系统进行轨迹优化时，局部导数提供的信息可能会误导问题的求解过程。

如果电机的力矩足够强，可以直接朝着目标方向施加力矩，接近顶部再制动
也就是说当控制能力充足的时候，直接转上去再停住是比较容易找到的控制策略，单重打靶也比较容易求解；
但是当力矩受限的时候，就需要像荡秋千一样积累能量
也就是摆向一侧运动的时候顺势推动，摆回来的时候也顺势推动，就能在往复运动中持续注入能量，接近目标的时候再调整控制，让它在顶部停住

Multiple Shooting
A multiple shooting formulation adds additional decision variables to define the state trajectory and enforces continuity via defect constraints.

多重打靶法
多重打靶法引入额外的决策变量来描述状态轨迹，并通过缺陷约束保证各段轨迹之间的连续性。

也就是将节点状态设为变量，让轨迹各个段可以独立调整；再增加连接约束，保证最后能拼接成一条真实轨迹

我们无法仅凭对控制系统的猜测就轻易地将系统状态驱动到该状态

- Add decision variables.
- Add defect constraints.
Multiple Shooting:
- More reliable for underactuated systems and systems with unstable nonlinear dynamics.
- Can take longer to solve.

- 增加决策变量。
- 增加缺陷约束。
多重打靶法：
- 对于欠驱动系统以及具有不稳定非线性动力学的系统，求解更可靠。
- 求解可能需要更长时间。
 
要知道nonlcon，必须将状态从初始状态模拟到最终状态