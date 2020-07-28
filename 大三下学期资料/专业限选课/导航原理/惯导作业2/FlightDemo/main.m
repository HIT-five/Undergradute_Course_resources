clear

if exist('FlightData.mat')~=2, disp('Please first prepare the data file FlightData.mat according to the intruction.'); return; 
else
   
    load FlightData;   % Your results, containing HtM (heights, m), HPRatt (attitudes, deg), LonM (longitudes, deg) and LatM (latitudes, deg)
    load ModelData;    % containing map data: Xm Ym Zm, and jet model data: vtx0, vtxcolor and faceM 
    vtx0=2*vtx0;
   
    fhd=figure('position',[104 8 1905 1030], 'color',[0 0 0],'name','飞行器虚拟仿真平台','Menubar','none','NumberTitle','off');
    re=6371000;

    viewfull=2.6;  
    viewangle=viewfull;      % for sizer=0.00002
    sizerground=200;         % for ground size
    sizer=sizerground;
    sizerscale=1;            % for manual sizing
    st=1;                    % for ground view
    i=1;                     % sequal number for playback
    chgmodel=0;              % 0 for model not to be changed in redraw 
    
    rball=0.9999*re;
    ballcolor=[0.3 .7 1];
   [xs, ys, zs]=sphere(120);
    shd=surf(rball*xs,rball*ys,rball*zs, 'facecolor',ballcolor,'edgecolor',ballcolor, ...
            'FaceLighting','Gouraud','Edgelighting','Gouraud','Backfacelighting','unlit','EdgeAlpha',0); 
    alim=2*re;
    set(gca,'position',[0.1 0.05 0.8 0.9],'xlim',[-alim alim], 'ylim', [-alim  alim], 'zlim', [-alim alim]);
    set(gca, 'DataAspectRatio',[1 1 1], 'DataAspectRatioMode','Manual', 'CameraViewAngle',viewangle, 'CameraViewAngleMode','Manual');
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
    
    plot3(Xm*re,Ym*re,Zm*re,'k');   % drawing coast-line map
 
