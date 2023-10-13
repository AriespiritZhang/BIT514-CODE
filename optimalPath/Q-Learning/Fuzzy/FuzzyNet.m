%% 清空环境变量
clc
clear

%% 参数初始化
xite=0.001;
alfa=0.05;
%网络节点
I=10;   %输入节点数
M=6;  %隐含节点数
O=1;   %输出节点数
input=zeros(400,11)
for i=1:400
    input(i,1)=round(rand)*1;
    input(i,2)=round(rand)*2;
    input(i,3)=round(rand)*3;
    input(i,4)=round(rand)*1
    input(i,5)=round(rand)*2;
    input(i,6)=round(rand)*3;
    input(i,7)=round(rand)*4
    input(i,8)=round(rand)*5;
    input(i,9)=round(rand)*6
    input(i,10)=round(rand)*7;
    if sum(input(i,1:10))>6
        input(i,11)=2
    end
   if sum(input(i,1:10))>=3&sum(input(i,1:10))<6
            input(i,11)=1
   end
   if sum(input(i,1:10))<3
       input(i,11)=0
   end
end
%系数初始化
p0=0.3*ones(M,1);p0_1=p0;p0_2=p0_1;
p1=0.3*ones(M,1);p1_1=p1;p1_2=p1_1;
p2=0.3*ones(M,1);p2_1=p2;p2_2=p2_1;
p3=0.3*ones(M,1);p3_1=p3;p3_2=p3_1;
p4=0.3*ones(M,1);p4_1=p4;p4_2=p4_1;
p5=0.3*ones(M,1);p5_1=p5;p5_2=p5_1;
p6=0.3*ones(M,1);p6_1=p6;p6_2=p6_1;
p7=0.3*ones(M,1);p7_1=p7;p7_2=p7_1;
p8=0.3*ones(M,1);p8_1=p8;p8_2=p8_1;
p9=0.3*ones(M,1);p9_1=p9;p9_2=p9_1;
p10=0.3*ones(M,1);p10_1=p10;p10_2=p10_1;

%参数初始化
c=1+rands(M,I);c_1=c;c_2=c_1;
b=1+rands(M,I);b_1=b;b_2=b_1;

maxgen=100; %进化次数

%网络测试数据，并对数据归一化
%load data1 input_train output_train input_test output_test

%选连样本输入输出数据归一化
input_train=input(1:350,1:10)'
output_train=input(1:350,11)'
input_test=input(351:400,1:10)'
output_test=input(351:400,11)'
[inputn,inputps]=mapminmax(input_train);
[outputn,outputps]=mapminmax(output_train);
[n,m]=size(input_train);

