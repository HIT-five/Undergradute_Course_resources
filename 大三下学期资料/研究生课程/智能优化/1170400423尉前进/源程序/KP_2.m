clear
clc
a = 0.95;
k = [5;10;13;4;3;11;13;10;8;16;7;4] ;
k = -k;
d = [2;5;18;3;2;5;10;4;11;7;14;6];
restriction = 50;
num = 12;
sol_new = ones(1,num);
E_current = inf;
E_best = inf;
sol_current = sol_new;
sol_best = sol_new;
T0 = 100;
Tf = 3;
T = T0;
p = 1;
P = 0;
while T>=Tf
    for r=1:160%每个T下迭代100次
        for k = 1:16
            
            % 产生随机扰动
            tmp = ceil(rand.*num);
            sol_new(1,tmp) = ~sol_new(1,tmp);
            % 检查是否满足约束
            while 1
                q = (sol_new*d<=restriction);
                if ~q
                    p = ~q;
                    tmp = find(sol_new==1);
                    if p
                        sol_new(1,tmp)=0;
                    else
                        sol_new(1,tmp(end))=0;
                    end
                
                else
                    break
                end     
            end
        end
        % 计算背包中的物品价值
        E_new = sol_new*k;
        if E_new<E_current
           E_current = E_new;
           
            if E_new<E_best
                E_best = E_new;
                sol_best = sol_new;
                P =P+1;
            end
        else
            if rand<exp(-(E_new-E_current)./T)
                E_current=E_new;
                sol_current = sol_new;
                P = P+1;
            else
                sol_new=sol_current;
            end
        end
        trace(P+1) = -E_best;
    end
    T = T.*a;
    %T = T*exp(-0.1);
end

disp('最优解为：')
disp(sol_best)
disp('物品总价值等于：')
val = -E_best;
disp(val)
disp('背包中物体的重量是：')
disp(sol_best*d)
figure
plot(trace(2:end))
xlabel('迭代次数')
ylabel('目标函数值')
title('原始方法-适应度进化曲线')