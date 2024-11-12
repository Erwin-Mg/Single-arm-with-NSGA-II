function f = mubiaohanshu(x, M, V)%%计算每个个体的M个目标函数值,V 为变量维度，X 决定机械臂构型
% tic;
% x = [ 1 1 0 0 1 1 1 0 0 1 1 1];
% V = 12;
%[1 1]为T模块 [0 0]代码为R模块 [1 0]代码为I1模块 [0 1]为I2模块
% tic;
%         关节角 连杆偏距 连杆长度 连杆转角   

%基座模块
%       theta   d/Z      a/X       alpha     offset
Basic=Link([0     0      0      0      0 ],'modified');

%T关节模块
T(1)=Link([0      0      0      pi/2    0],'modified');%坐标系预置关节，不可设置关节变量
T(2)=Link([0      0.97   0      pi/2    0],'modified');
T(3)=Link([0      0      0      pi/2    0],'modified');
T(4)=Link([0      0      0.27   0       0],'modified');%标准化关节，不可设置关节变量
T(1).offset=pi/2;

%转动关节模块
R(1)=Link([0      0      0.37   pi/2   0 ],'modified');
R(2)=Link([0      0      0.37   -pi/2  0 ],'modified');%标准化关节，不可设置关节变量

%连杆模块
I1=Link([0 0 1 0 0],'modified');
I2=Link([0 0 0.5 0 0],'modified');
%定义关节角限制
Basic.qlim=[0,0]/180*pi;
T(1).qlim=[0,0]/180*pi;
T(2).qlim=[0,90]/180*pi;
T(3).qlim=[0,90]/180*pi;
T(4).qlim=[0,0.0001]/180*pi;
R(1).qlim=[0,90]/180*pi;
R(2).qlim=[0,0]/180*pi;
I1.qlim=[0,0]/180*pi;
I2.qlim=[0,0];
NON=0;
q=[];                                         %随机生成构型
j=1;
position=2;
q(1).qlim=[0,0]/180*pi;
type=zeros(1,V/2);
for i=1:2:V
    %确定第一个模块类型
    if i==1
        if  (x(i))&&(x(i+1))
            moduler1(j:j+3)=T(1:4);                      %[1 1]为T模块
            q(position).qlim=[0,0];           %确定模块角度参数
            q(position+1).qlim=[0,90]/180*pi;
            q(position+2).qlim=[0,90]/180*pi;
            q(position+3).qlim=[0,0];
            position=position+4;
            j=j+4;
            type(i)=1;
        elseif (x(i)==0)&&(x(i+1)==0)                    %[0 0]代码为R模块
            moduler1(j:j+1)=R(1:2);
            q(position).qlim=[0,90]/180*pi;              %确定模块角度参数
            q(position+1).qlim=[0,0];
            position=position+2;
            j=j+2;
            type(i)=2;
        elseif (x(i)==1)&&(x(i+1)==0)
            moduler1(j)=I1;                               %[1 0]代码为I1模块
            q(position).qlim=[0,0];
            position=position+1;
            j=j+1;
            type(i)=3;
        else                                              %[0 1]为I2模块
            moduler1(j)=I2;
            q(position).qlim=[0,0];
            j=j+1;
            position=position+1;
            type(j)=4;
        end
    
 %确定第二个及后续模块构型，添加约束：相邻模块种类不同
    else
        if x(i)&&x(i+1)                                   %[1 1]代码为T模块

                moduler1(j:j+3)=T(1:4);                    %确定模块角度参数
                q(position).qlim=[0,0]/180*pi;           
                q(position+1).qlim=[0,90]/180*pi;
                q(position+2).qlim=[0,90]/180*pi;
                q(position+3).qlim=[0,0]/180*pi;
                position=position+4;
                j=j+4;
                type(i)=1;                                 %T模块关节类型为1
          if type(i-2)==1                %确定前一模块不是T模块                           
                NON=1;              
          end
        elseif (x(i)==0)&&(x(i+1)==0)                    %[0 0]代码为R模块
        
                moduler1(j:j+1)=R(1:2);                  %确定模块角度参数
                q(position).qlim=[0,90]/180*pi;              
                q(position+1).qlim=[0,0]/180*pi;
                position=position+2;
                j=j+2;
                type(i)=2;
                if type(i-2)==2
                NON=1;
                end
        elseif x(i)==1&&x(i+1)==0
           
                    moduler1(j)=I1;                              %[1 0]代码为I模块
                    q(position).qlim=[0,0];
                    position=position+1;
                    j=j+1;
                    type(i)=3;
                    if type(i-2)==3
                    NON=1;
                    end
        else
           
                moduler1(j)=I2;
                q(position).qlim=[0,0];
                j=j+1;
                type(i)=4; 
                position=position+1;
                if type(i-2)==4
                    NON=1;
                end
        end                          
    end
