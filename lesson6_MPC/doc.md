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


