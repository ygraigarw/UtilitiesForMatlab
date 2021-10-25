function [tL,tB]=pDns(X,nB,Clr,LinWdt);

% X      n x 1 data
% nB     1 x 1 number of bins
% Clr    1 x 1 single character MATLAB colour
% LinWdt 1 x 1 MATLAB line width

if nargin==0;
  fprintf(1,'Test case\n');
  X=randn(100,1);
  nB=10;
  Clr='k';
  LinWdt=1;
elseif nargin==1;
  nB=100;
  Clr='k';
  LinWdt=1;
elseif nargin==2;
  Clr='k';
  LinWdt=1;
elseif nargin==3;
  LinWdt=1;
end;

if isempty(X)==0;
    
    %generate basic histogram
    if range(X)<eps;
      fprintf(1,'Warning: pltHst: range of X near zero\n');
      a=mean(X);
      if abs(X)>eps;
        tRng=linspace(0.9*a,1.1*a,nB);
      else;
        tRng=linspace(a-1,a+1,nB);
      end;
    else;
        tRng=linspace(min(X),max(X),nB);
    end;
    [tB,tL]=hist(X,tRng);
    
    tB=tB/(sum(tB)*(range(tRng)/nB));
    
    hold on;
    h=bar(tL,tB,'hist');
    set(h,'FaceAlpha',0,'LineWidth',LinWdt,'EdgeColor',Clr);
    
end;

return