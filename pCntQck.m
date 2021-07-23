function pCntQck(X,Y,D,Lmt);

%X    X-domain nX x nY (vector or matrix)
%Y    Y-domain nX x nY (vector or matrix)
%D    Data     nX x nY 
%Lmt  Limit     1 x 1  (symmetric)    

%% Plot pcolor with or without specified axes
if isempty(X)==0;
    h=pcolor(X,Y,D);
else;
    h=pcolor(D');
end;
   
%% Turn off cell edge lines, and smooth the plot
set(h,'linestyle','none'); 
shading interp;

%% Use custom limits if specified
if nargin==4;
    set(gca, 'clim', [-Lmt,Lmt]);
else;
end;    

%% Bring grid and box to front
set(gca,'layer','top')
grid on; box on;

%% Colorbar
pClrBarScl;

return;