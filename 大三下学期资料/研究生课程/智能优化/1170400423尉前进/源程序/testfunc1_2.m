%%%%%%%%%f(x，y)=%%%%%%%%%
clear all;              %清除所有变量
close all;              %清图
clc;                    %清屏
x=-5:0.06:5;
y=-5:0.06:5;
N=size(x,2);
%[x,y]=meshgrid(-5.12:0.1:5.12,-5.12:0.1:5.12);
for i=1:N
    for j=1:N
         z(i,j)=-20*exp(-0.2*sqrt(0.5*(x(i)^2+y(j)^2)))-exp(0.5*(cos(x(i)*2*pi)+cos(y(j)*2*pi)))+exp(1)+20;
    end
end
mesh(x,y,z);
%colormap(gray(1))
xlabel('x')
ylabel('y')