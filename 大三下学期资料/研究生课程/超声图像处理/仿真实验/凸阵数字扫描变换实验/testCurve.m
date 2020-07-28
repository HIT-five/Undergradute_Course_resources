clear all;
clc;
load('ScanLinesave.mat');
%ScanLine是波束合成之后的凸阵线数据
bImage = getCurveImage(ScanLine);

figure();
imagesc(1000*bImage.lateralAxis,1000*bImage.depthAxis,bImage.brightness);
axis('image');colormap(gray(128));
title('B-mode Image by Linear Transducer');
