function pQckSrf(x,y,z,xTxt,yTxt,zTxt);

if 1;
	ux=(min(x):range(x)/9:max(x))';
	uy=(min(y):range(y)/9:max(y))';
else;
	ux=unique(x);
	uy=unique(y);
end;
nux=size(ux,1);
nuy=size(uy,1);

dlt2=mean(diff(unique(ux)))*mean(diff(unique(uy)));
%dlt2=max(range(x)/99,range(y)/99)^2;

ax=ones(nux,nuy).*NaN;
ay=ones(nux,nuy).*NaN;
az=ones(nux,nuy).*NaN;
for ix=1:nux;
	for iy=1:nuy;
		t=((x-ux(ix)).^2+(y-uy(iy)).^2)<dlt2;
		if sum(t)>0;
			ax(ix,iy)=nanmean(x(t));
			ay(ix,iy)=nanmean(y(t));
			az(ix,iy)=nanmean(z(t));
		end;
	end;
end;

surf(ax,ay,az,'EdgeColor','none');

pDfl;pAxsLmt;

if nargin==6;
	xlabel(xTxt);
	ylabel(yTxt);
	zlabel(zTxt);
end;

return;
