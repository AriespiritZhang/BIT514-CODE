
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q learning of single agent move in N rooms 
% Matlab Code companion of 
% Q Learning by Example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 增强学习（Q-learning）要解决的是这样的问题：一个能感知环境的自治agent，怎样通过学习选择能达到其目标的最优动作。
% 这个很具有普遍性的问题应用于学习控制移动机器人，在工厂中学习最优操作工序以及学习棋类对奕等。当agent在其环境中做出每个动作时，施教者会提供奖励或惩罚信息，
% 以表示结果状态的正确与否。
% 例如，在训练agent进行棋类对奕时，施教者可在游戏胜利时给出正回报，而在游戏失败时给出负回报，其他时候为零回报。 
% agent的任务就是从这个非直接的，有延迟的回报中学习，以便后续的动作产生最大的累积效应。　　
% Q学习算法在确定性回报和动作假定下的Q学习算法：　　
% s表示状态，a表示动作，Q（s，a）表示对状态s下动作a得到的总体回报的一个估计，r为此动作的立即回报.　　
% 1、对每个s，a初始化表项Q（s，a）为0 　　
% 2、观察当前状态s 　　
% 3、一直重复做：　　
%     选择一个动作a并执行它，该动作为使Q（s，a）最大的a。 　　接收到立即回报r。 　　观察新状态s'。　　
%     对Q（s'，a'）按照下式更新表项： 　　Q（s，a）=r+gama * max Q （s'，a'）。 　　s=s'。 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I have made simple Matlab Code below for this tutorial example and you can modify it for your need. 
% You can copy and paste the two functions into separate text files and run it as ReinforcementLearning. 
% To model the environment you need to make the instant reward matrix R. 
% Put zero for any door that is not directly to the goal and put value 100 to the door that lead directly to the goal. 
% For unconnected states, use minus Infinity (-Inf) so that it become very negative number. 
% We want to maximize the Q values, thus very negative number will not be considered at all. 
% The state is numbered 1 to N (in our previous example N = 6). 
% The result of the code is only normalized Q matrix.
% You may experiment in the effect of parameter gamma to see how it influences the results.
% by Kardi Teknomo 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


% Two input: R and gamma
% immediate reward matrix; 
% row and column = states and actions; -Inf = no door between room
    R=[-inf,-inf,-inf,-inf,   0, -inf;
       -inf,-inf,-inf,   0,-inf, 100;
       -inf,-inf,-inf,   0,-inf, -inf;
       -inf,   0,   0,-inf,   0, -inf;
          0,-inf,-inf,   0,-inf, 100;
       -inf,   0,-inf,-inf,   0, 100];
   

    gamma=0.80;            % learning parameter

    q=zeros(size(R));      % initialize Q as zero,q的行数和列数等于矩阵R的。
    q1=ones(size(R))*inf;  % initialize previous Q as big number
    count=0;               % counter

    for episode=0:50000
       % random initial state
       y=randperm(size(R,1));      %产生1到6的随机数 %a=size(R,1)把矩阵R的行数返回给a,b=size(R,2)把矩阵R的列数返回给b
       state=y(1);                 %取1到6的随机数的第一个数
       
       % select any action from this state
       x=find(R(state,:)>=0);        % find possible action of this state.返回矩阵R第state行所有列中不小于零的数据的下标
       if size(x,1)>0
          z=round(rand(size(x)))         
          x1=x(z);                  % select an action 
       end
       qMax=max(q,[],2);
       q(state,x1)= R(state,x1)+gamma*qMax(x1);   % get max of all actions 
       %state=x1;
       
       % break if convergence: small deviation on q for 1000 consecutive
       if sum(sum(abs(q1-q)))<0.0001 & sum(sum(q >0))
          if count>1000,
             episode        % report last episode
             break          % for
          else
             count=count+1; % set counter if deviation of q is small
          end
       else
          q1=q;
          count=0;           % reset counter when deviation of q from previous q is large
       end
       q
    end 

    %normalize q
    g=max(max(q));
    if g>0, 
       q=100*q/g;
    end
      