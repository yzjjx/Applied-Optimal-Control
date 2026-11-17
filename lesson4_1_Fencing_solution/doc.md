# 最优化基础

Unconstrained optimization using iterative algorithms.

- Gradient Descent (1st-order methods)
- Newton Methods (2nd-order methods)

基于迭代算法的无约束优化

- 梯度下降（一阶方法）
- 牛顿法（二阶方法）

梯度下降法的公式为：

$$
w_{k+1}=w_k-\alpha\frac{\partial f(w_k)}{\partial w}
$$

其中， $w_k$ 是猜测的值， $\alpha$ 为步长，基本原理就是梯度越大，下一个猜测值就距离初始猜测值越远

Now we want to stop when the gradient near zero.

我们希望在梯度接近 0 时停止迭代。

$$
\left\|\frac{\partial f(w)}{\partial w}\right\| < 0.001
$$

梯度实际上产生的是一个行向量，但是 $w_{k+1}$ 和 $w_{k}$ 都是列向量

`lesson4_Fencing_solution\test_GradientDescent.m`这个代码可以简单的查看梯度下降法

## 梯度计算
在MATLAB中不需要每次手动计算符号的梯度，在MATLAB中可以使用符号工具箱

下面代码就可以对符号计算进行展开，`simplify()`就可以简化
```matlab
expand((x+y)^2)
```

让z关于x求导，例如 `diff(x^2,x)` 输出结果是 `2x`
```
diff(z,x)
```

使用符号工具箱可以查看代码`lesson4_Fencing_solution\test_Gradient_symbolic.m`

在解决优化问题的时候，很多时候并不在乎代价函数的最小值是什么，而是使函数f达到最小值的w值，也就是我们如何选择参数才能达到最小代价，这个值可以为 $w^*$ ,将这个值称为argmin，可以得到最优化通用公式：

$$
w^* = \arg\min_{w} f(w) \\
\text{s.t.} \quad g_{\text{eq}}(w) = 0 \\
\quad\quad g_{\text{ineq}}(w) \le 0
$$


At the optimal solution for constrained optimization problem, the cost gradient will be pointing perpendicularly to the constraint line.

在约束优化问题的最优解处，代价函数的梯度方向与约束线相互垂直。

对于带有等式约束的约束优化，我们可以使用成本函数的梯度信息及其与约束的关系，提出一个新的约束的一阶必要条件

$\frac{\partial \mathcal{L}}{\partial w} = \frac{\partial \big(f(w) + \lambda^\top g(w)\big)}{\partial w} = 0,\quad \mathcal{L} = f(w) + \lambda^\top g(w)
$

其中，L=代价函数加上lambda的转置乘以约束条件，被称为拉格朗日函数。 $\lambda$ 被称为拉格朗日乘数，可以看作是约束力，也就是说这个参数用来阻止梯度继续下降，也就是沿着约束条件的力阻止梯度继续下降，约束项产生的梯度 $\lambda^\top g(w)$ 对 $w$ 求导后，得到的约束作用方向垂直于约束线

$$
\begin{align*}
\frac{\partial \mathcal{L}}{\partial w} &= 0 \\
\frac{\partial \mathcal{L}}{\partial \lambda} &= 0
\end{align*}
$$

栅栏问题可以有公式：

$$
\begin{align*}
\mathcal{L}(w,\lambda) &= f(w) + \lambda^\top g(w) \\
w &= \begin{bmatrix} L \\ H \end{bmatrix}, \quad f(w) = -LH \\
g(w) &= 2L + 2H - 40
\end{align*}
$$

这里只有一个等式，因此lambda的数量为1

下面就需要找 $L,H,\lambda$ 使得 

$$
\begin{align*}
\frac{\partial \mathcal{L}}{\partial w} &= 0 \\
\frac{\partial \mathcal{L}}{\partial \lambda} &= 0
\end{align*}
$$

这里可以使用梯度下降法求解，目前的拉格朗日函数为：$\mathcal{L}(w,\lambda)  = -LH + \lambda(2L+2H-20)$

$$
\begin{align*}
\frac{\partial \mathcal{L}}{\partial w} &= \begin{bmatrix}
\frac{\partial \mathcal{L}}{\partial L} & \frac{\partial \mathcal{L}}{\partial H}
\end{bmatrix} \\[4pt]
\frac{\partial \mathcal{L}}{\partial L} &= -H + 2\lambda \\[4pt]
\frac{\partial \mathcal{L}}{\partial H} &= -L + 2\lambda
\end{align*}
$$

再加上另一个条件，可以列为：

$$
\begin{align*}
\frac{\partial \mathcal{L}}{\partial L} &= -H + 2\lambda = 0 \\
\frac{\partial \mathcal{L}}{\partial H} &= -L + 2\lambda = 0 \\
\frac{\partial \mathcal{L}}{\partial \lambda} &= 2L + 2H - 40 = 0
\end{align*}
$$

