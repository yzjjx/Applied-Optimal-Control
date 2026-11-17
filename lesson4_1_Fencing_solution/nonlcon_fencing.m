function [g,geq] = nonlcon_fencing(w)

% 分别返回等式约束和不等式约束
% 为决策向量

L = w(1);
H = w(2);

g = 2*L+2*H-40;
geq = [];