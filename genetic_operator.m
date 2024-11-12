function f  = genetic_operator(parent_chromosome, M, V)
[N,~] = size(parent_chromosome);%N�ǽ�����еĸ�������
%clear m
p = 1;
%��������ҳ�������з�֧��ȼ������ֵ����Сֵ Ϊ����Ӧ���ʼ�����׼��

pc=0.9;
pm=0.1;
%%���Ƚ��н��湤��
for i = 1 : N%������Ȼѭ��N�Σ�����ÿ��ѭ�������и��ʲ���2���Ӵ����������ղ������Ӵ�����������2N��
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
   
    if rand(1) <pc%�������0.9
       r=randperm(V,2);
       r1=min(r);r2=max(r);
       child_1=[parent_1(1:r1-1),parent_2(r1:r2),parent_1(r2+1:end)];
       child_2=[parent_2(1:r1-1),parent_1(r1:r2),parent_2(r2+1:end)];
    
        child_1(:,V + 1: M + V) = mubiaohanshu(child_1, M, V);
        child_2(:,V + 1: M + V) = mubiaohanshu(child_2, M, V);
    end
        child(p,:) =  child_1(:, 1: M + V);
        child(p+1,:) = child_2(:, 1: M + V);
        p = p + 2;
end

%�Խ������Ӵ����б������
[S,~] = size(child);
for jj=1:S  
      child_3 = child(jj,:);
      if rand(1)<pm           
           r=randperm(V,1);         
           child_3(:,r) = ~child_3(:,r) ;        
           child_3(:,V + 1: M + V) = mubiaohanshu(child_3, M, V);       
      end
      child(jj,:) = child_3(:,1:M+V);      
   
end



f = child;
%%�Խ����������ÿ��������ݸ��ʽ��б������
% for jj=1:S  
%         child_3 = child(pp,:);
%       if rand(1)<pm           
%         for ji = 1 : V
%         r(ji) = rand(1);
%            if r(ji) < 0.5
%                delta(ji) = (2*r(ji))^(1/(mum+1)) - 1;
%            else
%                delta(ji) = 1 - (2*(1 - r(ji)))^(1/(mum+1));
%            end
%           
%            child_3(ji) = child_3(ji) + delta(ji);
%            if child_3(ji) > u_limit(ji) % ����Լ��
%                child_3(ji) = u_limit(ji);
%            elseif child_3(ji) < l_limit(ji)
%                child_3(ji) = l_limit(ji);
%            end 
%         end
%            child_3(:,V + 1: M + V) = mubiaohanshu(child_3, M, V);
%       end 
%         child(pp,:) = child_3(:,1:M+V);      
%         pp=pp+1;
%     end
