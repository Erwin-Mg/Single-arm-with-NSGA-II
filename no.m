%六轴机械臂工作空间计算
clc;
clear;
format short;%保留精度
 
%角度转换
du=pi/180;  %度
radian=180/pi; %弧度
 
%% 模型导入
%   theta |         d |         a |     alpha |     type|   offset |
L(1)=Link([0       -0.072        0.150        0      0     pi/2  ],'modified'); % 关节1这里的最后一个量偏置
L(2)=Link([0       0          0.022        pi/2      0    -pi/2  ],'modified');
L(3)=Link([0       0           0.285        0          0    -pi/2 ],'modified');
L(4)=Link([0       0.22        0.0035           -pi/2      0    0 ],'modified');
% L(5)=Link([0       0           0           -pi/2       0     ],'modified');
% L(6)=Link([0       0            0           pi/2      0     ],'modified');
%                  0.262
p560L=SerialLink(L,'name','LEFT');
p560L.tool=[0 -1 0 0;
            1 0 0 0;
            0 0 1 0 ;
            0 0 0 1;]; 
           
R(1)=Link([0       -0.072        -0.150        0      0     pi/2  ],'modified'); % 关节1这里的最后一个量偏置
R(2)=Link([0       0          0.022        pi/2      0    -pi/2  ],'modified');
R(3)=Link([0       0           0.285        0          0    -pi/2 ],'modified');
R(4)=Link([0       0.22        0.0035           -pi/2      0    0 ],'modified');
% R(5)=Link([0       0           0           -pi/2       0     ],'modified');
% R(6)=Link([0       0           0           pi/2      0     ],'modified');
%                  0.262
p560R=SerialLink(R,'name','RIGHT');
p560R.tool=[0 -1 0 0;
               1 0 0 0;
               0 0 1 0 ;
               0 0 0 1;]; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   platform
 
platform=SerialLink([0 0 0 0],'name','platform','modified');%虚拟腰部关节
platform.base=[1 0 0 0;
               0 1 0 0;
               0 0 1 0 ;
               0 0 0 1;]; %基座高度
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   R
 
pR=SerialLink([platform,p560R],'name','R'); % 单独右臂模型，加装底座
pR.display();
pL=SerialLink([platform,p560L],'name','L'); % 单独左臂模型，加装底座
pL.display();
 
%% 求取工作空间
     %左臂关节角限位
    l_q1_s=-90; l_q1_end=40;
    l_q2_s=0;    l_q2_end=110;
    l_q3_s=0;  l_q3_end=112;
    l_q4_s=-90; l_q4_end=90;
 
    
    %右臂关节角限位
    r_q1_s=-40; r_q1_end=90;
    r_q2_s=0; r_q2_end=110;
    r_q3_s=0;  r_q3_end=112;
    r_q4_s=-90; r_q4_end=90;
 
    
    %设置step
    %step越大，点越稀疏，运行时间越快
    step=2;%计算步距
    step1= (l_q1_end -l_q1_s) / (0.5*step);
    step2= (l_q2_end -l_q2_s) / (2*step);
    step3= (l_q3_end -l_q3_s) / (2*step);
    
    step4= (r_q1_end -r_q1_s) / (0.5*step);
    step5= (r_q2_end -r_q2_s) / (2*step);
    step6= (r_q3_end -r_q3_s) / (2*step);
    
    %计算工作空间
    tic;%tic1
    i=1;
    j=1;
%     left arm 
    T_l = zeros(3,1);
    T_l_x = zeros(1,step1*step2*step3);
    T_l_y = zeros(1,step1*step2*step3);
    T_l_z = zeros(1,step1*step2*step3);  
%     right arm
    T_r = zeros(3,1);
    T_r_x = zeros(1,step4*step5*step6);
    T_r_y = zeros(1,step4*step5*step6);
    T_r_z = zeros(1,step4*step5*step6); 
    % left
    for  l_q1=l_q1_s:step:l_q1_end
        for  l_q2=l_q2_s:step:l_q2_end
              for  l_q3=l_q3_s:step:l_q3_end
%                   T_l=pL.fkine([0 l_q1*du l_q2*du l_q3*du 0]);%正向运动学仿真函数
                  T_l=pL.fkine([0 0 l_q2*du l_q3*du 0]);%正向运动学仿真函数
                  T_l_x(1,i) = T_l.t(1); 
                  T_l_y(1,i) = T_l.t(2); 
                  T_l_z(1,i) = T_l.t(3); 
                  i=i+1;
             end
        end 
    end
   
% right
    for  r_q1=r_q1_s:step:r_q1_end
        for  r_q2=r_q2_s:step:r_q2_end
              for  r_q3=r_q3_s:step:r_q3_end
                  T_r=pR.fkine([0 r_q1*du r_q2*du r_q3*du 0]);%正向运动学仿真函数
%                   T_r=pL.fkine([0 0 r_q2*du r_q3*du 0]);%正向运动学仿真函数
                  T_r_x(1,j) = T_r.t(1); 
                  T_r_y(1,j) = T_r.t(2); 
                  T_r_z(1,j) = T_r.t(3); 
                  j=j+1;
             end
        end 
    end
    
    disp(['循环运行时间：',num2str(toc)]); 
    t1=clock;
     
%% 绘制工作空间
 
figure('name','4轴双机械臂工作空间')
hold on
plotopt = {
    'noraise', 'nowrist', 'nojaxes', 'delay',0};
pL.plot([0 0 pi/4 pi/9 0 ], plotopt{:});
plot3(T_l_x,T_l_y,T_l_z,'r.','MarkerSize',3);
 
pR.plot([0 0 0 0 0 ], plotopt{:});
% plot3(T_r_x,T_r_y,T_r_z,'B*','MarkerSize',3);
 
disp(['绘制工作空间运行时间：',num2str(etime(clock,t1))]);  
 
%获取X,Y,Z空间坐标范围
Point_range=[min(T_l_x) max(T_l_x) min(T_l_y) max(T_l_y) min(T_l_z) max(T_l_z)]
hold off