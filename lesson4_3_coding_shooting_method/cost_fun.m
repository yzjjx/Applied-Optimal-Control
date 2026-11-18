function cost = cost_fun(w)
% input:决策向量decision vector
%[F1,F2,...FN,T]

    F_vec = w(1:end-1);
    T = w(end);
    N = numel(w)-1;
    dt = T/(N-1);

    % cost = sum(F_vec(1:end-1).^2)*dt; 
    cost = 0.5*F_vec(1)^2 + sum(F_vec(2:end-1).^2)*dt + 0.5*F_vec(end)^2;
end