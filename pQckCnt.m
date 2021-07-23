function pQckCnt(x,y,z,xTxt,yTxt,tTxt);

ux=unique(x); nux=size(ux,1);
uy=unique(y); nuy=size(uy,1);

dlt=sqrt(mean(diff(ux))*mean(diff(uy)));
ax=ones(nux,nuy).*NaN;
ay=ones(nux,nuy).*NaN;
az=ones(nux,nuy).*NaN;
for ix=1:nux;
	for iy=1:nuy;
		%t=((x-ux(ix)).^2+(y-uy(iy)).^2)<1e-10;
		t=((x-ux(ix)).^2+(y-uy(iy)).^2)<dlt;
		if sum(t)>0;
			ax(ix,iy)=nanmean(x(t));
			ay(ix,iy)=nanmean(y(t));
			az(ix,iy)=nanmean(z(t));
		end;
	end;
end;

Sgn=1-floor(log10(range(z)));
v=round(quantile(z,[0.05 0.1:0.10:0.9 0.95])*10^Sgn)/10^Sgn;
[c,hc]=contour(ax,ay,az,v);
clabel(c,hc)

pDfl;pAxsLmt;

if nargin==6;
	xlabel(xTxt);
	ylabel(yTxt);
	title(tTxt);
end;

return;
