function pClrBarScl;
%function pClrBarScl;
%
%Scale a subplot so that the colorbar does not dominate it

OS2=get(gca, 'Position');
h=colorbar;
set(gca,'Position',OS2);
pCB=get(h,'Position');set(h,'Position',[OS2(1)+OS2(3) pCB(2) pCB(3)/3 pCB(4)]);

return;