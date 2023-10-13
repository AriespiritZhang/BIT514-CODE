function [prob prob_S prob_T b e]= transProb( Si,Sj,a)
%  we take use of the function to calculate transition matrix
% Input:
%     Si: state at time i£¬Si = {Ssi,Ti} is a cell of union state
%     Sj: state at time j
%     a:  action
%     Smax: capacity of security
%     Tmax: capacity of transimission rate
% Output:
%     prob:  probability of transition from Si to Sj with action a
global TB;
global Smax;
global Tmax;
global lambdaS ;
global lambdaT ;
% TB =100;
% Emax = 40;
% Bmax = 50;

Ssi = Si(1);
Sti = Si(2);
Ssj = Sj(1);
Stj = Sj(2);

[T E] = NetworkState(Ssi,Sti,a);
b = Ssj - Ssi + T;
e = Stj - Sti + E;
b = ceil(b);
e = ceil(e);

%% calculate poisson probability
if(b>=0)
    if(Ssj<(Smax-1))
       prob_S = exp(-lambdaS*TB)*(lambdaS*TB)^(b)/factorial(b);
    else
       kb=0:b-1;
       temp = exp(-lambdaS*TB)*(lambdaS*TB).^(kb)./factorial(kb); 
       prob_S = 1-sum(temp);
    end
else
    prob_S = 0;
end
if(e>=0)
    if(Stj<(Tmax-1))
       prob_T = exp(-lambdaT*TB)*(lambdaT*TB)^(e)/factorial(e);
    else
       ke=0:e-1;
       temp = exp(-lambdaT*TB)*(lambdaT*TB).^(ke)./factorial(ke); 
       prob_T = 1-sum(temp);
    end
else 
    prob_T = 0;
end

prob = prob_S*prob_T;

end