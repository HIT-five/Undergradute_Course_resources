function [ bImage ] = getLinearImage( ScanLine )
%GETLINEARIMAGE Summary of this function goes here
%   Detailed explanation goes here

nLine = length(ScanLine);
nPix = size(ScanLine(1).coordinate,1);
lateralAxis = linspace(ScanLine(1).coordinate(1,1),ScanLine(end).coordinate(1,1),nLine);
depthAxis = ScanLine(1).coordinate(:,2);
brightness = zeros(nPix,nLine);

for i = 1:nLine
    brightness(:,i) = ScanLine(i).data_bf_env;
end

bImage.lateralAxis = lateralAxis;
bImage.depthAxis = depthAxis;
bImage.brightness = brightness;

end

