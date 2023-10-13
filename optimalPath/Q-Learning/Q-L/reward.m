function r = reward(S,a)
% to calculate reward for transmission from state Si to Sj with action a 
% Input:
%     S: state
%     a: action
% Output:
%     r: reward
global Tmax;
global lambdaS;% parameter of calculating the reward of transmission rate
global TB;%parameter of calculating the reward of transmission rate
% Emax = 256;  
%can be ensured by the highest possible consumption,
%Or can be ensured by simulation experiment

Ss = S(1);
St = S(2);
[T E] = NetworkState(Ss,St,a);
r = T/(lambdaS*TB) - E/Tmax;

end