end
moduler=SerialLink([Basic moduler1  ],'name','moduler1');


% 判断是否存在相邻杆类型相同
if NON==1
     f(1:M)=0;
     
     return
else

num=30000;                                              %工作空间与全局最大可操作度计算
%P=zeros(num,3);
Manu=zeros(num,j+2);
qtmax=zeros(1,j);
% qrmax=zeros(1,j);
for i =1:num    
    for u=1:j        
        qs(u)=q(u).qlim(1)+rand*(q(u).qlim(2)-q(u).qlim(1));
    end
    Q(i,:)=moduler.fkine(qs);
    %P(i,:)=transl(Q);
    Manu(i,1:j)=qs;
    Manu(i,j+1)=moduler.maniplty(qs);
%   Manu(i,j+2)=moduler.maniplty(qs,'rot');   
end
%% 计算最小条件数
parfor i=1:num
    condition(i)=cond(moduler.jacob0(Manu(i,1:j)));
   % Hhessian(i)=jacobian(four_arm_robot.arm1.jacob0(Manu(i,1:7)))
end
% min_condition=min(condition);
%% 工作空间大小
for i=1:num
    endlocation_rete(i,1:3)=Q(i).t;
    endlocation_rete(i,4)=Manu(i,j+1);
end
max_manu=max(Manu(:,j+1));
points_all=endlocation_rete(:,1:3);
workspace_all = alphaShape(points_all);
vol_all=volume(workspace_all);


%% 灵活工作空间占比
j=1;
for i=1:num
   if (endlocation_rete(i,4)/max_manu)>=0.7
       points_flex(j,1:3)=endlocation_rete(i,1:3); 
       j=j+1;
   end
end
if j<=100   %不存在灵活点或灵活点极少
    flex_percentage=0;
else
    workspace_flex=alphaShape(points_flex);
    vol_flex=volume(workspace_flex);
%     flex_percentage=vol_flex/vol_all;
end

%% 速度全域性能
d_theta=vol_all/num; %积分算子
condition_all=0;
velocity=0;
parfor i=1:num
    velocity(i)=d_theta*condition(i);   
end
vel_value=sum(velocity)/vol_all;



%% 目标函数f

f = zeros(1,M);
% free_dom=0;
% for i=1:V-1
%     if type(i)==1
%         free_dom=free_dom+2;
%     elseif type(i)==2
%         free_dom=free_dom+1;
%     end
% end

f(1)=roundn(max_manu,-2);
% f(2)=free_dom;
f(2)=roundn(vel_value,-2);
f(3)=vol_flex;

end

% disp(['全局最大可操作度: ',num2str(mby_t),'  ',num2str(mby_r), newline,'最佳T姿态角',num2str(qtmax/pi*180),newline,'最佳R姿态角',num2str(qrmax/pi*180)]);
% 
% figure
% J_best=moduler.jacob0(qtmax);
% plot_ellipse(J_best(1:3,:)*J_best(1:3,:)')              %线速度可操作性椭球
% xlabel('x');ylabel('y');zlabel('z')
% 
% figure                                                  %角速度可操作性椭球
% plot_ellipse( J_best(4:6,:)*J_best(4:6,:)' )
% xlabel('x');ylabel('y');zlabel('z')
% 
% figure

% plot_ellipse(J_rbest(1:3,:)*J_rbest(1:3,:)')             
% xlabel('x');ylabel('y');zlabel('z')
% 
% figure                                                 
% plot_ellipse( J_rbest(4:6,:)*J_rbest(4:6,:)' )
% xlabel('x');ylabel('y');zlabel('z')
%  
% figure
% moduler.plot(qrmax)

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
% toc
% disp(['运行时间：',num2str(toc)])
end
