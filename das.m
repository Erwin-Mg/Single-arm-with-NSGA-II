% 假设有一组三维空间中的点 (x, y, z)
points = chromosome(:,13:15); % 替换为你的实际数据

% 构造矩阵 A
A = [points(:, 1), points(:, 2), ones(size(points, 1), 1)];

% 构造列向量 B
B = -points(:, 3);

% 使用最小二乘法求解线性方程组
X = A \ B;

% 提取平面参数
a = X(1);
b = X(2);
c = 1; % 因为我们在构造 A 矩阵时将 z 的系数设为 1
d = X(3);

% 输出平面参数
fprintf('平面方程：%.4fx + %.4fy + %.4fz + %.4f = 0\n', a, b, c, d);

% 生成平面上的点
[X_plane, Y_plane] = meshgrid(linspace(min(points(:, 1)), max(points(:, 1)), 10), ...
                              linspace(min(points(:, 2)), max(points(:, 2)), 10));
Z_plane = (-a * X_plane - b * Y_plane - d) / c;

% 绘制原始点和拟合平面
figure;
scatter3(points(:, 1), points(:, 2), points(:, 3), 'o', 'b','filled', 'DisplayName', '原始点');
hold on;
surf(X_plane, Y_plane, Z_plane, 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'DisplayName', '拟合平面');
xlabel('X轴-灵巧度指标');
ylabel('Y轴-协同体积');
zlabel('Z轴-最大刚度');
legend;
grid on;
