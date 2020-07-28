clear all;
clc;
%AptData�ǰ���������յĸ����׾�����
load('AptDatasave.mat');
%�鿴һ�½��տ׾����������
figure();
plot(AptData(32).data())

depthStart = 5/1000; 
depthEnd = 45/1000;
dDepth = 1.000000000000000e-04;
ScanLine = getLinearScanLine( AptData, depthStart, depthEnd, dDepth );
%�鿴һ�¾��������γ�֮���ɨ�������
figure();
plot(ScanLine(32).data_bf_env)

bImage = getLinearImage(ScanLine);

figure();
imagesc(1000*bImage.lateralAxis,1000*bImage.depthAxis,bImage.brightness);
axis('image');colormap(gray(128));
title('B-mode Image by Linear Transducer');