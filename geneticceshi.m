
tic;
[N,m] = size(parent_chromosome);%N是交配池中的个体数量
%clear m
p = 1;
%下面代码找出交配池中非支配等级的最大值和最小值 为自适应概率计算做准备
l_limit=min_range;
u_limit=max_range;
pc=0.9;
pm=0.1;
%%首先进行交叉工作
for i = 1 : N%这里虽然循环N次，但是每次循环都会有概率产生2个子代，所以最终产生的子代个体数量是2N个
        child_1 = [];
        child_2 = [];
        parent_1 = round(N*rand(1));
        if parent_1 < 1
            parent_1 = 1;
        end
        parent_2 = round(N*rand(1));
        if parent_2 < 1
            parent_2 = 1;
        end
        while isequal(parent_chromosome(parent_1,:),parent_chromosome(parent_2,:))
            parent_2 = round(N*rand(1));
            if parent_2 < 1
                parent_2 = 1;
            end
        end
        parent_1 = parent_chromosome(parent_1,:);
        parent_2 = parent_chromosome(parent_2,:);
        child_1=parent_1;
        child_2=parent_2;
   
    if rand(1) <pc%交叉概率0.9
       rc=randperm(V,2);
       r1=min(r);r2=max(r);
       child_1=[parent_1(1:r1-1),parent_2(r1:r2),parent_1(r2+1:end)];
       child_2=[parent_2(1:r1-1),parent_1(r1:r2),parent_2(r2+1:end)];
    end
        child_1(:,V + 1: M + V) = mubiaohanshu(child_1, M, V);
        child_2(:,V + 1: M + V) = mubiaohanshu(child_2, M, V);
 
        child(p,:) =  child_1(:, 1: M + V);
        child(p+1,:) = child_2(:, 1: M + V);
        p = p + 2;
   end
toc;

tic;
%step one
[S,L] = size(child);

%%对交叉后的数组的每个个体根据概率进行变异操作
for jj=1:S  
    child_3 = child(jj,:);
      if rand(1)<pm           
           r=randperm(V,1);         
           child_3(:,r) = ~child_3(:,r) ;        
           child_3(:,V + 1: M + V) = mubiaohanshu(child_3, M, V);       
      end
      child(jj,:) = child_3(:,1:M+V);      
     
 
end

toc;
