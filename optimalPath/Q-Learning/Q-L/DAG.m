f=textread('Vulner.txt','%s');%读入捕获的漏洞信息
global k
k=1
z=1
while z<=length(f)
  for i=1:1:3
      Vulner(k,i)=f(z)
      z=z+1
  end
  k=k+1
end
[m,n]=size(Vulner)
for b=1:1:m
ve=cellstr(Vulner(b,3))
ve=ve{1}
yc=input(strcat(ve,'漏洞是否可远程执行(0/1):'))
id=input('漏洞是否需要身份认证(0/1):')
fz=input('漏洞攻击复杂度(0/1):')
pr=0
if yc==1&&id==1&&fz==1
    pr=0.5
end
if yc==1&&id==1&&fz==0
    pr=0.8
end
if yc==1&&id==0&&fz==1
    pr=0.6
end
if yc==1&&id==0&&fz==0
    pr=0.9
end
if yc==0&&id==1&&fz==1
    pr=0.3
end
if yc==0&&id==0&&fz==1
    pr=0.4
end
if yc==0&&id==1&&fz==0
    pr=0.5
end
VuMat(b,:)={ve,yc,id,fz,pr}
end
display(VuMat)

