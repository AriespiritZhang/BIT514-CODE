%% ����״̬ת�Ƹ��ʾ�������溯����ʹ��ֵ�����㷨������Ų���
load S.mat;
load A.mat;
load T.mat;
load reward.mat;
f=textread('Vulner.txt','%s');
%addpath('MDPtoolbox');
%------����һЩ��ʱ����----------------------------------
gamma = 0.9;   % �ۿ�����
epsi = 0.01;  %������ֹ����
maxiter = 100;
%% -----------------
% ����MDPtoolbox���ֵ�����������
%V0 = zeros(length(S),1);
%[policy, iter, cpu_time] = mdp_value_iteration(T, R, gamma, epsi, maxiter, V0);
%save('MDPresult.mat','policy','iter','cpu_time');
%% ֵ�����������
%------��ʼ��ֵ����--------------------------------------
V = zeros(maxiter,length(S));   %initialize value function
P = -1*ones(100,length(S));
for s=1:length(S)
    [maxval,optAct] = maxValue(R,T,A,S,V(1,:),s,gamma);
    V(2,s) = maxval;
    P(2,s) = optAct;
end
%------��������ֵ����Vֱ������ֹͣ����--------------------
t = 2;      %����������
while(max(abs( V(t,:)-V(t-1,:) )) > epsi)
    for s=1:length(S)
       [maxval,optAct] = maxValue(R,T,A,S,V(t,:),s,gamma);
       V(t+1,s) = maxval;
       P(t+1,s) = optAct;
    end
    t = t + 1
end

%---------------�������ŵ�ֵ����V��������Ų���--------------
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