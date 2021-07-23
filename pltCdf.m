function pltCdf(X,Clr,Wgh);

if nargin==0;
    fprintf(1,'Test case\n');
    X=randn(1000,1);
    Clr='k';
    Wgh=[];
elseif nargin==1;
    Clr='k';
    Wgh=[];
elseif nargin==2;
    Wgh=[];
end;

if isempty(Wgh)==0;
    Wgh=round(1000*Wgh/sum(Wgh)); %effective number of points on cdf set to 1000
end;

if isempty(X)==0;
    
    if isempty(Wgh)==0;
        tX=NaN(sum(Wgh),1);
        for i=1:size(X,1);
            if i==1;
                tX(1:Wgh(1))=X(1);
            else
                tX(sum(Wgh(1:i-1))+1:sum(Wgh(1:i-1))+Wgh(i))=X(i);
            end;
        end;
    else
        tX=X;
    end;
    
    n=numel(tX);
    
    t=isnan(tX);
    if sum(t)>0;
        fprintf(1,'pltCdf found NaNs, and is omitting.\n');
    end;
    
    t2X=[NaN(sum(t==1),1);sort(tX(t==0))];
    tY=((1:n)'-0.5)/n;
    
    %plot
    if length(Clr)>1;
        hold on; plot(t2X,tY,'Color',Clr(1),'LineStyle',Clr(2:end));
    else;
        hold on; plot(t2X,tY,'Color',Clr);
    end;
end;

return