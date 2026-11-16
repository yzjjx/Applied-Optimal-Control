# Introduction to Optimization Problems

Optimization is the process of finding the best possible solution to a problem as defined by a numeric cost function.

优化就是根据数值代价函数的定义，寻找问题最优解的过程。

优化问题可以由三个关键部分组成，分别是：

-决策向量（Decision vector）,一般是一个实数（R）

$$
\begin{aligned}
\mathbf{w} &= \begin{bmatrix}
w_1 \\
w_2 \\
\vdots \\
w_n
\end{bmatrix}, \quad \mathbf{w}\in\mathbb{R}^n \\
\mathbf{w}&\in\mathbb{N}^n \\
\mathbf{w}&\in\mathbb{C}^n \\
\mathbf{w}&\in\mathbb{Z}^n
\end{aligned}
$$

-代价函数（cost function），一般是标量函数

Lower cost, by definition, means a better solution.

根据定义，代价越小代表解越好。

代价函数只能返回1个数字

-约束条件（Constraints）

Define considerations that must be obeyed to solve the problem.

规定求解问题时必须遵守的限制条件。

约束有两种类型，分别是等式约束和不等式约束

等式约束： $g_{eq}(W) = 0$

不等式约束： $g_{ineq}(w) \le 0$

虽然代价函数是标量函数，只能返回1个数字；但是约束是向量值，也就是可以定义任意数量的约束

W常代表决策向量，X常代表控制向量

有了代价函数，那就要尽可能的将代价降到最低。

设置优化问题是一个重要的工作

## 局部最优解
决策变量和成本函数构成的曲线，如图：

<div align="center">
    <img src="..\fig\局部最优.png">
    <br>
</div>

但是这两个点都可以称为局部最小值，只有低于所有可能最小值的解，才是全局最优解，例如第二个也可以被称为全局最优解

找到局部最小值的一个很好的方法就是，假设有一个成本函数，斜率为0，也就是向量 $w$ 的导数为0

Local minima are easier to find (with continuous/differentiable functions).

（对于连续 / 可导函数来说）局部极小值更容易求解。

$$
\frac{\partial f(w)}{\partial w}  = 0
$$

当 $w$ 为向量时，这个东西的名字为梯度，等于0的公式被称为一阶必要条件（First-order necessary condition）

但是这个条件成立，也可能是到达了最大值点，或者是到达了鞍点，因此这个条件虽然必须成立，但是并不足以判断曲线是否达到了局部最小值

这样就需要第二个条件

$$
 \frac{\partial^2f(w)}{\partial w^2}> 0
$$

这个被称为二阶充分条件（Second-order sufficiency condition）

## 梯度下降法
梯度的妙处在于，假设不直接求解，而是尝试迭代的去猜测它的值，假设某一个 $(w_1,w_2)$ 得到了最小值，然后去检查该点的梯度，然后沿着梯度下降，直到找到这个解，被称为梯度下降法

标量对向量的偏导数得到了梯度

## Hession矩阵

$$
\frac{\partial^2f(w)}{\partial w^2}
$$

被称为Hession矩阵，该矩阵一定是一个方阵，对称矩阵。

$$
 \frac{\partial^2f(w)}{\partial w^2}> 0
$$

上面的二阶充分条件并不意味着要让矩阵的所有值都是大于0的，而是all eigenvalues of the matrix have real numbers greater than zero，也就是，矩阵的所有特征值均为大于 0 的实数。

虽然在物理空间中不会考虑超过三维的问题，但是在优化中要考虑多维的问题

## 雅可比矩阵

一个向量对一个向量的导数，就是雅可比矩阵