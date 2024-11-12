child_1=[];
child_2=[];
parent_1=0.6;
parent_2=0.3;
mu=15;
for j=1:500
         u = rand(1);
         if(j<250)
            if u <= 0.5
                  child_1(j) = ...
               (parent_1+parent_2)/2+1.481*(parent_1-parent_2)*abs(normrnd(0,1))/2;
                  child_2(j) = ...
              (parent_1+parent_2)/2-1.481*(parent_1-parent_2)*abs(normrnd(0,1))/2;
            else
                  child_2(j) = ...
               (parent_1+parent_2)/2+1.481*(parent_1-parent_2)*abs(normrnd(0,1))/2;
                  child_1(j) = ...
              (parent_1+parent_2)/2-1.481*(parent_1-parent_2)*abs(normrnd(0,1))/2;
            end
         elseif(j<400)
            if u <= 0.5
                  child_1(j) = ...
               (parent_1+parent_2)/2+1.481*(parent_1-parent_2)*abs(normrnd(0,0.7))/2;
                  child_2(j) = ...
              (parent_1+parent_2)/2-1.481*(parent_1-parent_2)*abs(normrnd(0,0.7))/2;
            else
                  child_2(j) = ...
               (parent_1+parent_2)/2+1.481*(parent_1-parent_2)*abs(normrnd(0,0.7))/2;
                  child_1(j) = ...
              (parent_1+parent_2)/2-1.481*(parent_1-parent_2)*abs(normrnd(0,0.7))/2;
            end
         else
             if u <= 0.5
                  child_1(j) = ...
               (parent_1+parent_2)/2+1.481*(parent_1-parent_2)*abs(normrnd(0,0.5))/2;
                  child_2(j) = ...
              (parent_1+parent_2)/2-1.481*(parent_1-parent_2)*abs(normrnd(0,0.5))/2;
            else
                  child_2(j) = ...
               (parent_1+parent_2)/2+1.481*(parent_1-parent_2)*abs(normrnd(0,0.5))/2;
                  child_1(j) = ...
              (parent_1+parent_2)/2-1.481*(parent_1-parent_2)*abs(normrnd(0,0.5))/2;
            end
         end
          
            
end

plot(child_1,'bo');
hold on;
plot(child_2,'r*');
xlabel('交叉次数'); ylabel('子代个体分布');
legend('x1','x2')
hold off;