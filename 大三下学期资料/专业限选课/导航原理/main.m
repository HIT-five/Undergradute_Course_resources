clear

   load ModelData;    % containing map data: Xm Ym Zm, and jet model data: vtx0, vtxcolor and faceM 
  
   fhd=figure('position',[100 1 1200 700], 'color',[0 0 0],'name','3D Flight Demo (by Zhenxian Fu, HIT)');
   re=10;

    rball=0.9999*re;
    ballcolor=[0.3 .7 1];
   [xs, ys, zs]=sphere(120);
    shd=surf(rball*xs,rball*ys,rball*zs, 'facecolor',ballcolor,'edgecolor',ballcolor, ...
            'FaceLighting','Gouraud','Edgelighting','Gouraud','Backfacelighting','unlit','EdgeAlpha',0); 
    alim=15;
    set(gca,'position',[0.1 0.05 0.8 0.9],'xlim',[-alim alim], 'ylim', [-alim  alim], 'zlim', [-alim alim]);
    set(gca, 'DataAspectRatio',[1 1 1], 'DataAspectRatioMode','Manual', 'CameraViewAngle',3.5,'CameraViewAngleMode','Manual');
    axis off;
    hold on;

    linecolor=[.7 .7 .7];
    latim=-80:10:80;                          % latitude grid
    longm=[0:1:360]';
    x1=re*cosd(longm)*cosd(latim);
    y1=re*sind(longm)*cosd(latim);
    z1=re*ones(length(longm),1)*sind(latim);
    lathd=plot3(x1,y1,z1,'color',linecolor);

    longm=-170:10:180;                           % longitude grid
    latim=[-80:1:80]';                              
    x1=re*cosd(latim)*cosd(longm);
    y1=re*cosd(latim)*sind(longm);
    z1=re*sind(latim)*ones(1,length(longm));
    lonhd=plot3(x1,y1,z1,'color',linecolor);
 
    textstr=[];
    for i=1:length(longm)
        textstr=strvcat(textstr,num2str(longm(i)));
    end
    rt=1.01;
    x1=rt*re*cosd(longm);
    y1=rt*re*sind(longm);
    z1=zeros(1,length(longm));
    text(x1,y1,z1, textstr);
    
    maphd=plot3(re*Xm,re*Ym,re*Zm,'k');   % drawing coast-line map

%   ===== next for GUI =================
    stl='style'; edt='edit'; txt='text'; btn='button'; pix='pixels'; nrm='normal'; bck='back';
    ps='position'; unt='unit'; str='string';
 
    btd=.95/6;  bth=0.8/6; btmh=0.01; btw=0.8; lbw=0.35;
    poshd=  uipanel(fhd,'title','Î»ÖÃ×ËÌ¬',ps,[0.01 0.69 0.12 0.3]);
    
    lat=40;
    lon=150;
    head=0;
    pitch=0;
    roll=0;
    
            uicontrol(poshd,stl,txt,unt,nrm,ps,[.05 btmh+5*btd lbw bth], bck,[.81 .81 .81],  str, '¾­¶È');
    lonbox =uicontrol(poshd,stl,edt,unt,nrm,ps,[.45 btmh+5*btd .2 bth],  bck,[.95 .95 .95],  str, num2str(lon));
            uicontrol(poshd,unt,nrm,ps,        [.68 btmh+5*btd .15 bth], bck,[.81 .81 .81],  str, '+', 'callback','idbox=1; inc= 5; chgpos; redraw');
            uicontrol(poshd,unt,nrm,ps,        [.85 btmh+5*btd .15 bth], bck,[.81 .81 .81],  str, '-', 'callback','idbox=1; inc=-5; chgpos; redraw');

            uicontrol(poshd,stl,txt,unt,nrm,ps,[.05 btmh+4*btd lbw bth], bck,[.81 .81 .81],  str, 'Î³¶È');
    latbox =uicontrol(poshd,stl,edt,unt,nrm,ps,[.45 btmh+4*btd .2 bth],  bck,[.95 .95 .95],  str, num2str(lat));
            uicontrol(poshd,unt,nrm,ps,        [.68 btmh+4*btd .15 bth], bck,[.81 .81 .81],  str, '+', 'callback','idbox=2; inc= 5; chgpos; redraw');
            uicontrol(poshd,unt,nrm,ps,        [.85 btmh+4*btd .15 bth], bck,[.81 .81 .81],  str, '-', 'callback','idbox=2; inc=-5; chgpos; redraw');

            uicontrol(poshd,stl,txt,unt,nrm,ps,[.05 btmh+3*btd lbw bth], bck,[.81 .81 .81],  str, 'º½Ïò');
    hdbox  =uicontrol(poshd,stl,edt,unt,nrm,ps,[.45 btmh+3*btd .2 bth],  bck,[.95 .95 .95],  str, num2str(head));
            uicontrol(poshd,unt,nrm,ps,        [.68 btmh+3*btd .15 bth], bck,[.81 .81 .81],  str, '+', 'callback','idbox=3; inc= 5; chgpos; redraw');
            uicontrol(poshd,unt,nrm,ps,        [.85 btmh+3*btd .15 bth], bck,[.81 .81 .81],  str, '-', 'callback','idbox=3; inc=-5; chgpos; redraw');

            uicontrol(poshd,stl,txt,unt,nrm,ps,[.05 btmh+2*btd lbw bth], bck,[.81 .81 .81],  str, '¸©Ñö');
    ptbox  =uicontrol(poshd,stl,edt,unt,nrm,ps,[.45 btmh+2*btd .2 bth],  bck,[.95 .95 .95],  str, num2str(pitch));
            uicontrol(poshd,unt,nrm,ps,        [.68 btmh+2*btd .15 bth], bck,[.81 .81 .81],  str, '+', 'callback','idbox=4; inc= 5; chgpos; redraw');
            uicontrol(poshd,unt,nrm,ps,        [.85 btmh+2*btd .15 bth], bck,[.81 .81 .81],  str, '-', 'callback','idbox=4; inc=-5; chgpos; redraw');

            uicontrol(poshd,stl,txt,unt,nrm,ps,[.05 btmh+1*btd lbw bth], bck,[.81 .81 .81],  str, '¹ö¶¯');
    rlbox  =uicontrol(poshd,stl,edt,unt,nrm,ps,[.45 btmh+1*btd .2 bth],  bck,[.95 .95 .95],  str, num2str(roll));
            uicontrol(poshd,unt,nrm,ps,        [.68 btmh+1*btd .15 bth], bck,[.81 .81 .81],  str, '+', 'callback','idbox=5; inc= 5; chgpos; redraw');
            uicontrol(poshd,unt,nrm,ps,        [.85 btmh+1*btd .15 bth], bck,[.81 .81 .81],  str, '-', 'callback','idbox=5; inc=-5; chgpos; redraw');

