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

