%���������������
plot(0:0.002:5,r,'-r','LineWidth',1.0)
hold on;
plot(0:0.002:5,y,'-b','LineWidth',1.0);
grid on;
handle_legend=legend('�����ź�','���λ��');
xlabel('ʱ��/s');
ylabel('λ��/��');
y_max = max(y);
y_min = min(y);
set (handleA_scope,'YLim',[1.2*y_min-1 1.2*y_max+1]);
set (handle_legend,'Units','normalized','Position',[0.8 0.85 0.18 0.1])