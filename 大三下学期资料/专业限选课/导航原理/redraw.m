    lon  =str2num(get(lonbox, 'string'));   % Longitude (degree)
    lat  =str2num(get(latbox, 'string'));   % Latitude (degree)
    head =str2num(get(hdbox,  'string'));   % Heading (degree)
    pitch=str2num(get(ptbox,  'string'));   % Pitching (degree)
    roll =str2num(get(rlbox,  'string'));   % Rolling (degree)
        
        


        %vtx=vtx0;%在机体坐标系里定位的位置
        
        CEG0 = zeros(3,3);
        CEG0(1,2)=1;
        CEG0(2,3)=1;
        CEG0(3,1)=1;
        %lon = 60;
        CG1G0 = zeros(3,3);
        CG1G0(1,1) = cosd(lon);
        CG1G0(1,3) = -sind(lon);
        CG1G0(2,2) = 1;
        CG1G0(3,1) = sind(lon);
        CG1G0(3,3) = cosd(lon);
        %lat = 60;
        CG2G1 = zeros(3,3);
        CG2G1(1,1) = 1;
        CG2G1(2,2) = cosd(lat);
        CG2G1(2,3) = -sind(lat);
        CG2G1(3,2) = sind(lat);
        CG2G1(3,3) = cosd(lat);
        %head = 60;
        CB0G2 = zeros(3,3);
        CB0G2(1,1) = cosd(head);
        CB0G2(1,2) = sind(head);
        CB0G2(2,1) = -sind(head);
        CB0G2(1,1) = cosd(head);
        CB0G2(3,3) = 1;
        %pitch = 60;
        CB1B0 = zeros(3,3);
        CB1B0(1,1) = 1;
        CB1B0(2,2) = cosd(pitch);
        CB1B0(2,3) = sind(pitch);
        CB1B0(3,2) = -sind(pitch);
        CB1B0(3,3) = cosd(pitch);
        %roll = 60;
        CB2B1 = zeros(3,3);
        CB2B1(1,1) = cosd(roll);
        CB2B1(1,3) = -sind(roll);
        CB2B1(2,2) = 1;
        CB2B1(3,1) = sind(roll);
        CB2B1(3,3) = cosd(roll);
        
        CEB = CB2B1*CB1B0*CB0G2*CG2G1*CG1G0*CEG0;%3*3
        CEB1 = pinv(CEB);
        vtx1 = vtx0';
        vtx2 = CEB1*vtx1;
        vtx = vtx2';
        pos  = 12*[cosd(lat)*cosd(lon) cosd(lat)*sind(lon) sind(lat)];
        vtx  = vtx + ones(size(vtx))*diag(pos);
%         vtx(:,1) = vtx(:,1)+re*cosd(lat)*cosd(lon);
%         vtx(:,2) = vtx(:,2)+re*cosd(lat)*sind(lon);
%         vtx(:,3) = vtx(:,3) + re*sind(lat);
%         
%         
        
        
        set(phd,'Vertices',vtx);

        view(lon+90+aza,lat+ela-90)
        
        lightpos1=15*[cosd(lat)*cosd(lon-40)     cosd(lat)*sind(lon-40)     sind( lat)];
        lightpos2=15*[cosd(lat)*cosd(lon-20-180) cosd(lat)*sind(lon-20-180) sind(-lat)];

        set(lhd1,'position',lightpos1);
        set(lhd2,'position',lightpos2);



        

