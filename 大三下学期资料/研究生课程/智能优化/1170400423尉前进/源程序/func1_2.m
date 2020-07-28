function result=func1_2(x)
d=length(x);
summ=10*d+sum(x.^2-10*cos(x.*2*pi));
result=summ;
