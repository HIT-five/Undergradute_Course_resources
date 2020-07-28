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
    for r=1:160%ÿ��T�µ���100��
        for k = 1:16
            
            % ��������Ŷ�
            tmp = ceil(rand.*num);
            sol_new(1,tmp) = ~sol_new(1,tmp);
            % ����Ƿ�����Լ��
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
        % ���㱳���е���Ʒ��ֵ
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

disp('���Ž�Ϊ��')
disp(sol_best)
disp('��Ʒ�ܼ�ֵ���ڣ�')
val = -E_best;
disp(val)
disp('����������������ǣ�')
disp(sol_best*d)
figure
plot(trace(2:end))
xlabel('��������')
ylabel('Ŀ�꺯��ֵ')
title('ԭʼ����-��Ӧ�Ƚ�������')