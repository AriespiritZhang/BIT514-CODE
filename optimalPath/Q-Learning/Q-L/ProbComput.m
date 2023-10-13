%% ����״̬ת�Ƹ��ʾ�������溯��
clear all
clc
%--------����ȫ�ֱ���------------------------------------------
global TB;
global Tmax;
global Smax;
global lambdaS;
global lambdaT;
%------------һЩ�ֲ�����--------------------------------------
lambdaS = 0.01;
lambdaT = 0.02;
TB = 20;
Smax = 3;
Tmax = 4;
%--------------��������״̬���ݽṹ---------------------------------
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

%-------------------����״̬ת�Ƹ��ʾ���-----------------------------
ind =0;
Twait = waitbar(0,'����״̬ת�Ƹ��ʾ������');
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
            str = ['�����' num2str(floor(ind*100/(length(A)*length(S)*length(S)))) '%'];
            waitbar(ind/(length(A)*length(S)*length(S)),Twait,str);
        end
        
    end
end
close(Twait);

%-----------------------�������溯������-------------------------------------------
Rwait = waitbar(0,'��������������');
ind = 0;
for a = 1:length(A)
    for s=1:length(S)
        R(s,a) = reward(S{s},A(a));
        [s,a]
        ind = ind +1;
        str = ['�����' num2str(floor(ind*100/(length(A)*length(S)))) '%'];
        waitbar(ind/(length(A)*length(S)),Rwait,str); 
    end
end     
close(Rwait);

%----------------����õ��ĸ���ת�ƾ�������溯������--------------------------------
save('T.mat','T');
save('S.mat','S');
save('A.mat','A');
save('reward.mat','R');












