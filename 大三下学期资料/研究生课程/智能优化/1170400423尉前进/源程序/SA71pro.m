%%%%%%%%%%%%%%%%%%%%%%ģ���˻��㷨���������ֵ%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ʼ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;                      %������б���
close all;                      %��ͼ
clc;                            %����
D=2;                           %����ά�� 
Xs=5.12;                          %����                                
Xx=-5.12;                         %����
%%%%%%%%%%%%%%%%%%%%%%%%%%%��ȴ�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L = 200;                        %��ɷ�������
% K = 0.998;                      %˥������
k=2;
S = 0.01;                       %��������
T=100;                          %��ʼ�¶�
YZ = 1e-8;                      %�ݲ�
P = 0;                          %Metropolis�������ܽ��ܵ�
m=4;
%%%%%%%%%%%%%%%%%%%%%%%%%%���ѡ�� ��ֵ�趨%%%%%%%%%%%%%%%%%%%%%%%%%
A=rand(D,1);
W=2*A-1;
U=rand(D,1);
PreX = rand(D,1)*(Xs-Xx)+Xx;
PreBestX = PreX;
PreX =  rand(D,1)*(Xs-Xx)+Xx;
BestX = PreX;
%%%%%%%%%%%ÿ����һ���˻�һ��(����), ֱ�������������Ϊֹ%%%%%%%%%%%%
deta=abs( func1( BestX)-func1(PreBestX));
while (deta > YZ) && (T>0.001)
    %T=K*T;
    %%%%%%%%%%%%%%%%%%%%%�ڵ�ǰ�¶�T�µ�������%%%%%%%%%%%%%%%%%%%%%%
    for i=1:L  
        %%%%%%%%%%%%%%%%%�ڴ˵㸽�����ѡ��һ��%%%%%%%%%%%%%%%%%%%%%
           %NextX = PreX + S* (rand(D,1) *(Xs-Xx)+Xx);
            Z = func4(T,D,m);
            NextX = PreX + Z;
            %%%%%%%%%%%%%%%%%�߽���������%%%%%%%%%%%%%%%%%%%%%%%%%%
            %for ii=1:D
            %    if NextX(ii)>Xs | NextX(ii)<Xx
            %        NextX(ii)=PreX(ii) + S* (rand *(Xs-Xx)+Xx);
            %    end
            %end
            %%%%%%%%%%%%%%%%%�Ľ��߽���������%%%%%%%%%%%%%%%%%%%%%%%%%%
            for ii=1:D
                if  NextX(ii)<Xx
                    NextX(ii)=Xx + mod((Xx-Z(ii)),(Xs-Xx));
                else 
                    if NextX(ii)>Xs
                    NextX(ii)=Xs - mod((Z(ii)-Xs),(Xs-Xx));
                    end
                end
            end 
        %%%%%%%%%%%%%%%%%%%%%%%�Ƿ�ȫ�����Ž�%%%%%%%%%%%%%%%%%%%%%%
        if (func1(BestX) > func1(NextX))
            %%%%%%%%%%%%%%%%%%������һ�����Ž�%%%%%%%%%%%%%%%%%%%%%
            PreBestX = BestX;
            %%%%%%%%%%%%%%%%%%%��Ϊ�µ����Ž�%%%%%%%%%%%%%%%%%%%%%%
            BestX=NextX;
        end
        %%%%%%%%%%%%%%%%%%%%%%%% Metropolis����%%%%%%%%%%%%%%%%%%%
        if( func1(PreX) - func1(NextX) > 0 )
            %%%%%%%%%%%%%%%%%%%%%%%�����½�%%%%%%%%%%%%%%%%%%%%%%%%
            PreX=NextX;
            P=P+1;
        else
            changer = -1*(func1(NextX)-func1(PreX))/ T ;
            p1=exp(changer);
            %%%%%%%%%%%%%%%%%%%%%%%%���ܽϲ�Ľ�%%%%%%%%%%%%%%%%%%%%
            if p1 > rand        
                PreX=NextX;
                P=P+1;         
            end
        end
    trace(P+1)=func1( BestX);    
    end
    deta=abs( func1( BestX)-func1 (PreBestX)); 
    
    if k==1
       T=T;
    else
        if k>1
        T=T*((k-1)/k)^m;
        end
    end
    k=k+1;
end
disp('��Сֵ�ڵ�:');
BestX
disp( '��СֵΪ:');
func1(BestX)
figure
plot(trace(2:end))
xlabel('��������')
ylabel('Ŀ�꺯��ֵ')
title('�Ľ�����-��Ӧ�Ƚ�������')