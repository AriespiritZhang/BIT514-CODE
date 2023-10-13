%% 根据状态转移概率矩阵和收益函数，使用值迭代算法求解最优策略
load S.mat;
load A.mat;
load T.mat;
load reward.mat;
f=textread('Vulner.txt','%s');
%addpath('MDPtoolbox');
%------定义一些临时变量----------------------------------
gamma = 0.9;   % 折扣因子
epsi = 0.01;  %迭代终止条件
maxiter = 100;
%% -----------------
% 调用MDPtoolbox里的值迭代函数求解
%V0 = zeros(length(S),1);
%[policy, iter, cpu_time] = mdp_value_iteration(T, R, gamma, epsi, maxiter, V0);
%save('MDPresult.mat','policy','iter','cpu_time');
%% 值迭代函数求解
%------初始化值函数--------------------------------------
V = zeros(maxiter,length(S));   %initialize value function
P = -1*ones(100,length(S));
for s=1:length(S)
    [maxval,optAct] = maxValue(R,T,A,S,V(1,:),s,gamma);
    V(2,s) = maxval;
    P(2,s) = optAct;
end
%------迭代更新值函数V直到满足停止条件--------------------
t = 2;      %迭代计数器
while(max(abs( V(t,:)-V(t-1,:) )) > epsi)
    for s=1:length(S)
       [maxval,optAct] = maxValue(R,T,A,S,V(t,:),s,gamma);
       V(t+1,s) = maxval;
       P(t+1,s) = optAct;
    end
    t = t + 1
end

%---------------根据最优的值函数V计算出最优策略--------------
for s=1:length(S)
   for a=1:length(A)
        tempR = 0;
        for s1=1:length(S)
            tempR = tempR + T(s,s1,a)*V(s1);
        end
        val(a) = R(s,a) + gamma*tempR;
   end
   [maxV ind_A] = max(val);
   P1(s) = ind_A;    
end