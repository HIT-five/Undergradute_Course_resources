%%%%%%%%%f(x，y)=%%%%%%%%%
clear all;              %清除所有变量
close all;              %清图
clc;                    %清屏
x=-5.12:0.06:5.12;
y=-5.12:0.06:5.12;
N=size(x,2);
%[x,y]=meshgrid(-5.12:0.1:5.12,-5.12:0.1:5.12);
for i=1:N
    for j=1:N
         z(i,j)=10*2+(x(i)^2-10*cos(x(i)*2*pi))+(y(j)^2-10*cos(y(j)*2*pi));
    end
end
mesh(x,y,z);
%colormap(gray(1))
xlabel('x')
ylabel('y')