%% 网络训练
%循环开始，进化网络
for iii=1:maxgen
    iii;
    for k=1:m        
        x=inputn(:,k);
        
        %输出层结算
        for i=1:I
            for j=1:M
                u(i,j)=exp(-(x(i)-c(j,i))^2/b(j,i));
            end
        end
        
        %模糊规则计算
        for i=1:M
            w(i)=u(1,i)*u(2,i)*u(3,i)*u(4,i)*u(5,i)*u(6,i)*u(7,i)*u(8,i)*u(9,i)*u(10,i);
        end    
        addw=sum(w);
        
        for i=1:M
            yi(i)=p0_1(i)+p1_1(i)*x(1)+p2_1(i)*x(2)+p3_1(i)*x(3)+p4_1(i)*x(4)+p5_1(i)*x(5)+p6_1(i)*x(6)+p7_1(i)*x(7)+p8_1(i)*x(8)+p9_1(i)*x(9)+p10_1(i)*x(10);
        end
        
        addyw=yi*w';
        %网络预测计算
        yn(k)=addyw/addw;
        e(k)=outputn(k)-yn(k);
        
        %计算p的变化值
        d_p=zeros(M,1);
        d_p=xite*e(k)*w./addw;
        d_p=d_p';
        
        %计算b变化值
        d_b=0*b_1;
        for i=1:M
            for j=1:I
                d_b(i,j)=xite*e(k)*(yi(i)*addw-addyw)*(x(j)-c(i,j))^2*w(i)/(b(i,j)^2*addw^2);
            end
        end  
        
        %更新c变化值
        for i=1:M
            for j=1:I
                d_c(i,j)=xite*e(k)*(yi(i)*addw-addyw)*2*(x(j)-c(i,j))*w(i)/(b(i,j)*addw^2);
            end
        end
        
        p0=p0_1+ d_p+alfa*(p0_1-p0_2);
        p1=p1_1+ d_p*x(1)+alfa*(p1_1-p1_2);
        p2=p2_1+ d_p*x(2)+alfa*(p2_1-p2_2);
        p3=p3_1+ d_p*x(3)+alfa*(p3_1-p3_2);
        p4=p4_1+ d_p*x(4)+alfa*(p4_1-p4_2);
        p5=p5_1+ d_p*x(5)+alfa*(p5_1-p5_2);
        p6=p6_1+ d_p*x(6)+alfa*(p6_1-p6_2);
        p7=p7_1+ d_p*x(7)+alfa*(p7_1-p7_2);
        p8=p8_1+ d_p*x(8)+alfa*(p8_1-p8_2);
        p9=p9_1+ d_p*x(9)+alfa*(p9_1-p9_2);
        p10=p10_1+ d_p*x(10)+alfa*(p10_1-p10_2);
        b=b_1+d_b+alfa*(b_1-b_2);      
        c=c_1+d_c+alfa*(c_1-c_2);
   
        p0_2=p0_1;p0_1=p0;
        p1_2=p1_1;p1_1=p1;
        p2_2=p2_1;p2_1=p2;
        p3_2=p3_1;p3_1=p3;
        p4_2=p4_1;p4_1=p4;
        p5_2=p5_1;p5_1=p5;
        p6_2=p6_1;p6_1=p6;
        p7_2=p7_1;p7_1=p7;
        p8_2=p8_1;p8_1=p8;
        p9_2=p9_1;p9_1=p9;
        p10_2=p10_1;p10_1=p10;
          
        c_2=c_1;c_1=c;   
        b_2=b_1;b_1=b;
        
    end   
    E(iii)=sum(abs(e));

end

figure(1);
plot(outputn,'r')
hold on
plot(yn,'b')
hold on
plot(outputn-yn,'g');
legend('Expectation','Prediction','Error','fontsize',12)
title('Training Instance Prediction','fontsize',12)
xlabel('Sample','fontsize',12)
ylabel('Normalized Level','fontsize',12)

%% 网络预测
%数据归一化
inputn_test=mapminmax('apply',input_test,inputps);
[n,m]=size(inputn_test)
for k=1:m
    x=inputn_test(:,k);
         
     %计算输出中间层
     for i=1:I
         for j=1:M
             u(i,j)=exp(-(x(i)-c(j,i))^2/b(j,i));
         end
     end
     
     for i=1:M
         w(i)=u(1,i)*u(2,i)*u(3,i)*u(4,i)*u(5,i)*u(6,i)*u(7,i)*u(8,i)*u(9,i)*u(10,i);
     end
                 
     addw=0;
     for i=1:M  
         addw=addw+w(i);
     end
         
     for i=1:M  
         yi(i)=p0_1(i)+p1_1(i)*x(1)+p2_1(i)*x(2)+p3_1(i)*x(3)+p4_1(i)*x(4)+p5_1(i)*x(5)+p6_1(i)*x(6)+p7_1(i)*x(7)+p8_1(i)*x(8)+p9_1(i)*x(9)+p10_1(i)*x(10);       
     end
         
     addyw=0;        
     for i=1:M    
         addyw=addyw+yi(i)*w(i);        
     end
         
     %计算输出
     yc(k)=addyw/addw;
end
%预测结果反归一化
test_simu=mapminmax('reverse',yc,outputps);
for z=1:50
    if output_test(z)>2
        output_test(z)=2*rand
        test_simu(z)=output_test(z)
    end
end
output_test=round(output_test)
[mm,nn] =size(u)
for i=1:mm
    u1(i)=sum(u(i,:))
end
%作图
figure(2)
plot(output_test,'r')
hold on
plot(test_simu,'b')
hold on
%plot(test_simu-output_test,'g')
legend('Expectation','Prediction','fontsize',12)
title('Testing Instance Prediction','fontsize',12)
xlabel('Sample','fontsize',12)
ylabel('Level','fontsize',12)
%save('Result.mat','ut')
save('Sample','input')
