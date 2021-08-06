function pClrBarScl(Wdt);
%function pClrBarScl;
%
%Scale a subplot so that the colorbar does not dominate it

if nargin==0;
    Wdt=0.5;
end;

OS2=get(gca, 'Position');
h=colorbar;
set(gca,'Position',OS2);
pCB=get(h,'Position');set(h,'Position',[OS2(1)+OS2(3) pCB(2) pCB(3)*Wdt pCB(4)]);

return;