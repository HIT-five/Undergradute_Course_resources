function [ bImage ] = getCurveImage( ScanLine )
%GETCURVEIMAGE Summary of this function goes here
%   Detailed explanation goes here
kgrid = evalin('base','kgrid');
Nx = kgrid.Nx;%512
Ny = kgrid.Ny;%400
x_vec = kgrid.x_vec;
y_vec = kgrid.y_vec;

brightness = zeros(Nx,Ny);

angleMin = ScanLine(1).angle;%结构体中的最小角是第一个
angleMax = ScanLine(end).angle;%最大角度是最后一组数据
dAngle = ScanLine(2).angle - ScanLine(1).angle;%角度差
distance = ScanLine(1).distance;
distanceMin = min(distance);
distanceMax = max(distance);
dDistance = distance(2) - distance(1);%距离差
coorCenter = ScanLine(1).coorCenter;

for i = 1:Nx
    for j = 1:Ny
        
        xPosPix = x_vec(i);
        yPosPix = y_vec(j);
        coorPix = [yPosPix xPosPix];
        distancePix = norm(coorPix - coorCenter);
        anglePix = asin(yPosPix/distancePix);
        if anglePix < angleMin || anglePix > angleMax || distancePix < distanceMin || distancePix > distanceMax
            continue;
        end
        numLine1 = floor((anglePix - angleMin)/dAngle)+1;
        numLine2 = ceil((anglePix - angleMin)/dAngle)+1;
        numDistance1 = floor((distancePix-distanceMin)/dDistance)+1;
        numDistance2 = ceil((distancePix-distanceMin)/dDistance)+1;
        ang1 = ScanLine(numLine1).angle;
        ang2 = ScanLine(numLine2).angle;
        d1 = distance(numDistance1);
        d2 = distance(numDistance2);
        v11 = ScanLine(numLine1).data_bf_env(numDistance1);
        v12 = ScanLine(numLine1).data_bf_env(numDistance2);
        v21 = ScanLine(numLine2).data_bf_env(numDistance1);
        v22 = ScanLine(numLine2).data_bf_env(numDistance2);
        brightness(i,j) = v11*(ang2-anglePix)*(d2-distancePix)+...
                              v12*(ang2-anglePix)*(-d1+distancePix)+...
                              v21*(-ang1+anglePix)*(d2-distancePix)+...
                              v22*(-ang1+anglePix)*(-d1+distancePix);
        brightness(i,j) =  brightness(i,j)/dAngle/dDistance;             
        
        
    end
end
bImage.lateralAxis = y_vec;
bImage.depthAxis = x_vec - min(x_vec);
bImage.brightness = brightness;


end

