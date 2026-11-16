clc;clear;close all;

% 定义初始猜测值
w0 = 6;

wk = w0;
% 调整初始值或者调整alpha步长都可以加快迭代次数
% 但是alpha的值也不能很大
alpha = 0.1;

threshold = 0.01;

done = false;
iter = 0;

while ~done
    iter = iter+1;
    wk = wk-alpha*(2*wk-20)
    if(abs(2*wk-20)<threshold)
        done = true;
    end
end