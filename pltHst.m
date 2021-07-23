function pltHst(X,Clr,nB);

if nargin==0;
  fprintf(1,'Test case\n');
  X=randn(100,1);
  Clr='k';
  nB=100;
elseif nargin==1;
  Clr='k';
  nB=100;
elseif nargin==2;
  nB=100;
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
    
    %use stairs function, tidy up ends
    [tX,tY]=stairs(tL,tB); tX=[tX(1);tX;ones(2,1)*(tX(end)+tX(end-1)-tX(end-2))]; tY=[0;tY;tY(end);0];
    
    %plot
    hold on; plot(tX,tY,'Color',Clr);
    
end;

return