function [g,geq] = nonlcon_dragrace(w)

% 最后移动到的地方
sfinal = 1;% final pos

g = [];

% s(Tf)和ds需要仿真才能得到，需要ODE45
% 这个simulate_drag_race就是函数
% 这里就是要进行shotting的地方，需要模拟问题，看看是否能到达终点
[sf,dsf] = simulate_drag_race(w);

% 需要对系统进行仿真，以便于了解系统是否满足了约束
geq = [sf - sfinal;dsf];