clc;clear;close all;

syms H

f = H^2-20*H;
df_dH = diff(f,H);
% 创建一个函数句柄
my_grandient = matlabFunction(df_dH);

w0 = 6;
wk = w0;
iter = 0;
alpha = 0.3;

threshold = 0.01;

done = false;

while ~done
    iter = iter+1;
    wk = wk-alpha*my_grandient(wk);
    if(abs(my_grandient(wk))<threshold)
        done = true;
    end
end