function pTal(X,Clr);

if nargin==0;
  fprintf(1,'Test case\n');
  X=randn(1000,1);
  Clr='k';
elseif nargin==1;
  Clr='k';
end;

if isempty(X)==0;
    
    n=numel(X);

    t=isnan(X);
    if sum(t)>0;
        fprintf(1,'pltCdf found %g NaN, and is ommitting.\n',sum(t));
    end;
    
    tX=[NaN(sum(t==1),1);sort(X(t==0))];
    tY=((1:n)'-0.5)/n;
    
    %plot
    hold on; plot(tX,log10(1-tY),'Color',Clr);
end;

return