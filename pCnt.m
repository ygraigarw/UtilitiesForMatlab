function [C,Hnd]=pCnt(X,Y,Z,nGrd,nLvl,Is2D,DmnZ);
%function pCnt(X,Y,Z,nGrd,nLvl);
%
%Shell Projects & Technology, Statistics & Chemometrics
%Philip Jonathan
%June 2010
%
%Overview: General-purpose contour-plotting
%1 Finds max and min of each of X, Y and Z to define domain for grid and contour level specification
%2 Creates grid mesh points in X-Y, then interpolates Z (currently using nearest neighbour interpolation)
%3 Outputs MATLAB contour array and contour graphics object handle
%
%Input
% X    X-axis location per observation (n x 1)
% Y    Y-axis location per observation (n x 1)
% Z    Z-value of variable Z=Z(X,Y) to contour (n x 1)
% nGrd Number of GRiD points (for each of X and Y axis) over which to mesh the input data
% nLvl Number of (equally spaced) contour LeVeLs to display
% Is2D IS a 2D plot (0==yes, 1==no)
% DmnZ DoMaiN for Z (optional)
%
%Output
% C    Contour array generated
% Hnd  contour graphics object HaNDle

C=NaN;
Hnd=NaN;

switch nargin;
	case 0;
		X=reshape((1:10)'*ones(1,10),100,1);
		Y=reshape(ones(10,1)*(1:10),100,1);
		Z=(X-5).^2+(Y-5).^2;
		nGrd=10;
		nLvl=5;
		Is2D=1;
		DmnZ=[min(Z)-5;max(Z)+5];
	case 3;
		nGrd=10;
		nLvl=5;
		Is2D=1;
		DmnZ=[min(Z);max(Z)];
	case 4;
		nLvl=5;
		Is2D=1;
		DmnZ=[min(Z);max(Z)];
	case 5;
		Is2D=1;
		DmnZ=[min(Z);max(Z)];
	case 6;
		DmnZ=[min(Z);max(Z)];
end;

MnmX=min(X); MxmX=max(X); IncX=range(X)/(nGrd-1);
MnmY=min(Y); MxmY=max(Y); IncY=range(Y)/(nGrd-1);
MnmZ=DmnZ(1);MxmZ=DmnZ(2);

GrdX=(MnmX:IncX:MxmX)';
GrdY=(MnmY:IncY:MxmY)';

%Mesh X,Y and then estimate Z on mesh
[XI,YI]=meshgrid(GrdX,GrdY);
ZI=griddata(X,Y,Z,XI,YI);

if Is2D==1;%2D contouring (else surface)
	
	%Set contour levels
	CntLvl=quantile(Z(Z>=MnmZ),(1:nLvl)'/(nLvl+1));
	
	%Plot input data locations
	hold on; plot(X,Y,'Color',0.9*ones(3,1),'Marker','.','LineStyle','none');
	
	[C,Hnd]=contour(XI,YI,ZI,CntLvl,'LineColor',[0 0 0],'LineWidth',0.5);  grid on;
	
	if 1;%Keep contour levels at sensible locations
		LvlLst=get(Hnd,'LevelList');
		TxtLst=[];
		for iL=1:nLvl;
			TxtLst=strvcat(TxtLst,sprintf('%.2e',LvlLst(iL)));
		end;
		TxtLst=str2num(TxtLst);
		set(Hnd,'TextList',TxtLst,'LevelList',TxtLst);
		set(Hnd,'ShowText','on','TextStep',get(Hnd,'LevelStep')*3,'LabelSpacing',200,'TextList',TxtLst,'LevelList',TxtLst)
		clabel(C,Hnd,'FontSize',10,'FontName','Sylfaen','Color','k','LineWidth',1)
		set(Hnd,'TextList',TxtLst);
	else;
		set(Hnd,'ShowText','on','TextStep',get(Hnd,'LevelStep')*1,'LabelSpacing',200)
		clabel(C,Hnd,'FontSize',10,'FontName','Sylfaen','Color','k','LineWidth',1)
	end;
	%Standard figure formatting
	set(gca,'FontSize',15,'FontName','Sylfaen');
	set(gca,'GridLineStyle','-','LineWidth',0.5);
	box on; pAxsLmt;
	drawnow;
	
else; %surface
	
	Hnd=surf(XI,YI,ZI); shading interp;
	pClrBar(DmnZ,10);
	view(2); pDfl; pAxsLmt;
	
end;

return;