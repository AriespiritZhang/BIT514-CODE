
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q learning of single agent move in N rooms 
% Matlab Code companion of 
% Q Learning by Example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ǿѧϰ��Q-learning��Ҫ����������������⣺һ���ܸ�֪����������agent������ͨ��ѧϰѡ���ܴﵽ��Ŀ������Ŷ�����
% ����ܾ����ձ��Ե�����Ӧ����ѧϰ�����ƶ������ˣ��ڹ�����ѧϰ���Ų��������Լ�ѧϰ������ȵȡ���agent���价��������ÿ������ʱ��ʩ���߻��ṩ������ͷ���Ϣ��
% �Ա�ʾ���״̬����ȷ���
% ���磬��ѵ��agent�����������ʱ��ʩ���߿�����Ϸʤ��ʱ�������ر���������Ϸʧ��ʱ�������ر�������ʱ��Ϊ��ر��� 
% agent��������Ǵ������ֱ�ӵģ����ӳٵĻر���ѧϰ���Ա�����Ķ������������ۻ�ЧӦ������
% Qѧϰ�㷨��ȷ���Իر��Ͷ����ٶ��µ�Qѧϰ�㷨������
% s��ʾ״̬��a��ʾ������Q��s��a����ʾ��״̬s�¶���a�õ�������ر���һ�����ƣ�rΪ�˶����������ر�.����
% 1����ÿ��s��a��ʼ������Q��s��a��Ϊ0 ����
% 2���۲쵱ǰ״̬s ����
% 3��һֱ�ظ���������
%     ѡ��һ������a��ִ�������ö���ΪʹQ��s��a������a�� �������յ������ر�r�� �����۲���״̬s'������
%     ��Q��s'��a'��������ʽ���±�� ����Q��s��a��=r+gama * max Q ��s'��a'���� ����s=s'�� 
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

    q=zeros(size(R));      % initialize Q as zero,q���������������ھ���R�ġ�
    q1=ones(size(R))*inf;  % initialize previous Q as big number
    count=0;               % counter

    for episode=0:50000
       % random initial state
       y=randperm(size(R,1));      %����1��6������� %a=size(R,1)�Ѿ���R���������ظ�a,b=size(R,2)�Ѿ���R���������ظ�b
       state=y(1);                 %ȡ1��6��������ĵ�һ����
       
       % select any action from this state
       x=find(R(state,:)>=0);        % find possible action of this state.���ؾ���R��state���������в�С��������ݵ��±�
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
      