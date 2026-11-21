% input:decision vector w = [F1...FN,S1...SN,DS1...DSN,T]
% output:[g,geq]
function [g,geq] = nonlcon(w)
    m = 1;
    Fmin = -10;
    Fmax = 10;
    s_target = 5;
    
    T = w(end);
    N = (numel(w)-1)/3;
    F = w(1:N);
    s = w(N+1:2*N);
    ds = w(2*N+1:3*N);

    g = [-T;-F+Fmin;F-Fmax];

    % 不等式约束
    geq_ic = [s(1);ds(1)];
    geq_fc = [s(N)-s_target;ds(N)];

    % 缺陷约束
    dt = T/(N-1);
    geq_s_defect = (s(2:N)-s(1:N-1))/dt-ds(1:N-1);
    geq_ds_defect = (ds(2:N)-ds(1:N-1))/dt-F(1:N-1)/m;
    
    geq =[geq_ic;geq_fc;geq_s_defect;geq_ds_defect];
end