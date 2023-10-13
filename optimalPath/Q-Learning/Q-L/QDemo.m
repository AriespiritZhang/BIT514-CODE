clear all; 
clc
load reward.mat
Rew=R;;    % rewards
task=struct('initialState',[1,1],'terminalState',[10,6]); % task
robot=struct('alpha',1,'gamma',1,'Qtable',zeros(400,4),'best',[],'state',[1,1]);
robot=Qlearning(robot,task,Rew,200);

disp('前驱状态 | 动作 | 后继状态')
for l=1:size(robot.best,1)
    s0=robot.best(l,[1,2]);
    a=robot.best(l,3);
    s=robot.best(l,[4,5]);
    disp([num2str(s0),'  |  ',num2str(a),'  |  ',num2str(s)]);
end