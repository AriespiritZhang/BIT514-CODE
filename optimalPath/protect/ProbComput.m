%% 计算状态转移概率矩阵和收益函数
clear all
clc
%--------定义全局变量------------------------------------------
global TB;
global Tmax;
global Smax;
global lambdaS;
global lambdaT;
%------------一些局部变量--------------------------------------
lambdaS = 0.01;
lambdaT = 0.02;
TB = 20;
Smax = 3;
Tmax = 4;
%--------------定义联合状态数据结构---------------------------------
Ss = linspace(0,Smax-1,Smax); %security state
T = linspace(0,Tmax-1,Tmax); %transport state
S = {};
ind_S = 1;
for s =0:Smax-1
    for t=0:Tmax-1
        S{ind_S} = [s,t];
        ind_S = ind_S + 1;
    end
end

A = [1,2,3,4]; % set of actions 

%-------------------计算状态转移概率矩阵-----------------------------
ind =0;
Twait = waitbar(0,'计算状态转移概率矩阵进度');
for a = 1:length(A)
    for si=1:length(S)
        for sj=1:length(S)
            [prob prob_S prob_T s t] = transProb(S{si},S{sj},A(a));  % transmission probability
            T_S(si,sj,a) = prob_S;
            T_T(si,sj,a) = prob_T;
            T1(si,sj,a) =  prob;
            Ss(si,sj,a) = s;
            T(si,sj,a) = t;
            
            [si,sj,a]   
            ind = ind +1;
            str = ['已完成' num2str(floor(ind*100/(length(A)*length(S)*length(S)))) '%'];
            waitbar(ind/(length(A)*length(S)*length(S)),Twait,str);
        end
        
    end
end
close(Twait);

%-----------------------计算收益函数矩阵-------------------------------------------
Rwait = waitbar(0,'计算收益矩阵进度');
ind = 0;
for a = 1:length(A)
    for s=1:length(S)
        R(s,a) = reward(S{s},A(a));
        [s,a]
        ind = ind +1;
        str = ['已完成' num2str(floor(ind*100/(length(A)*length(S)))) '%'];
        waitbar(ind/(length(A)*length(S)),Rwait,str); 
    end
end     
close(Rwait);

%----------------保存得到的概率转移矩阵和收益函数矩阵--------------------------------
save('T.mat','T');
save('S.mat','S');
save('A.mat','A');
save('reward.mat','R');












