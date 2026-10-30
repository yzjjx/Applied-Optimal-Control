function [g,geq] = nonlcon_dragrace(w)

sfinal = 1;

g = [];
% s(Tf)和ds需要仿真才能得到，需要ODE45
[sf,dsf] = simulate_drag_race(w);

geq = [sf - sfinal;dsf];