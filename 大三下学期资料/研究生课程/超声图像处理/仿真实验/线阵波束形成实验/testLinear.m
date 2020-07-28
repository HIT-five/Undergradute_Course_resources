clear all;
clc;
%AptData是包含发射接收的各个孔径数据
load('AptDatasave.mat');
%查看一下接收孔径数据情况：
figure();
plot(AptData(32).data())

depthStart = 5/1000; 
depthEnd = 45/1000;
dDepth = 1.000000000000000e-04;
ScanLine = getLinearScanLine( AptData, depthStart, depthEnd, dDepth );
%查看一下经过波束形成之后的扫描线情况
figure();
plot(ScanLine(32).data_bf_env)

bImage = getLinearImage(ScanLine);

figure();
imagesc(1000*bImage.lateralAxis,1000*bImage.depthAxis,bImage.brightness);
axis('image');colormap(gray(128));
title('B-mode Image by Linear Transducer');