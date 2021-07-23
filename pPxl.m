function pPxl(X,XLbl,YLbl,Ttl,IsBW,Dmn);
%function pPxl(X,XLbl,YLbl,Ttl,IsBW,Dmn);
%
%Shell Projects & Technology, Statistics & Chemometrics
%Philip Jonathan
%June 2010
%
%Overview: General-purpose "pixel" checker-board pseudo-colour plotting for rectangular array X
%1 Works with 0 (test), 1 (basic plot) or 5 (full spec) arguments
%2 No interpolation performed. Simply plots colour level corresponding to the values in X
%
%NOTE: Top left hand corner corresponds to X(1,1), top right hand corner to X(1,p). That is, we are in "axis ij" or "MATRIX" mode
%      Geographically, X(1,1) is the North-East corner of the domain, and X(1,p) is North-West. That is, plots produced with North vertically upwards and West to the left.
%
%Input
% X    Rectangular array (n x p) to visualise
% XLbl X LaBeL (n x 1); one value for each level of X
% YLbl Y LaBeL (p x 1); one value for each level of Y
% Ttl  Title (text string)
% IsBW IS Black and White (=0 == plot in colour, =1 == plot in greyscale)
% Dmn  DoMaiN for values to plot (defines limits of colours / greyscale if present)
%
%Output
% No data output

if nargin==0;
  n=100;	p=100;	X=(1:n)'*(1:p)+5;	XLbl=(1:n)';	YLbl=(1:p)';	Ttl='TestPixelPlot'; IsBW=0; Dmn=[-2000;12000];
elseif nargin==1;
  [n,p]=size(X); XLbl=(1:n)';	YLbl=(1:p)';	Ttl=''; IsBW=0; Dmn=NaN;
elseif nargin==3;
  Ttl=''; IsBW=0; Dmn=NaN;
elseif nargin==5
  Dmn=NaN;
elseif nargin<6;
  return;
end;

[n,p]=size(X);
if isnan(Dmn)==1;
  MnmX=min(min(X));
  MxmX=max(max(X));
else;
  MnmX=Dmn(1);
  MxmX=Dmn(2);
end;

imagesc(X');

if 1;
  
  nTck=20;
  LblSpcX=max(floor(n/nTck),1);
  LblSpcY=max(floor(p/nTck),1);
  
  t=(LblSpcX:LblSpcX:n)'; XLbl=[t XLbl(t)];
  t=(LblSpcY:LblSpcY:p)'; YLbl=[t YLbl(t)];
  set(gca,'XTick',XLbl(:,1),'XTickLabel',XLbl(:,2));
  set(gca,'YTick',YLbl(:,1),'YTickLabel',YLbl(:,2));

else;
  
  set(gca,'XTick',(1:length(XLbl)),'XTickLabel',XLbl);
  set(gca,'YTick',(1:length(YLbl)),'YTickLabel',YLbl);

end;
if IsBW==1;
  colormap(gray);
else;
  colormap('default');
end;

pClrBar([MnmX MxmX],10);

set(gca,'FontSize',10,'FontName','Garamond');grid off;
set(gca,'TickDir','out');
title(Ttl);

set(gcf,'Renderer','painters'); %required for printing using pGI

return;