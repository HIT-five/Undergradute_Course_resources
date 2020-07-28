function [ ScanLine ] = getLinearScanLine( AptData, depthStart, depthEnd, dDepth )
%GETLINEARSCANLINE Summary of this function goes here
%   Detailed explanation goes here


c = 1540; %ÉùËÙ
dt = 2.500000000000000e-08;

nLine = length(AptData);
yPosLine = depthStart:dDepth:depthEnd;
nPix = length(yPosLine);


for i = 1:nLine
    
    numElmLeft = AptData(i).numElmLeft;
    nElm = AptData(i).number;
    numCenterElement = AptData(i).numCenterElement;
    coorElm = AptData(i).coordinate;
    coorCenterElm = coorElm(numCenterElement-numElmLeft+1,:);
    coorLine = [ repmat(coorCenterElm(1),nPix,1) yPosLine'];
    
    timeDelay = AptData(i).timeDelay;
    delay = timeDelay(numCenterElement-numElmLeft+1);
    
    dataRaw = AptData(i).data;
    data_beamform = zeros(nPix,1);
    for j = 1:nPix
        pathForward = yPosLine(j);
        for k = 1:nElm
            pathBack = norm(coorLine(j,:) - coorElm(k,:));
            numt = round((delay+(pathForward+pathBack)/c)/dt);
            data_beamform(j) = data_beamform(j) +  dataRaw(k,numt);
    end
    
    ScanLine(i).coordinate = coorLine;
    ScanLine(i).data_bf = data_beamform;
    ScanLine(i).data_bf_env = abs(hilbert(data_beamform));
    
end

end