%           uicontrol(poshd,stl,txt,unt,nrm,ps,[.05 btmh+2*btd lbw bth], bck,[.81 .81 .81],  str, '¸©Ñö');
%   ptbox=  uicontrol(poshd,stl,edt,unt,nrm,ps,[.65 btmh+2*btd .3 bth],  bck,[.95 .95 .95],  str, num2str(pitch));

%           uicontrol(poshd,stl,txt,unt,nrm,ps,[.05 btmh+1*btd lbw bth], bck,[.81 .81 .81],  str, '¹ö¶¯');
%   rlbox=  uicontrol(poshd,stl,edt,unt,nrm,ps,[.65 btmh+1*btd .3 bth],  bck,[.95 .95 .95],  str, num2str(roll));

            uicontrol(poshd,unt,nrm,ps,        [.30 btmh+0*btd lbw*1.5 bth], bck,[.81 .81 .81],  str, '×ËÌ¬¸´Î»', 'callback','idbox=6; chgpos; redraw');


    aza=0;
    ela=90;

    btd=1/6;  bth=0.8/6; btmh=0.01; btw=0.8;
    vahd=uipanel(fhd,'title','ÊÓ½ÇÇÐ»»',ps,[0.92 0.02 0.07 0.24]);

         uicontrol(vahd,unt,nrm,ps,[.37 btmh+5*btd btw/3 bth],str,'¡ü',    'call','if ela<180, ela=ela+15; end;   view(lon+90+aza,lat+ela-90); ');
         uicontrol(vahd,unt,nrm,ps,[.03 btmh+4*btd btw/3 bth],str,'¡û',    'call','if aza>-90/cosd(lat), aza=aza-15; end;   view(lon+90+aza,lat+ela-90); ');
         uicontrol(vahd,unt,nrm,ps,[.70 btmh+4*btd btw/3 bth],str,'¡ú',    'call','if aza<90/cosd(lat),  aza=aza+15; end;   view(lon+90+aza,lat+ela-90); ');
         uicontrol(vahd,unt,nrm,ps,[.37 btmh+3*btd btw/3 bth],str,'¡ý',    'call','if ela>0,   ela=ela-15; end;   view(lon+90+aza,lat+ela-90); ');
  
    HideEarth=uicontrol(vahd,unt,nrm,ps,[.1  btmh+1*btd btw bth],str,'Òþ²ØµØÇò',    'call','set(shd,''visible'',''off''), set(maphd,''visible'',''off''), set(ShowEarth,''enable'',''on''), set(HideEarth,''enable'',''off''); ');
    ShowEarth=uicontrol(vahd,unt,nrm,ps,[.1  btmh+0*btd btw bth],str,'ÏÔÊ¾µØÇò',    'call','set(shd,''visible'', ''on''), set(maphd,''visible'', ''on''), set(HideEarth,''enable'',''on''), set(ShowEarth,''enable'',''off''); ', 'enable', 'off');

    vtx=vtx0;
    JetColor=[.75 .75 .75];

    phd=patch('Vertices',vtx0, 'Faces', faceM, 'FaceColor', JetColor,'Edgecolor',JetColor, ...
              'FaceLighting','Gouraud','Edgelighting','Gouraud','EdgeAlpha',0);

    lightpos1=15*[cosd(lat)*cosd(lon-60)     cosd(lat)*sind(lon-60)     sind( lat)];
    lightpos2=15*[cosd(lat)*cosd(lon-20-180) cosd(lat)*sind(lon-20-180) sind(-lat)];

    lhd1 =light('position',lightpos1);
    lhd2 =light('position',lightpos2);

    view(lon+90+aza,lat+ela-90)
