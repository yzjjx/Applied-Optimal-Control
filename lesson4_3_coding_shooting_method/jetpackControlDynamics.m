function [dz] = jetpackControlDynamics(t,z,w)
% Dynamics function that has the feedforward controller
% Inputs: current time, current state vector, ....
% the decision vector: [F1, F2, .... FN, T]'
% Outputs: Derivatives of our states
    m = 75;
    g = 9.81;
    
    T = w(end);
    N = numel(w) - 1;
    t_points = linspace(0,T,N);
    F_points = w(1:end-1);
    F = interp1(t_points,F_points,t);

    dz = zeros(4,1);
    dz(1) = z(2);
    dz(2) = 0;
    dz(3) = z(4);
    dz(4) = -g + F/m;

end