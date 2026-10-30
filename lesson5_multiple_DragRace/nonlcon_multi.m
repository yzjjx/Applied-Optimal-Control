function [g,geq] = nonlcon_multi(w)
% 决策向量的下一个状态与仿真结果的差异必须为0

sfinal = 1;

% 没有线性不等式约束
g = [];

% Number of spline points
N = ((numel(w)-1)/3);
% One fewer shot than points
Nshots = N-1;

Tf = w(end);
time_vector = linspace(0,Tf,N);

% 2 states to check the defect for each shot
% 缺陷约束
defect_constrains = zeros(Nshots*2,1);

% 将每一个射击状态与下一个射击开始比较
% Loop through each of our shots and compare to the start of the next shot
for iter = 1:Nshots
    % initial state for this shot
    % 就是从w里面找到s1、s2和ds1、ds2等
    x0 = [w(N+iter);w(2*N+iter)];
    % time span of this particular shot
    tspan = [time_vector(iter),time_vector(iter+1)];
    % 不是要运行单个仿真，而是需要多个仿真，返回每段射击的最终状态
    [sf,dsf] = simulate_multi(w,x0,tspan);
    % 需要将上面的状态跟下一个初始状态相比较
    snext = w(N+iter+1);
    dsnext = w(2*N+iter+1);

    % 缺陷限制条件，需要第一个缺陷，就需要计算s2和s3；需要第二个缺陷，就需要s3和s4
    % 左边表示缺陷的1到2，3到4；前两个元素，第二个两个元素，第三个两个元素
    % 将每一个缺陷约束条件添加到一个向量里面
    % Place each defect constrain in a vector
    defect_constrains(iter*2-1:2*iter) = [sf-snext;dsf-dsnext];
end

% 初始状态约束
initial_condition_constraint = [w(N+1);w(2*N+1)];
% 最终状态约束
final_condition_constraint = [w(2*N)-sfinal;w(3*N)];

% 将所有的等式约束放在一个大向量里面
geq = [defect_constrains;...
     initial_condition_constraint;...
     final_condition_constraint];
