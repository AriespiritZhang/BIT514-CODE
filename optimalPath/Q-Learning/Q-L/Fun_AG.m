%function[prehost,vulner,tarhost,pr,pri]=Fun_AG()
load VuMat.mat
load Vulner.mat
m=1
b=2
dd=[]
alf=[]
prehost=[] %当前主机
tarhost=[] %目标主机 
vulner=[] %漏洞信息
pr=[] %攻击成功概率
pri=[] %权限（User/Root）
ping=[2,5,1;2,6,1;2,7,1;2,8,1;4,8,1;5,8,1;6,8,1] %可PING通矩阵
[l,j]=size(ping);
while b<length(VuMat)
    for i=2:1:length(Vulner)
        if Vulner{i,3}== VuMat{b,1}
            lad=VuMat{b,1}
            vulner{m}=lad 
            tarhost1=Vulner{i,1}           
            %zz=input('test:')
            if str2num(tarhost1)==2||str2num(tarhost1)==3||str2num(tarhost1)==4
                prehost1=1
                tarhost{m}=str2double(tarhost1) 
                prehost{m}=prehost1           
                pri(m)=round(2*rand)
                tt=VuMat{b,5}
                if pri(m)==0
                    pr(m)=tt 
                end
                pr1=tt*0.8               
                pr(m)=pr1
            end
            if str2num(tarhost1)==5||str2num(tarhost1)==6||str2num(tarhost1)==7||str2num(tarhost1)==8
                u=0
                for t=1:1:l      
                    dd{t}=ping(t,2)
                    ddd=str2double(tarhost1)
                    if ping(t,2)==str2double(tarhost1)     
                        u=u+1
                        alf{u}=ping(t,1)                        
                    end
                end
                    while u>0
                        prehost1=alf{u}
                        prehost{m}=prehost1                       
                        u=u-1
                        if u>0
                          m=m+1
                          vulner{m}=lad
                          tarhost{m}=ddd
                          pri(m)=round(2*rand)
                           if pri(m)==1
                              pr(m)=VuMat{b,5}
                           end
                           pr1=VuMat{b,5}*0.8
                           pr(m)=pr1
                        end
                    end
            end
          m=m+1
        end     
    end  
    b=b+1
end
for t=1:1:m-1
    if isempty(tarhost{1,t})==true
        tarhost{1,t}=prehost{1,t}+1
    end
end
for i=1:29
    phost(i)=prehost{i}(1)
    thost(i)=tarhost{i}(1)
end
Trans_P=[phost;thost;pr;pri]'
for ii=1:29
    if Trans_P(ii,3)==0
        Trans_P(ii,3)=(Trans_P(ii,1)+Trans_P(ii,2))/(7+3*rand)
    else
        Trans_P(ii,3)=Trans_P(ii,3)-(abs(Trans_P(ii,1)+Trans_P(ii,2)))/72
    end
    if ii==9||ii==13
        Trans_P(ii,1)=3
        Trans_P(ii,2)=4
    end
end
ix=1
for ui=1:29
    ind=ui
    if Trans_P(ind,1)==1
        ap=Trans_P(ind,3)
        n=1 
        ind1=ind
        while Trans_P(ind1,2)<8
       %while Trans_P(ind1,2)~=8||Trans_P(ind1,2)~=5&&Trans_P(ind1,4)~=2||Trans_P(ind1,2)~=5&&Trans_P(ind1,4)~=2||Trans_P(ind1,2)~=6&&Trans_P(ind1,4)~=2Trans_P(ind1,2)~=7&&Trans_P(ind1,4)~=2                        
           ind=find(Trans_P(:,1)==Trans_P(ind1,2))
           if length(ind)>1
               for i=1:length(ind)-1
                   if Trans_P(ind(i),3)<Trans_P(ind(i+1),3)
                       index=ind(i)
                   else
                       index=ind(i+1)
                   end
               end
           else
               index=ind
           end
           ind1=index
            ap=ap*Trans_P(ind1,3)
            at(ix,n)=Trans_P(ind1,1)
            n=n+1
        end
        atp(ix,:)={at,ap}
        ix=ix+1
    end
end
        
                
        
