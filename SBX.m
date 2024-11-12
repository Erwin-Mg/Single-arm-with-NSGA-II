child_1=[];
child_2=[];
parent_1=0.6;
parent_2=0.3;
mu=15;
for j=1:500
         u = rand(1);
            if u <= 0.5
                bq = (2*u)^(1/(mu+1));
            else
                bq = (1/(2*(1 - u)))^(1/(mu+1));
            end
            child_1(j) = ...
                0.5*(((1 + bq)*parent_1) + (1 - bq)*parent_2);
            child_2(j) = ...
                0.5*(((1 - bq)*parent_1) + (1 + bq)*parent_2);
end
plot(child_1,'bo');
hold on;
plot(child_2,'r*');
xlabel('交叉次数'); ylabel('子代个体分布');
legend('x1','x2')
hold off;