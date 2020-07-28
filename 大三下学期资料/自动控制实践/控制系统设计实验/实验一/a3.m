data1 = xlsread('./4.xlsx');
% idx = find(isnan(data1));
% data1(idx)=0;
[m,n]=size(data1);
%V = data(:,n-3);
%f_fft = data(:,n-2);
%y = data(:,n);
idx=find(isnan(data1)); % find all NaN value 
data1(idx)=0; % set 0 to these indexes 
fs=1000; % 采样频率
dt=1/fs;
f_5=5/4;
t=0; %循环计数器
for f=0.1:0.1:20 
    index=find(abs(f-data1(:,3))<0.001);%寻找特定频率的数据索引
        t=t+1;
        if (f<f_5)
            sub1=round(1000/f)+1;
        else
            sub1=round(1000*0.75)+1;
        end
        freq(t)=f;
    sub2=sub1+500;
    Data=data1(index(1)+sub1:index(length(index))-sub2,:);
    num=length(Data);
    N=0;
    while (num>1)  %找到N
        num=floor(num/2);
        N=N+1;
    end
    sub3=floor((length(Data)-2^N)/2);
    sub4=(length(Data)-2^N)-sub3;
    Data=Data(sub3+1:length(Data)-sub4,:);
    Voletge=fft(Data(:,2));
    Velocity=fft(Data(:,5));
    AVoletge=abs(Voletge);
    AVelocity=abs(Velocity);
    PVoletge=angle(Voletge)*180/pi;
    PVelocity=angle(Velocity)*180/pi;
    num1=find(Voletge==max(Voletge));
    k=num1(1,1);
    Amp_ratio(t)=AVelocity(k)/AVoletge(k);
    Pha_sub(t)=PVelocity(k)-PVoletge(k);
    APha_sub(t)=(PVelocity(k)-PVoletge(k))*57.3;
    
end
    figure
    plot(freq,Amp_ratio);
    %set(gca,'xscale','log');
    title('幅频特性');
    grid on
    hold on
    figure
    plot(freq,Pha_sub);
    %set(gca,'xscale','log');
    title('相频特性');
    grid on