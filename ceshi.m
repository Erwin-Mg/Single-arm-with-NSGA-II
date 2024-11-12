
%[1 1]为T模块 [0 0]代码为R模块 [1 0]代码为I1模块 [0 1]为I2模块
x = [ 1 1 0 0 1 1 ];
V = 6;
% tic;
%         关节角 连杆偏距 连杆长度 连杆转角   

%基座模块
Basic=Link([0     0      0      0      0 ],'modified');

%T关节模块
T(1)=Link([0      0      0      pi/2    0],'modified');%坐标系预置关节，不可设置关节变量
T(2)=Link([0      9.7    0      pi/2    0],'modified');
T(3)=Link([0      0      0      pi/2    0],'modified');
T(4)=Link([0      0      2.7    0       0],'modified');%标准化关节，不可设置关节变量
T(1).offset=pi/2;

moduler_T=SerialLink(T,'name','modulerT');
%转动关节模块
R(1)=Link([0      0      0.37   pi/2   0 ],'modified');
R(2)=Link([0      0      0.37   -pi/2  0 ],'modified');%标准化关节，不可设置关节变量

moduler_R=SerialLink(R,'name','modulerR');
%连杆模块
I1=Link([0 0 1 0 0],'modified');
I2=Link([0 0 0.5 0 0],'modified');

moduler_I=SerialLink(I1,I2,'name','modulerI');
%定义关节角限制
Basic.qlim=[0,0]/180*pi;
T(1).qlim=[0,0]/180*pi;
T(2).qlim=[-180,180]/180*pi;
T(3).qlim=[-180,180]/180*pi;
T(4).qlim=[0,0]/180*pi;
R(1).qlim=[-180,180]/180*pi;
R(2).qlim=[0,0];
I1.qlim=[0,0];
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
            q(position).qlim=T(1).qlim;           %确定模块角度参数
            q(position+1).qlim=T(2).qlim;
            q(position+2).qlim=T(3).qlim;
            q(position+3).qlim=T(4).qlim;
            position=position+4;
            j=j+4;
            type(i)=1;
        elseif (x(i)==0)&&(x(i+1)==0)                    %[0 0]代码为R模块
            moduler1(j:j+1)=R(1:2);
            q(position).qlim=R(1).qlim;              %确定模块角度参数
            q(position+1).qlim=R(2).qlim;
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
        if x(i)&&x(i+1)                                   %[1 1]或[0 1]代码为T模块

                moduler1(j:j+3)=T(1:4);                    %确定模块角度参数
                q(position).qlim=T(1).qlim;           %确定模块角度参数
                q(position+1).qlim=T(2).qlim;
                q(position+2).qlim=T(3).qlim;
                q(position+3).qlim=T(4).qlim;
                position=position+4;
                j=j+4;
                type(i)=1;                                 %T模块关节类型为1
          if type(i-2)==1                %确定前一模块不是T模块                           
                NON=1;              
          end
        elseif (x(i)==0)&&(x(i+1)==0)                    %[0 0]代码为R模块
        
                moduler1(j:j+1)=R(1:2);                  %确定模块角度参数
                q(position).qlim=R(1).qlim;              %确定模块角度参数
                q(position+1).qlim=R(2).qlim;
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
if NON==1
     f(1:2)=0;
     
     return
else

num=120000;                                              %工作空间与全局最大可操作度计算
P=zeros(num,3);
Manu=zeros(num,j+2);
qtmax=zeros(1,j);
% qrmax=zeros(1,j);
% Q=zeros(num,3);
for i =1:num
    
    for u=1:j
        
        qs(u)=q(u).qlim(1)+rand*(q(u).qlim(2)-q(u).qlim(1));
     
       
    end
       Q=moduler.fkine(qs);
       P(i,:)=Q.t;
   
%     Manu(i,1:j)=qs;
%     Manu(i,j+1)=moduler.maniplty(qs);
%     Manu(i,j+2)=moduler.maniplty(qs,'rot');
   
end
% f = [];
figure;
plot3(P(:,1),P(:,2),P(:,3),'b.','markersize',1);        %绘制工作空间
% q_initial=zeros(23);
% moduler.plot(q_initial(1,:));
% mby_t=max(Manu(:,j+1));                                   %寻找全局最大可操作度
% % mby_r=max(Manu(:,j+2));
% [row_t,~]=find(mby_t==Manu);                        %寻找最大可操作度对应关节角
% % [row_r,~]=find(mby_r==Manu);
% qtmax=Manu(row_t,1:j);
% qrmax=Manu(row_r,1:j);

% free_dom=0;
% for i=1:V-1
%     if type(i)==1
%         free_dom=free_dom+2;
%     elseif type(i)==2
%         free_dom=free_dom+1;
%     end
% end

% f(1)=roundn(mby_t,-2);
% % f(2)=free_dom;
% J_rbest=moduler.jacob0(qtmax);
% f(2)=roundn(100/cond(J_rbest),-2);
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
% moduler_test=SerialLink([T,R],'name','moduler_test');
% figure;
moduler.plot([ 0 0 0 0 0 0 0 0 0 0 0]);
moduler.teach;
figure;
scatter3(P(:, 1), P(:, 2), P(:, 3), 'b.', 'SizeData', 1, 'MarkerEdgeAlpha', 0.5);
%% 切面
% 假设 P 是一个 Nx3 的点云矩阵
W = rand(100, 3);

% 计算每个点的密度（在一定半径内的点数）
radius = 0.1; % 可根据实际情况调整半径
kdtree = KDTreeSearcher(P);
numNeighbors = cellfun('length', rangesearch(kdtree, P, radius)) - 1;

% 设置颜色范围
density_min = 10;
density_max = 100;
yellow_range = [density_min, density_max];

% 根据密度计算颜色
density_normalized = (numNeighbors - min(numNeighbors)) / (max(numNeighbors) - min(numNeighbors));
colors = jet(numel(density_normalized));
colors(density_normalized >= yellow_range(1) & density_normalized <= yellow_range(2), :) = repmat([1, 1, 0], sum(density_normalized >= yellow_range(1) & density_normalized <= yellow_range(2)), 1);

% 绘制彩色点云
scatter3(P(:, 1), P(:, 2), P(:, 3), 10, colors, 'filled');
xlabel('x');
ylabel('y');
zlabel('z');
title('彩色点云');

% 创建网格
gridSize = 0.1; % 根据数据调整
xRange = min(P(:, 1)):gridSize:max(P(:, 1));
yRange = min(P(:, 2)):gridSize:max(P(:, 2));
zRange = min(P(:, 3)):gridSize:max(P(:, 3));
[xGrid, yGrid, zGrid] = meshgrid(xRange, yRange, zRange);

% 散点插值
F = scatteredInterpolant(P(:, 1), P(:, 2), P(:, 3), numNeighbors);
fGrid = F(xGrid(:), yGrid(:), zGrid(:));
fGrid = reshape(fGrid, size(xGrid));

% 定义切面位置
xSlice = mean(P(:, 1));
ySlice = mean(P(:, 2));
zSlice = mean(P(:, 3));

% 绘制切面
figure;
slice(xGrid, yGrid, zGrid, fGrid, xSlice, ySlice, zSlice);
colormap(jet);
colorbar;
alpha(0.5);
title('点云切面');
xlabel('x');
ylabel('y');
zlabel('z');

