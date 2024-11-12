
function f = youhuahanshu(x, M, V)%%计算每个个体的M个目标函数值

tic;
%         关节角 连杆偏距 连杆长度 连杆转角   

%基座模块
Basic=Link([0     0      0      0      0 ],'modified');

%T关节模块
T(1)=Link([0      0      0      pi/2    0],'modified');%坐标系预置关节，不可设置关节变量
T(2)=Link([0      0.97   0      pi/2    0],'modified');
T(3)=Link([0      0      0      pi/2    0],'modified');
T(4)=Link([0      0.27   0      0       0],'modified');%标准化关节，不可设置关节变量
T(1).offset=pi/2;

%转动关节模块
R(1)=Link([0      0      0.37   pi/2   0 ],'modified');
R(2)=Link([0      0      0.37   -pi/2  0 ],'modified');%标准化关节，不可设置关节变量

%连杆模块
I=Link([0 0 1 0 0],'modified');

%定义关节角限制
a=zeros(1,2);
Basic.qlim=[0,0.001]/180*pi;
T(1).qlim=[0,0.001]/180*pi;
T(2).qlim=[0,90]/180*pi;
T(3).qlim=[0,90]/180*pi;
T(4).qlim=[0,0.0001]/180*pi;
R(1).qlim=[0,90]/180*pi;
R(2).qlim=[0,0.0001]/180*pi;
I.qlim=[0,0.0001]/180*pi;

q=[];                                         %随机生成构型
j=1;
position=2;
q(1).qlim=[0,0.001]/180*pi;
for i=1:2:6
    if (x(i)&&(x(i+1)))||((x(i)==0)&&x(i+1))         %[1 1]或[0 1]代码为T模块
        moduler1(j:j+3)=T(1:4);
        q(position).qlim=[0,0.001]/180*pi;           %确定模块角度参数
        q(position+1).qlim=[0,90]/180*pi;
        q(position+2).qlim=[0,90]/180*pi;
        q(position+3).qlim=[0,0.0001]/180*pi;
        position=position+4;
        j=j+4;
    elseif (x(i)==0)&&(x(i+1)==0)                    %[0 0]代码为R模块
        moduler1(j:j+1)=R(1:2);
        q(position).qlim=[0,90]/180*pi;              %确定模块角度参数
        q(position+1).qlim=[0,0.0001]/180*pi;
        position=position+2;
        j=j+2;
    else moduler1(j)=I;                              %[1 0]代码为I模块
        q(position).qlim=[0,0.0001]/180*pi;
        position=position+1;
        j=j+1;    
    end
   
end
moduler=SerialLink([Basic moduler1  ],'name','moduler1');
%末端轨迹绘制
% joint = zeros(1000,7);
% joint(: , 1) = linspace(0,pi/2000,1000);
% joint(: , 2) = linspace(0,pi/2000,1000);
% joint(: , 3) = linspace(-pi/2,pi/2,1000);
% joint(: , 4) = linspace(0,pi/2000,1000);
% joint(: , 5) = linspace(-pi/2,pi/2,1000);
% joint(: , 6) = linspace(-pi/2,pi/2,1000);
% joint(: , 7) = linspace(0,pi/2000,1000);
% moduler.plot(joint,'jointdiam',0.5,'fps',100,'trail','r-')
% hold on;
% maniability=moduler.maniplty(joint);
% max(moduler.maniplty(joint))


num=30000;                                              %工作空间与全局最大可操作度计算
P=zeros(num,3);
Manu=zeros(num,10);
qtmax=zeros(1,7);
qrmax=zeros(1,7);
for i =1:num
    
    q1=Basic.qlim(1)+rand*(  Basic.qlim(2) - Basic.qlim(1)  );
    q2=q(2).qlim(1)+rand*(  q(2).qlim(2) - q(2).qlim(1)  );
    q3=q(3).qlim(1)+rand*(  q(3).qlim(2) - q(3).qlim(1)  );
    q4=q(4).qlim(1)+rand*(  q(4).qlim(2) - q(4).qlim(1)  );
    q5=q(5).qlim(1)+rand*(  q(5).qlim(2) - q(5).qlim(1)  );
    q6=q(6).qlim(1)+rand*(  q(6).qlim(2) - q(6).qlim(1)  );
    q7=q(7).qlim(1)+rand*(  q(7).qlim(2) - q(7).qlim(1)  );
    q8=q(8).qlim(1)+rand*(  q(8).qlim(2) - q(8).qlim(1)  );
    
    q_true=[q1 q2 q3 q4 q5 q6 q7 q8];
    Q=moduler.fkine(q_true);
    P(i,:)=transl(Q);
    Manu(i,1:8)=q_true;
    Manu(i,9)=moduler.maniplty(q_true);
    Manu(i,10)=moduler.maniplty(q_true,'rot');
    
end

plot3(P(:,1),P(:,2),P(:,3),'b.','markersize',1);        %绘制工作空间
mby_t=max(Manu(:,9));                                   %寻找全局最大可操作度
mby_r=max(Manu(:,10));
[row_t,col_t]=find(mby_t==Manu);                        %寻找最大可操作度对应关节角
[row_r,col_r]=find(mby_r==Manu);
qtmax=Manu(row_t,1:8);
qrmax=Manu(row_r,1:8);
disp(['全局最大可操作度: ',num2str(mby_t),'  ',num2str(mby_r), newline,'最佳T姿态角',num2str(qtmax/pi*180),newline,'最佳R姿态角',num2str(qrmax/pi*180)]);

figure
J_best=moduler.jacob0(qtmax);
plot_ellipse(J_best(1:3,:)*J_best(1:3,:)')              %线速度可操作性椭球
xlabel('x');ylabel('y');zlabel('z')

figure                                                  %角速度可操作性椭球
plot_ellipse( J_best(4:6,:)*J_best(4:6,:)' )
xlabel('x');ylabel('y');zlabel('z')

figure
J_rbest=moduler.jacob0(qrmax);
plot_ellipse(J_rbest(1:3,:)*J_rbest(1:3,:)')             
xlabel('x');ylabel('y');zlabel('z')

figure                                                 
plot_ellipse( J_rbest(4:6,:)*J_rbest(4:6,:)' )
xlabel('x');ylabel('y');zlabel('z')
 
figure
moduler.plot(qrmax)

%  q=[0 0.1 0 pi/4 0 0];
% moduler.plot(q1);
% a=moduler.jacob0(q1);%求出雅各比矩阵及其逆矩阵
% % q2=[0 0.5 3 0 0 0];
% % a1=moduler.jacob0(q2);
% b=a^-1;
% c=a';
% %求出雅各比矩阵及其逆矩阵的无穷范数
% p=size(a);
% sum_hang=zeros(1,p(1));
% sum_ni=zeros(1,p(1));
% for i=1:p(1)
%     for j=1:p(2)
%         sum_hang(i)=sum_hang(i)+a(i,j);
%     end
% end
% 
% for ni=1:p(1)
%     for nj=1:p(2)
%         sum_ni(ni)=sum_ni(ni)+b(ni,nj);
%     end
% end
% %求出条件数
% tiaojiann=max(abs(sum_hang)).*max(abs(sum_ni))
% 
% lbd=eig(a*a');%求可操作度
% sum_lbd=1;
% for i=1:p(2)
%     sum_lbd=sum_lbd.*lbd(i);
% end
% w=sqrt(sum_lbd)

%生成随机构型
toc
% disp(['运行时间：',num2str(toc)])
