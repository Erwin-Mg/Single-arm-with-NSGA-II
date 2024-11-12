function f = gongzuokongjian(zuobiao, M, V)%%计算每个个体的M个目标函数值,V 为变量维度，X 决定机械臂构型
% 设置球的半径
% a = 1;
r_arm = 0.5;  % 新球的半径
% 
% % 生成四个随机的球坐标
% r = a * rand(4, 1);  % 随机生成四个半径
% theta = acos(2 * rand(4, 1) - 1);  % 随机生成四个极角，范围是[0, pi]
% phi = 2 * pi * rand(4, 1);  % 随机生成四个方位角，范围是[0, 2*pi]
% 
% % 转换球坐标为直角坐标
% x = r .* sin(theta) .* cos(phi);
% y = r .* sin(theta) .* sin(phi);
% z = r .* cos(theta);
% 
% c=[x ; y ; z]';
 j=1;
for i=1:3:12   
    x(j)=zuobiao(i);
    y(j)=zuobiao(i+1);
    z(j)=zuobiao(i+2);
    j=j+1;
end
% 绘制球和随机点
% figure;
% [xs, ys, zs] = sphere(100);
% h = surf(a * xs, a * ys, a * zs);
% set(h, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
% hold on;
% scatter3(x, y, z, 'filled', 'r');
% axis equal;

% % 在每个随机点位置上画新的球
% for i = 1:4
%     [xs_new, ys_new, zs_new] = sphere(100);
%     h_new = surf(r_arm * xs_new + x(i), r_arm * ys_new + y(i), r_arm * zs_new + z(i));
%     set(h_new, 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'FaceColor', 'b');
% end
% 
% title('在球内随机取四个点并画出四个半径为b的球');
% 
% % 显示坐标轴标签
% xlabel('X轴');
% ylabel('Y轴');
% zlabel('Z轴');
% 
% hold off;


%% 

% 计算N个球体所占的体积
sc = [x ;y ;z]'; % 球体的球心坐标
r = r_arm*ones(4,1); % 对应球体的半径
V = CalcNSphereVolume(sc,r, 200000); % 体积
volcoop=4 * (4/3) * pi * r_arm.^3-V;

f(1)=volcoop;
f(2)=V;
% N = length(r);
% str1 = sprintf('%d个球体相交后所占的体积是%f.',N, V);
% str2 = sprintf('%d个球协作空间体积是%f.',N, volcoop);
% disp(str1);
% disp(str2);

function V = CalcNSphereVolume(sc,r, randomPtNum)
% 函数V = CalcNSphereVolume(sc,r, randomPtNum)利用蒙特卡洛方法求N个球体
% 所占的体积.
%
% 参数说明
%     输入参数：
%          sc: N个球体的球心坐标，是一N*3的矩阵，第一列是X，第二列是Y，第三
%              列是Z
%          r: N个球体对应的半径
%     randomPtNum: 随机在空间生成的点的个数,建议至少为10000
%
%     输出参数：
%          V: N个球体相交后所占的体积

% 参数判断
if nargin==2
    randomPtNum = 500000;
end

N = length(r);   % 球体的个数

% 确定生成随机点的空间范围，是一包含所有球体的长方体,即任何球体的球面
% 均不与长方体面相切
xl = min((sc(:,1)-r(:)));
xl = xl-0.01*abs(xl);
xr = max((sc(:,1)+r(:)));
xr = xr+0.01*abs(xr);
yl = min((sc(:,2)-r(:)));
yl = yl-0.01*abs(yl);
yr = max((sc(:,2)+r(:)));
yr = yr+0.01*abs(yr);
zl = min((sc(:,3)-r(:)));
zl  = zl-0.01*abs(zl);
zr = max((sc(:,3)+r(:)));
zr = zr+0.01*abs(zr);

% 随机生成randomPtNum个点
k = 0;
pt = zeros(1,3);
Xpt = rand(1, randomPtNum);
Ypt = rand(1, randomPtNum);
Zpt = rand(1, randomPtNum);

% 获得属于球体的随机点的个数
for i=1:randomPtNum
    
    pt(1) = xl+(xr-xl)*Xpt(i);  % 把随机点的X坐标转换至长方体的X坐标范围内
    pt(2) = yl+(yr-yl)*Ypt(i);  % 把随机点的Y坐标转换至长方体的Y坐标范围内
    pt(3) = zl+(zr-zl)*Zpt(i);  % 把随机点的Z坐标转换至长方体的Z坐标范围内
    
    % 遍历所有球体
    for j=1:N
       r_square = r(j)*r(j);
       distance_square = (pt(1)-sc(j,1))^2+(pt(2)-sc(j,2))^2+(pt(3)-sc(j,3))^2;
       
       % 判断随机点是否属于球体
       if distance_square<=r_square
          k = k+1;    % 属于球体，k自增1，并跳出球体循环
          break;
       end
    end
end
V_cuboid = (xr-xl)*(yr-yl)*(zr-zl);  % 长方体的体积
V = (k/randomPtNum)*V_cuboid;        % 得到N个球体所占的体积
end





end
