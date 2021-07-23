function pFill(x,y,z,Clr);
%function pFill(x,y,z,Clr);
%
%PhJ 27.01.06
%
%Fills the area between two curves with a transparent fill of specified
%colour

%x is x-data
%y is first y-data
%z is second y-data
if isnan(x(1))==1|isnan(y(1))==1|isnan(z(1))==1;%first point is NaN
	t1=[isnan(x)==0 & isnan(y)==0 & isnan(z)==0;0];
	t2=[diff(t1)];
	tStr=[find(t2==1)+1];
	tEnd=[find(t2==-1)];
else;
	t1=[0;isnan(x)==0 & isnan(y)==0 & isnan(z)==0;0];
	t2=[diff(t1)];
	tStr=[find(t2==1)];
	tEnd=[find(t2==-1)-1];
end;
Edg=[tStr tEnd];
nEdg=size(Edg,1);

hold on;box on; grid on;
for iE=1:nEdg;
	t1=[x(Edg(iE,1):Edg(iE,2));x(Edg(iE,2):-1:Edg(iE,1))];
	t2=[z(Edg(iE,1):Edg(iE,2));y(Edg(iE,2):-1:Edg(iE,1))];	
	h=fill(t1,t2,Clr);set(h,'FaceAlpha',0.5,'EdgeAlpha',0);
end;
if 0;
	pplt(x,y,Clr);
	pplt(x,z,Clr);
end;
