clear
clc
 v = [5;10;13;4;3;11;13;10;8;16;7;4] ;
 w = [2;5;18;3;2;5;10;4;11;7;14;6];
% w = [2;3;4;5];
% v = [3;4;5;6];
restriction = 50;
num = 12;
f = zeros(num+1,restriction);
x = zeros(num,1);
for i = 2:num+1
    
    for j = 1:restriction
        if w(i-1)>j
            f(i,j)=f(i-1,j);
        elseif  w(i-1)<j
            f(i,j)=max(f(i-1,j-w(i-1))+v(i-1),f(i-1,j));
        else
            f(i,j) = max(f(i-1,1)+v(i-1),f(i-1,j));
        end
    end
end
% 回溯求具体解的值
% for k = num+1:2
%     for p = restriction :1
%         if (p-1==0)
%             break
%         else
%             if w(k-1)<p
%                 f(k-1,p-w(i-1))=f(k,p)-v(k-1);
%                 x(k-1) = 1;
%             elseif w(k-1)>p
%                 f(k-1,p)=f(k,p);
%             else
%                 f(k-1,1)=0;
%             end
%         end
%             
%     end
% end
k = num+1;
p = restriction;
while(p-1~=0)
    if w(k-1)<p
        f(k-1,p-w(i-1))=f(k,p)-v(k-1);
        x(k-1) = 1;
        p = p-w(i-1);
    elseif w(k-1)>p
        f(k-1,p)=f(k,p);
    else
        f(k-1,1)=0;
        x(k-1)=1;
        p = 1;
    end
    k = k-1;
    
end    
disp('物品总价值等于：')
val = f(num+1,restriction);
disp(val)
disp('背包中物体的重量是：')
disp(restriction)
disp('最优解为：')
disp(x')