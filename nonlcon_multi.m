function [g,geq] = nonlcon_multi(w)

sfinal = 1;

g = [];

% Number of spline points
N = ((numel(w)-1)/3);
% One fewer shot than points
Nshots = N-1;

Tf = w(end);
time_vector = linspace(0,Tf,N);

% 2 states to check the defect for each shot
defect_constrains = zeros(Nshots*2,1);

% Loop through each of our shots and compare to the start of the next shot
for iter = 1:Nshots
    x0 = [w(N+iter);w(2*N+iter)];
    tspan = [time_vector(iter),time_vector(iter+1)];
    [sf,dsf] = simulate_multi(w,x0,tspan);
    snext = w(N+iter+1);
    dsnext = w(2*N+iter+1);


    defect_constrains(iter*2-1:2*iter) = [sf-snext;dsf-dsnext];
end

initial_condition_constraint = [w(N+1);w(2*N+1)];
final_condition_constraint = [w(2*N)-sfinal;w(3*N)];


geq = [defect_constrains;...
     initial_condition_constraint;...
     final_condition_constraint];
