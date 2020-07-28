%绘制控制量数据曲线
plot(0:0.002:5,u,'-g','LineWidth',1.0)
grid on;
handle_legend=legend('控制量信号');
xlabel('时间/s');
ylabel('电压/V');
u_max = max(u);
u_min = min(u);
set (handleA_scope,'YLim',[1.2*u_min-1 1.2*u_max+1]);
set (handle_legend,'Units','normalized','Position',[0.8 0.85 0.18 0.1])