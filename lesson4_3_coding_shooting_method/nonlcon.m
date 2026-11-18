function [g,geq] = nonlcon(w)
    % g is inequality <= 0
    % geq is equality = 0
    F_vec = w(1:end-1);
    g = -F_vec;

    T = w(end);
    % 等式约束
    tspan = [0 T];
    z0 = [0;1;0;1];

    dynamics = @(t,z) jetpackControlDynamics(t,z,w);
    [tout,zout] = ode45(dynamics,tspan,z0);

    xfinal = zout(end,1);
    yfinal = zout(end,3);
    dyfinal = zout(end,4);

    xtarget = 20;
    geq = [xfinal-xtarget;yfinal;dyfinal];
end

