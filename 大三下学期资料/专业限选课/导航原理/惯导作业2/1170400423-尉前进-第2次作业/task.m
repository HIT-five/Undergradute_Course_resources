%Data initialization
%TN: Total time required for aircraft operation; R: arth radius; wie: Earth rotation angular velocity; dT: the cycle of coordinate updating outer cycle; dt: the cycle of coordinate updating inner cycle; K: the number of updates per second; Gyro_pulse: angular increment of gyro pulse; Acc_pulse: pulse of accelerometer; g: acceleration of gravity on the earth's surface. 
TN=7516;              
R=6371000;                            
wie=7.292e-5;              
dT=0.04;                      
dt=0.002;
K= TN /dT;                    
k=dT/dt; 
g=9.780327;
Gyro_pulse=0.01/3600/180*pi;
Acc_pulse=9.780327/10000000;

%Q: Quaternions representing attitude transformation for each large cycle 
Q=zeros(K+1,4);
% Quaternion Initial Value
e0=-25*pi/180;              
Q(1,:)=[cos(e0/2),0,0,sin(e0/2)]; 
% Longitudinal, Latitude and Height Values for Each Large Cycle 
LonM=zeros(1,K+1);
LatM=zeros(1,K+1);
HtM=zeros(1,K+1);
% Initial value of location information
LonM(1)=118.05;
LatM(1)=24.27;
HtM(1)=120;
% Define the specific force matrix, initial 0
fx=zeros(1,K+1);
fy=zeros(1,K+1);
fz=zeros(1,K+1);
% Define the velocity matrix in all directions, initially 0.
Ve=zeros(1,K+1);    
Vn=zeros(1,K+1);    
Vu=zeros(1,K+1);    
% Define attitude matrix as zero matrix
heading=zeros(615801,1);         
pitch=zeros(615801,1);           
roll=zeros(615801,1);
% Data measured by loading gyroscope and accelerometer
load('HB2020.mat')
AR0=[0 0 0];
for N=1:K         % Geographic coordinate system updating
    q=zeros(k+1,4);
    q(1,:)=Q(N,:);
    for n=1:k             % Attitude updating
        w=Gyro_pulse*GMM((N-1)*k+n,:);  % Take the output angle increment of gyroscope in small cycle
        w_mod=norm(w);
        S=1/2-w_mod^2/48;  
        C=1-w_mod^2/8+w_mod^4/384;  
        q(n+1,:)=quatmultiply( q(n,:),[C S*w] );  % Fourth-Order Approximate Picca Solution of Angular Incremental Algorithms 
        [h,p,r]=quat2angle(q(n,:));    % Converting Quaternion into Euler Angle by Quadrangle Function 
        heading((N-1)*k+n,1)=h/pi*180;
        pitch((N-1)*k+n,1)=p/pi*180;
        roll((N-1)*k+n,1)=r/pi*180; 
    end  % End the Inner Attitude Renewal Cycle
Q(N+1,:)=q(n+1,:); % Quaternion at End of Inner Attitude Updating Cycle
% Perfect the transformation of quaternions into Euler angles
    [hn,pn,rn]=quat2angle(Q(K+1,:));
    heading(615801,1)=hn/pi*180;
    pitch(615801,1)=pn/pi*180;
    roll(615801,1)=rn/pi*180;  
% Two-step attitude determination in strapdown inertial navigation system
Wie=[0 wie*cos(LatM(N)/180*pi) wie*sin(LatM(N)/180*pi)];
WE=-Vn(N)/(R+HtM(N));
    WN=Ve(N)/(R+HtM(N))+wie*cos(LatM(N)/180*pi);
WU=Ve(N)/(R+HtM(N))*tan(LatM(N)/180*pi)+wie*sin(LatM(N)/180*pi);   
gh=g*(1+0.0053024*(sin(LatM(N)/180*pi))^2-0.0000058*sin(2*LatM(N)/180*pi)^2)-(3.086e-6)*HtM(N);  % Gravity acceleration affected by altitude and latitude 
    Wig=[WE WN WU];
    Wig_mod=norm([WE,WN,WU]);
    n=Wig/Wig_mod;
    Qg=[cos(Wig_mod*dT/2),sin(Wig_mod*dT/2)*n];
    Q(N+1,:)=quatmultiply(quatinv(Qg),Q(N+1,:)); % Quaternions Updated in Geographic Coordinate System
    % Take the specific force data measured by accelerometer
    fb=Acc_pulse*AMM(N,:);
    f1=quatmultiply(Q(N+1,:),[0,fb]);
    fg=quatmultiply(f1,quatinv(Q(N+1,:)));
    fx(N)=fg(2);
    fy(N)=fg(3); 
    fz(N)=fg(4);
% Compensation for harmful acceleration
AR=[fx(N) fy(N) fz(N)] - cross( Wie+Wig, [Ve(N) Vn(N) Vu(N)]) - [ 0 0 gh];
% Velocity solution  
Ve(N+1)=(AR(1)+AR0(1))/2*dT+Ve(N);
Vn(N+1)=(AR(2)+AR0(2))/2*dT+Vn(N);
Vu(N+1)=(AR(3)+AR0(3))/2*dT+Vu(N);
AR0=AR;
% Update location information
LatM(N+1)=(Vn(N)+Vn(N+1))/2*dT/(R+HtM(N))/pi*180+LatM(N);
LonM(N+1)=(Ve(N)+Ve(N+1))/2*dT/((R+HtM(N))*cos(LatM(N)/180*pi))/pi*180+LonM(N);
HtM(N+1)=(Vu(N)+Vu(N+1))/2*dT+HtM(N);
end  % End the Outer Geographic Coordinate System Renewal Cycle

HPRatt=[heading,pitch,roll];

% Drawing Longitudinal and Latitude Images
figure(1);
title('Latitude-Lontitude');
xlabel('Latitude');
ylabel('Lontitude');
grid on;
hold on;
plot(LonM,LatM);
% Drawing Height Images
figure(2);
title('height-time');
xlabel('time');
ylabel('height');
grid on;
hold on;
plot((0:K),HtM);
% Drawing Attitude Angle Change Map
figure(3);
plot(heading);
xlabel('time');
ylabel('heading');
title('heading-time');
grid on;
figure(4);
plot(pitch);
xlabel('time');
ylabel('pitching');
title('pitching-time');
grid on;
figure(5);
plot(roll);
xlabel('time');
ylabel('rolling');
title('rolling-time');

% Output final quaternion, velocity in all directions and aircraft position 
Q(K+1,:);
LatM(K+1);
LonM(k+1);
HtM(K+1);
Ve(K+1);
Vn(K+1);
Vu(K+1);
save FlightData HPRatt LonM LatM HtM 