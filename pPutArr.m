function pPutArr(LctX,LctY,Mgn,AngMth,Scl,Clr);
%function pPutArr(LctX,LctY,Mgn,AngMth,Scl);
%
% Puts a arrow with specified location, length and direction on some scale
% LctX: x-location of arrow
% LctY: y-location of arrow
% Lng:  length of arrow
% AngMth: direction of arrow (given in mathematical degrees anticlockwise from positive x-axis)
% Scl: Overall scale of arrow (so that you can put lots of small arrows, or a few big ones)
% Clr: Colour (e.g. 'k' or 'w')

if nargin==5;
   Clr='k';
end;

Mgn1=0.15*Scl*Mgn/12;
Mgn2=Mgn1*0.8;
Dlt=10;

x=[LctX;LctX+Mgn1*cosd(AngMth)];
y=[LctY;LctY+Mgn1*sind(AngMth)];

x1=[x(2);x(1)+Mgn2*cosd(AngMth-Dlt)];
y1=[y(2);y(1)+Mgn2*sind(AngMth-Dlt)];
x2=[x(2);x(1)+Mgn2*cosd(AngMth+Dlt)];
y2=[y(2);y(1)+Mgn2*sind(AngMth+Dlt)];

h=line(x,y);set(h,'LineWidth',2,'Color',Clr);
h=line(x1,y1);set(h,'LineWidth',2,'Color',Clr);
h=line(x2,y2);set(h,'LineWidth',2,'Color',Clr);

return;