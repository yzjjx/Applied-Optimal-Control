function [dz] = jetpackDynamics(t,z)
    % 函数得到当前时间和状态，为什么这么做：因为ODE45函数要求
    % z = [x;dx;y;dy]
    m = 75;
    g = 9.81;
    F = 700;

    dz = zeros(4,1);
    dz(1) = z(2);
    dz(2) = 0;
    dz(3) = z(4);
    dz(4) = -g+F/m;
end