%   ===== next for GUI =================
    stl='style'; edt='edit'; txt='text'; btn='button'; pix='pixels'; nrm='normal'; bck='back';
    ps='position'; unt='unit'; str='string';
    cal='callback';col='color';

    playrate=[1 2 3 5 8 12 16 24 36 48 72 100 150 200 300]; 
    playi=4;
    upintv=1;
    btd=.95/2;  bth=0.8/2; btmh=0.01; btw=0.8; lbw=0.35;
    uphd=uipanel(fhd,'title','更新速度',ps,[0.01 0.89 0.1 0.1]);
           uicontrol(uphd,stl,txt,unt,nrm,ps,[.05 1-1*btd lbw bth], bck,[.81 .81 .81],  str, '播放倍速');
    upbox =uicontrol(uphd,stl,edt,unt,nrm,ps,[.45 1-1*btd .2  bth], bck,[.95 .95 .95],  str, num2str(upintv));
           uicontrol(uphd,        unt,nrm,ps,[.68 1-1*btd .15 bth], bck,[.81 .81 .81],  str, '↑', cal,'  if upintv<300, upintv=round(upintv*1.6);  set(upbox,''string'', num2str(upintv)); end ');
           uicontrol(uphd,        unt,nrm,ps,[.84 1-1*btd .15 bth], bck,[.81 .81 .81],  str, '↓', cal,'  if upintv>1,   upintv=round(upintv/1.6);  set(upbox,''string'', num2str(upintv)); end ');
           uicontrol(uphd,stl,txt,unt,nrm,ps,[.05 1-2*btd lbw bth], bck,[.81 .81 .81],  str, '回放帧率');
    fpsbox=uicontrol(uphd,stl,edt,unt,nrm,ps,[.45 1-2*btd .5 bth],  bck,[.81 .81 .81],  str, num2str(0));

    btd=1/5;  bth=0.8/5; btmh=0.01; btw=0.8;
    pnlh=uipanel(fhd,'title','演示控制',ps,[0.92 0.72 0.07 0.26]);

         uicontrol(pnlh,unt,nrm,ps,[.1 1-1*btd btw bth],str,'出发地点',cal,'zoomin');
     lch=uicontrol(pnlh,unt,nrm,ps,[.1 1-2*btd btw bth],str,'起飞',    cal,'K1=length(HtM); i0=1; redraw');
     
         uicontrol(pnlh,unt,nrm,ps,[.1 1-4*btd btw bth],str,'返回起点',cal,'K1=1; i0=1; sizerscale=1; st=1; redraw;');
     
         uicontrol(pnlh,unt,nrm,ps,[.1 1-5*btd btw bth],str,'暂停/继续',cal,'if pausemode==0, pausemode=1; else, pausemode=0; end;');

    btd=1/6;  bth=0.8/6; btmh=0.01; btw=0.8;
    vahd=uipanel(fhd,'title','视角切换',ps,[0.92 0.42 0.07 0.24]);

         aza=0;
         ela=90;
     
         uicontrol(vahd,unt,nrm,ps,[.37 btmh+5*btd btw/3 bth],str,'↑',    cal,'if ela<180, ela=ela+10; end;             view(lon+90+aza,lat+ela-90); set(gca,''Cameratarget'',targetpos);');
         uicontrol(vahd,unt,nrm,ps,[.70 btmh+5*btd btw/3 bth],str,'北',    cal,'ela=183-lat;                             view(lon+90+aza,lat+ela-90); set(gca,''Cameratarget'',targetpos);');
         uicontrol(vahd,unt,nrm,ps,[.03 btmh+4*btd btw/3 bth],str,'←',    cal,'if aza>-90/cosd(lat), aza=aza-10; end;   view(lon+90+aza,lat+ela-90); set(gca,''Cameratarget'',targetpos);');
         uicontrol(vahd,unt,nrm,ps,[.33 btmh+4*btd btw*.44 bth],str,'俯视',cal,'aza=0; ela=90;                           view(lon+90+aza,lat+ela-90); set(gca,''Cameratarget'',targetpos);');
         uicontrol(vahd,unt,nrm,ps,[.70 btmh+4*btd btw/3 bth],str,'→',    cal,'if aza<90/cosd(lat),  aza=aza+10; end;   view(lon+90+aza,lat+ela-90); set(gca,''Cameratarget'',targetpos);');
         uicontrol(vahd,unt,nrm,ps,[.37 btmh+3*btd btw/3 bth],str,'↓',    cal,'if ela>0,   ela=ela-10; end;             view(lon+90+aza,lat+ela-90); set(gca,''Cameratarget'',targetpos);');
     
         uicontrol(vahd,unt,nrm,ps,[.01 btmh+1.5*btd 0.60   bth],str,'靠近地球',  cal,'st=st/1.3; set(gca,''Cameraviewangle'',st*viewangle);');
         uicontrol(vahd,unt,nrm,ps,[.65 btmh+1.5*btd 0.33   bth],str,'远离',      cal,'st=st*1.3; set(gca,''Cameraviewangle'',st*viewangle);');
     
         uicontrol(vahd,unt,nrm,ps,[.01 btmh+0*btd 0.60   bth],str,'靠近机体',    cal,'sizerscale=sizerscale*1.5;  if K1==1, s0=1; draw1st=0; redraw; end');
         uicontrol(vahd,unt,nrm,ps,[.65 btmh+0*btd 0.33   bth],str,'远离',        cal,'sizerscale=sizerscale/1.5;  if K1==1, s0=1; draw1st=0;  redraw; end');

    HPRM=TrimAtt(HtM,HPRatt);

     btd=1/7;  bth=0.8/7; btmh=0.05; btw=0.8; lbl=0.02; lbw=0.3; dtl=0.35; dtw=0.63; 
    shwg=uipanel(fhd,'title','导航信息',ps,[0.01 0.01 0.10 0.27]);

           uicontrol(shwg,stl,txt,unt,nrm,ps,[lbl .02+6*btd lbw bth],  bck,[.9 .9 .9],  str, '航向');
    showhd=uicontrol(shwg,stl,edt,unt,nrm,ps,[dtl .02+6*btd dtw bth],  bck,[.9 .9 .9],  str, num2str(HPRM(1, 1)));
           uicontrol(shwg,stl,txt,unt,nrm,ps,[lbl .02+5*btd lbw bth],  bck,[.9 .9 .9],  str, '俯仰');
    showpt=uicontrol(shwg,stl,edt,unt,nrm,ps,[dtl .02+5*btd dtw bth],  bck,[.9 .9 .9],  str, num2str(HPRM(1, 2)));
           uicontrol(shwg,stl,txt,unt,nrm,ps,[lbl .02+4*btd lbw bth],  bck,[.9 .9 .9],  str, '滚动');
    showrl=uicontrol(shwg,stl,edt,unt,nrm,ps,[dtl .02+4*btd dtw bth],  bck,[.9 .9 .9],  str, num2str(HPRM(1, 3)));

           uicontrol(shwg,stl,txt,unt,nrm,ps,[lbl .02+3*btd lbw bth],  bck,[.4 .9 .4],  str, '进度');
    showtm=uicontrol(shwg,stl,edt,unt,nrm,ps,[dtl .02+3*btd dtw bth],  bck,[.4 .9 .4],  str, num2str(0));

           uicontrol(shwg,stl,txt,unt,nrm,ps,[lbl .02+2*btd lbw bth],  bck,[.9 .9 .9],  str, '经度');
    showln=uicontrol(shwg,stl,edt,unt,nrm,ps,[dtl .02+2*btd dtw bth],  bck,[.9 .9 .9],  str, num2str(LonM(1)));
           uicontrol(shwg,stl,txt,unt,nrm,ps,[lbl .02+1*btd lbw bth],  bck,[.9 .9 .9],  str, '纬度');
    showlt=uicontrol(shwg,stl,edt,unt,nrm,ps,[dtl .02+1*btd dtw bth],  bck,[.9 .9 .9],  str, num2str(LatM(1)));
           uicontrol(shwg,stl,txt,unt,nrm,ps,[lbl .02+0*btd lbw bth],  bck,[.9 .9 .9],  str, '高度');
    showht=uicontrol(shwg,stl,edt,unt,nrm,ps,[dtl .02+0*btd dtw bth],  bck,[.9 .9 .9],  str, num2str(HtM(1)));

    Ht0=HtM(1);

    qsky  =[cosd(45)   -sind(45)*[  0  0  1]]; % pi/2 around axis sky
    qeast =[cosd(45)   -sind(45)*[  1  0  0]]; % pi/2 around axis east

   i0=1;
   K1=1;
   pausemode=0;
   draw1st=1;    
   redraw;
   draw1st=0;

   stfull=viewfull/viewangle;
   st=stfull;
   
   set(gca,'Cameraviewangle',st*viewangle)    % for full view of the Earth
    

end