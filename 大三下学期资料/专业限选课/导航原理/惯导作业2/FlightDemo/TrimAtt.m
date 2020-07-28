% Trim HPRAtt to HPRM so that it has the same rows as HtM 
function [HPRM]=TrimAtt(HtM, HPRatt) 
    hrow=length(HtM);
   [arow,acol]=size(HPRatt);
    if acol>arow, HPRatt=HPRatt'; end;   [arow,acol]=size(HPRatt);

    ks=round(arow/hrow);       % ks attitude rows for each height row
    HPRM=HPRatt((0:(hrow-1))*ks+1,:);
        
