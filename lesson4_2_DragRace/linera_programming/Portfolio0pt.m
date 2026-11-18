clc;clear;close all;

Aprice = 100;
Bprice = 50;
Cprice = 80;
Dprice = 40;

T = 200000;

Ann_return = 0.09;

% 年度回报率
Areturn = 0.12;
Breturn = 0.08;
Creturn = 0.06;
Dreturn = 0.10;

% Risk Measure per Dollar
Arisk = 0.1;
Brisk = 0.07;
Crisk = 0.05;
Drisk = 0.08;

% 使用符号表达式，获得梯度、雅可比矩阵和决策向量、b
syms A B C D

w = [A;B;C;D];

% 代价函数
f = A*Aprice*Arisk + B*Bprice*Brisk + C*Cprice*Crisk + D*Dprice*Drisk;

% 计算梯度
c = gradient(f,w);
c = double(c);
% 不等式
g = [A*Aprice-1/2*T;B*Bprice-1/2*T;C*Cprice-1/2*T;D*Dprice-1/2*T;Ann_return - A*Aprice*Areturn - B*Bprice*Breturn - C*Cprice*Creturn - D*Dprice*Dreturn];

% 计算雅可比矩阵
Aineq = jacobian(g,w);
Aineq = double(Aineq);

% g表示公式，w表示替换的符号
bineq = subs(g,w,zeros(4,1));
bineq = -1*bineq;
bineq = double(bineq);


geq = A*Aprice+B*Bprice+C*Cprice+D*Dprice-T;

% 计算雅可比矩阵
Aeq = jacobian(geq,w);
Aeq = double(Aeq);

% g表示公式，w表示替换的符号
beq = subs(geq,w,zeros(4,1));
beq = -1*beq;
beq = double(beq);

lb = [0;0;0;0];
ub = [inf;inf;inf;inf];

wstar = linprog(c,Aineq,bineq,Aeq,beq,lb,ub)