stfull=get(gca,'CameraViewAngle')/viewground;

aa=stfull^0.005;
st=stfull;
for ii=1:200
    pause(0.03)
    st=st/aa;
    set(gca,'Cameraviewangle',st*viewangle)
end
%   set(gca,'Cameraviewangle',st*viewangle)
