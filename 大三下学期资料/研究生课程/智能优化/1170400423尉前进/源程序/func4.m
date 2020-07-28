function result_1 = func4(T,D,m)
%FUNC4 此处显示有关此函数的摘要
%   此处显示详细说明
W = -1+2*rand(D,1);
U = rand(D,1);
s = sqrt(sum(power(W,2)));
t= ones(D,1);
U1 = U.^m;
s1 =t ./U1;
uu = (s1 - 1);
result_1 = W*T.*uu/s;
end

