function [T E] = NetworkState(Ss,St,a)
%Ss means the state of security on the target network
%St denotes the transport state on the target network
%a means the action which we choose

T_avg_sec = 2;  %the target network's average coefficient of security
T_trans = 4;  %the transmission speed between two network node
E_up_sec = 1.125;  %the consumption of upgrading a level of security
E_up_trans = 1;  %the cost of upgrading a level of network transmission rate

if(Ss>0) %the condition of target network's security is not danger
    T_tra =  T_trans*( (a==1) + (a==3));%the transmission speed level can be brought throw action a
    T_sec =  T_avg_sec*( (a==2) + (a==3));% the security can be arrived throw action a  
    %the transmission speed that can reach,actually
    T_tra_final = min( T_tra,min(Ss,floor(St/E_up_trans)) );  
     %考虑当a==2时，同时使用SEC和TRA，尽量使用TRA
    Sb1 = Ss - T_tra_final;
    Se1 = St - T_tra_final*E_up_trans;
    T_sec_final = min( T_sec,min(Sb1,floor(Se1/E_up_sec)) );  %the security between two network node can be arrived,actually
    
    T = T_sec_final + T_tra_final;
    E = T_sec_final*E_up_sec + T_tra_final*E_up_trans; %total consumption
else 
    T = 0;
    E = 0;
end

end