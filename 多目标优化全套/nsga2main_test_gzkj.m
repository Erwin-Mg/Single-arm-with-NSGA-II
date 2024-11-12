% function nsga_2_optimization()
tic;
%此处可以更改

%更多机器学习内容请访问omegaxyz.com
pop =500; %种群数量
gen =100; %迭代次数
M = 2;   %目标函数数量
V = 12;  %维度（决策变量的个数）
chromosome = initialize(pop, M, V);%初始化种群
toc;
disp('初始化完毕');
chromosome = non_domination_sort_mod(chromosome, M, V);%对初始化种群进行非支配快速排序和拥挤度计算
toc;
disp('初始排序完成');

for i = 1 : gen
    pool = round(pop/2);%round() 四舍五入取整 交配池大小
    tour = 2;%竞标赛  参赛选手个数
    parent_chromosome = tournament_selection(chromosome, pool, tour);%竞标赛选择适合繁殖的父代
    offspring_chromosome = genetic_operator(parent_chromosome,M, V);%进行交叉变异产生子代 该代码中使用模拟二进制交叉和多项式变异 采用实数编码
    [main_pop,~] = size(chromosome);%父代种群的大小
    [offspring_pop,~] = size(offspring_chromosome);%子代种群的大小
    
    clear temp
    intermediate_chromosome(1:main_pop,:) = chromosome;
    intermediate_chromosome(main_pop + 1 : main_pop + offspring_pop,1 : M+V) = offspring_chromosome;%合并父代种群和子代种群
    intermediate_chromosome = non_domination_sort_mod(intermediate_chromosome, M, V);%对新的种群进行快速非支配排序
    chromosome = replace_chromosome(intermediate_chromosome, M, V, pop);%选择合并种群中前N个优先的个体组成新种群
    if ~mod(i,1)        
        toc;
        fprintf('%d generations completed\n',i);
    end
end


if M == 2
    plot(chromosome(:,V + 1),chromosome(:,V + 2),'*');
    xlabel('f_1'); ylabel('f_2');
    title('Pareto Optimal Front');
elseif M == 3
    plot3(chromosome(:,V + 1),chromosome(:,V + 2),chromosome(:,V + 3),'*');
    xlabel('f_1'); ylabel('f_2'); zlabel('f_3');
    title('Pareto Optimal Surface');

end
save test12.mat;
toc

% plot(chromosome3(:,1),chromosome3(:,2),'*');
% hold on;
% plot(chromosome4(:,1),chromosome4(:,2),'+');
% hold on;
% plot(chromosome5(:,1),chromosome5(:,2),'d');
% hold on;
% plot(chromosome6(:,1),chromosome6(:,2),'p');
% hold on;
% plot(chromosome7(:,1),chromosome7(:,2),'h');
% hold on;