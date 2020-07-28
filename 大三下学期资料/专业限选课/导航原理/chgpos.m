    lon  =str2num(get(lonbox, 'string'));   % Longitude (degree)
    lat  =str2num(get(latbox, 'string'));   % Latitude (degree)
    head =str2num(get(hdbox,  'string'));   % Heading (degree)
    pitch=str2num(get(ptbox,  'string'));   % Pitching (degree)
    roll =str2num(get(rlbox,  'string'));   % Rolling (degree)

    if      idbox==1, lon  =lon  +inc;  set(lonbox, 'string', num2str(lon) );   
    elseif  idbox==2, lat  =lat  +inc;  set(latbox, 'string', num2str(lat) );   
    elseif  idbox==3, head =head +inc;  set(hdbox,  'string', num2str(head) );   
    elseif  idbox==4, pitch=pitch+inc;  set(ptbox,  'string', num2str(pitch) );   
    elseif  idbox==5, roll =roll +inc;  set(rlbox,  'string', num2str(roll) );   
    elseif  idbox==6, head=0; pitch=0; roll=0; 
            set(hdbox,  'string', '0' );   
            set(ptbox,  'string', '0' );   
            set(rlbox,  'string', '0' );   
    end


