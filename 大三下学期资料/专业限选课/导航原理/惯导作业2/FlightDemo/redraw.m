    upintv=str2num(get(upbox,'string'));   

    hmax=max(HtM);
    if   hmax>100000, viewmax=0.4;
    else viewmax=0.1;
    end   

    full_lth=max(max(vtx0));

    tic;
    i=i0;

    while i<=K1
        head =HPRM(i,1);
        pitch=HPRM(i,2);
        roll =HPRM(i,3);
        lon  =LonM(i);
        lat  =LatM(i);

        VM=[1 0;  1 hmax];
        CA=inv(VM)*[0.002 viewmax]';
        
        fht=abs(HtM(i)-HtM(1));
        viewangle =[1 fht]*CA;
        viewground=[1   0]*CA;

        sizerauto=sizerground*(viewangle/viewground);
        sizer=sizerauto*sizerscale;
        rh=re+HtM(i)+sizer*full_lth;

        pos       = rh*[cosd(lat)*cosd(lon) cosd(lat)*sind(lon) sind(lat)];
        
        lightpos1=(rh+HtM(i)/6371000)*[cosd(lat)*cosd(lon-40)     cosd(lat)*sind(lon-40)     sind( lat)];
        lightpos2=(rh+HtM(i)/6371000)*[cosd(lat)*cosd(lon-20-180) cosd(lat)*sind(lon-20-180) sind(-lat)];
        targetpos=(rh+HtM(i)/6371000)*[cosd(lat)*cosd(lon) cosd(lat)*sind(lon) sind(lat)];

        qhd=[cosd(head/2)  -sind(head/2)*[  0  0  1]];
        qpt=[cosd(pitch/2) -sind(pitch/2)*[ 1  0  0]];
        qrl=[cosd(roll/2)  -sind(roll/2)*[ 0  1  0]];
    
        qlon=[cosd(lon/2) -sind(lon/2)*[ 0 1 0]];  % rotation around local north
        qlat=[cosd(lat/2) -sind(lat/2)*[-1 0 0]];  % rotation around local west

        vtx=sizer*vtx0;                                         % resize the body
        vtx=quatrotate(qhd,quatrotate(qpt,quatrotate(qrl,vtx)));   % body rotation
        vtx=quatrotate(qlon,quatrotate(qlat,vtx));                 % initial geo -> current geo
        vtx=quatrotate(qsky,quatrotate(qeast,vtx));                % Earth --> initial geo
    
        vtx=vtx+ones(size(vtx))*diag(pos);
        JetColor=[.75 .75 .75];
        
        if draw1st==1, 
           phd=patch('Vertices',vtx, 'Faces', faceM, 'FaceVertexCData', vtxcolor, 'FaceColor', 'flat','Edgecolor','flat', ...
                     'FaceLighting','Gouraud','Edgelighting','Gouraud','EdgeAlpha',0);
        else
           if chgmodel==0,
              set(phd,'Vertices',vtx);
           else
              set(phd,'Vertices',vtx, 'Faces', faceM, 'FaceVertexCData', vtxcolor);
              chgmodel=0;
           end
        end

        view(lon+90+aza,lat+ela-90)
        set(gca,'Cameratarget',targetpos, 'Cameraviewangle',st*viewangle);

        if draw1st==1
          lhd1 =light('position',lightpos1);
          lhd2 =light('position',lightpos2);
        else
          set(lhd1,'position',lightpos1);
          set(lhd2,'position',lightpos2);
        end

        set(showhd, str, num2str(head));
        set(showpt, str, num2str(pitch));
        set(showrl, str, num2str(roll));
        set(showln, str, num2str(lon));
        set(showlt, str, num2str(lat));
        set(showht, str, num2str(HtM(i)));
        set(showtm, str, num2str(i));

        if pausemode==0,  drawnow; % limitrate;  
        else, 
            while pausemode==1,
                  pause(0.2);
            end 
        end
        
        if K1~=1 & rem(i,20*upintv)==1, fps=(20)/toc; set(fpsbox,'string',num2str(fps));  tic; end
        
        i=i+upintv;

    end

    K1=1;
    