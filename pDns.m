function [tL,tB]=pDns(X,Edg,Clr,LinWdt,LinStl,Scl);

% X      n x 1 data
% Edg    k x 1 edges
% Clr    3 x 1 colour number
% LinWdt 1 x 1 scalar MATLAB line width
% LinStl 1 x 1 character line style
% Scl    'Prp'=='sum to unity'; 'Dns'=pdf

if nargin==0;
  fprintf(1,'Test case\n');
  X=randn(100,1);
  Edg=(-5:5)';
  Clr=zeros(3,1);
  LinWdt=1;
  LinStl='-';
  Scl='Prp';
elseif nargin==1;
  Edg=linspace(min(X),max(X),10);
  Clr=zeros(3,1);
  LinWdt=1;
  LinStl='-';
  Scl='Prp';
elseif nargin==2;
  Clr=zeros(3,1);
  LinWdt=1;
  LinStl='-';
  Scl='Prp';
elseif nargin==3;
  LinWdt=1;
  LinStl='-';
  Scl='Prp';
elseif nargin==4;
  LinStl='-';
  Scl='Prp';
elseif nargin==5;
  Scl='Prp';
end;

if isempty(X)==0;
    
    tHst=histogram(X,Edg,'Visible','off');
    tB=tHst.Values';
    
    switch Scl;
        case 'Dns';
            tB=tB/(sum(tB)*range(Edg));
        case 'Prp';
            tB=tB/sum(tB);
    end;
    
    hold on;
    tRng=(Edg(1:end-1)+Edg(2:end))/2;
    h=bar(tRng,tB,'hist');
    set(h,'FaceAlpha',0,'LineWidth',LinWdt,'EdgeColor',Clr,'LineStyle',LinStl);
    
end;

return