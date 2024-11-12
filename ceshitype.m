x=zeros(1,14);
type=zeros(25,13);
for j=1:25
    x=chromosome1(j,:);
    for i=1:2:V
    %确定第一个模块类型
    
        if x(i)&&x(i+1)          %[1 1]或[0 1]代码为T模块，代码为1
            type(j,i)=1;
        elseif (x(i)==0)&&(x(i+1)==0)                    %[0 0]代码为R模块，代码为2
           
            type(j,i)=2;
        elseif  (x(i)==1)&&(x(i+1)==0)
                type(j,i)=3             %[1 0]为I模块，代码为3
        else
            type(j,i)=4;
        end
    
 %确定第二个及后续模块构型，添加约束：相邻模块种类不同
         
          
     
    end
end