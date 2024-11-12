parent_1=0.1;
mum=20;
child_3=[];
child_4=[];
for j = 1 : 1000
           r(j) = rand(1);

          if r(j) < 0.5
               delta(j) = 1*((2*r(j))^(1/(mum+1)) - 1);
              else
               delta(j) =1*(1 - (2*(1 - r(j)))^(1/(mum+1)));
                 end
           
           child_3(j) = parent_1 + delta(j);
           if child_3(j) > 1 % 条件约束
              child_3(j) = 1;
          elseif child_3(j) < 0
              child_3(j) =0;
            end
end 
parent_1=0.9;
child_4=[];
for j = 1 : 1000
           r(j) = rand(1);

          if r(j) < 0.5
               delta(j) = 1*((2*r(j))^(1/(mum+1)) - 1);
              else
               delta(j) =1*(1 - (2*(1 - r(j)))^(1/(mum+1)));
                 end
           
           child_4(j) = parent_1 + delta(j);
           if child_4(j) > 1 % 条件约束
              child_4(j) = 1;
          elseif child_4(j) < 0
              child_4(j) =0;
            end
end 
parent_1=0.5;
child_5=[];
for j = 1 : 1000
           r(j) = rand(1);

          if r(j) < 0.5
               delta(j) = 1*((2*r(j))^(1/(mum+1)) - 1);
              else
               delta(j) =1*(1 - (2*(1 - r(j)))^(1/(mum+1)));
                 end
           
           child_5(j) = parent_1 + delta(j);
           if child_5(j) > 1 % 条件约束
              child_5(j) = 1;
          elseif child_5(j) < 0
              child_5(j) =0;
            end
end 
    plot(child_3,'bo');
    hold on;
plot(child_4,'ro');

plot(child_5,'go');
xlabel('变异次数'); ylabel('子代个体分布');
legend('p=0.1','p=0.9','p=0.5');
hold off;