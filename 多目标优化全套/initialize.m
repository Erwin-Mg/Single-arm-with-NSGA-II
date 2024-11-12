
function f = initialize(N, M, V)%f是一个由种群个体组成的矩阵
K = M + V;%%K是数组的总元素个数。为了便于计算，决策变量和目标函数串在一起形成一个数组。  
%对于交叉和变异，利用目标变量对决策变量进行选择
a = 1;
r_arm = 0.5;  % 新球的半径
for i = 1 : N
          for j=1:3:12
                % 生成四个随机的球坐标
                r = a * rand(1);  % 随机生成四个半径
                theta = acos(2 * rand( 1) - 1);  % 随机生成四个极角，范围是[0, pi]
                phi = 2 * pi * rand(1);  % 随机生成四个方位角，范围是[0, 2*pi]

                 % 转换球坐标为直角坐标
                x = r .* sin(theta) .* cos(phi);
                y = r .* sin(theta) .* sin(phi);
                z = r .* cos(theta);

                c=[x ; y ; z]';          
                f(i,j:j+2)=c;
          end
    f(i,V + 1: K) = gongzuokongjian(f(i,:), M, V); % M是目标函数数量 V是决策变量个数
                                                    %为了简化计算将对应的目标函数值储存在染色体的V + 1 到 K的位置。
end


%% test
for i = 1 : N
          % 设置球的半径
          for j=1:3:12
          a = 1;
          r_arm = 0.5;  % 新球的半径

                % 生成四个随机的球坐标
                r = a * rand(1);  % 随机生成四个半径
                theta = acos(2 * rand( 1) - 1);  % 随机生成四个极角，范围是[0, pi]
                phi = 2 * pi * rand(1);  % 随机生成四个方位角，范围是[0, 2*pi]

                 % 转换球坐标为直角坐标
                x = r .* sin(theta) .* cos(phi);
                y = r .* sin(theta) .* sin(phi);
                z = r .* cos(theta);

                c=[x ; y ; z]';          
                f(i,j:j+2)=c;
          end
%     f(i,V + 1: K) = gongzuokongjian(f(i,:), M, V); % M是目标函数数量 V是决策变量个数
                                                    %为了简化计算将对应的目标函数值储存在染色体的V + 1 到 K的位置。
end
end