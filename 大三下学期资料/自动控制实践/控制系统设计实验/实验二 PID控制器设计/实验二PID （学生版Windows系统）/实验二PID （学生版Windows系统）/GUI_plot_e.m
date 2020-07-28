%绘制误差数据曲线
e = r-y;
plot(0:0.002:5,e,'-r','LineWidth',1.0)
grid on;
handle_legend=legend('误差信号');
xlabel('时间/s');
ylabel('位置/°');
e_max = max(e);
e_min = min(e);
set (handleA_scope,'YLim',[1.2*e_min-1 1.2*e_max+1]);
set (handle_legend,'Units','normalized','Position',[0.8 0.85 0.18 0.1])