close all;
clc
fs = 1000;
T = 1/fs;
data = xlsread('./3.xlsx');
[m,n]=size(data);
Voletge = data(:,n-3);
freq = data(:,n-2);
Out_put_angle = data(:,n);
% figure(1)
% plot(1:m,V,'-r','LineWidth',1.0);
% hold on
% title('输入电压曲线')
% figure(2)
% plot(1:m,y,'-b','LineWidth',1.0);
% hold on
% title('输出角度曲线')



start_index = ones(1,29);%存每一段频率开始的索引，初值赋为1
end_index = zeros(1,29);%存每一段频率结束的索引
%sweep_length = ones(1,29);
for i = 1:9
    for k=1:m
        if freq(k)>0.1*i
            end_index(i)=k;
            break
        end
    end
end
for i=1:19
    for k = 1:m
        if freq(k)>i
            end_index(i+9)=k;
            break
        end
    end
end

end_index(29)=m;
start_index(2:29)=end_index(1:28)+1;%start_index(1)=1
every_data_length = end_index-start_index+1;

data_input_Voletge = zeros(1,max(every_data_length));
data_output_angle = zeros(1,max(every_data_length));
Rem = zeros(1,29);
Amp_Voletge_max = zeros(2,29);%第一行为每段FFT得到的最大幅值，第二行是最大幅值对应的频率点，以便求得相角
Amp_Output_max = zeros(2,29);%第一行为每段FFT得到的最大幅值，第二行是最大幅值对应的频率点，以便求得相角

Amp_ratio = zeros(1,29);
Pha_sub = zeros(1,29);

Actual_deal_length = zeros(1,29);
for i = 1:29
    data_input_Voletge=Voletge(start_index(i):end_index(i));
    data_output_angle=Out_put_angle(start_index(i):end_index(i));
    
    Rem(i) = every_data_length(i)-rem(every_data_length(i),10);
    t = (0.2*Rem(i):0.6*Rem(i))*T;
%     figure(3)
%     subplot(2,1,1)
%     plot(t,sweep_data_input(0.2*L(i):0.6*L(i)))
%     subplot(2,1,2)
%     plot(t,sweep_data_output(0.2*L(i):0.6*L(i)))
%     grid on;
%     title(i)
    
    
    Actual_deal_length(i) = 0.4*Rem(i);%每个频率实际处理的数据长度，也是采样点个数，为了避免出现数据不全的现象
    Y = fft(data_output_angle(0.2*Rem(i):0.6*Rem(i)));%计算输出角度的傅里叶变换
    Amplitude2y = abs(Y/Actual_deal_length(i));%计算双侧频谱
    AOutput = 2*Amplitude2y(1:Actual_deal_length(i)/2);%计算单侧频谱幅值
    PhaseAngle2y = angle(Y);
    POutput = PhaseAngle2y(1:Actual_deal_length(i)/2);
    V = fft(data_input_Voletge(0.2*Rem(i):0.6*Rem(i)));%计算输入电压的傅里叶变换
    Amplitude2v = abs(V/Actual_deal_length(i));%计算双侧频谱P2.
    AVoletge = 2*Amplitude2v(1:Actual_deal_length(i)/2);

    PhaseAngle2v = angle(V);
    PVoletge = PhaseAngle2v(1:Actual_deal_length(i)/2);

    
    [Amp_Voletge_max(1,i),Amp_Voletge_max(2,i)]=max(AVoletge);
    %Amp_Voletge_max(2,i)=find(Amp_Voletge_max(1,i)==max(AVoletge);
    [Amp_Output_max(1,i),Amp_Output_max(2,i)]=max(AOutput);
    
    POutput = POutput*180/pi;
    PVoletge = PVoletge*180/pi;
    
    Amp_ratio(i) = Amp_Output_max(1,i)/Amp_Voletge_max(1,i);
    Pha_sub(i) = POutput(Amp_Output_max(2,i)) - PVoletge(Amp_Voletge_max(2,i));   
end
for i=2:1:28
    if Pha_sub(i) > Pha_sub(i-1) + 180
        Pha_sub(i)=Pha_sub(i)-360 ;
    end
end
Pha_sub(9)=Pha_sub(9)-10;
Pha_sub(29)=Pha_sub(29)-240;
Pha_sub(26)=Pha_sub(26)-120;
w = 20*log10(Amp_ratio);
freq1 =2*pi* [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
subplot(2,1,1)
plot(freq1,w)
set(gca,'xscale','log')
grid on
title('幅频特性')
subplot(2,1,2)
plot(freq1,Pha_sub)
set(gca,'xscale','log')
xlabel=('w(rad/s)');
ylabel=('deg');
title('相频特性')
grid on
 



