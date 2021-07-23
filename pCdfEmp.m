function pCdfEmp(X,Nam,nPnt);

[n,p]=size(X);

if nargin==2;
    Rsl=1;
else;
    Rsl=ceil(n*p/nPnt);
end;

tx=sort(reshape(X,n*p,1));
ty=((1:1:n*p)'-0.5)/(n*p);

clf;
plot(tx(1:Rsl:end),ty(1:Rsl:end),'k.-','MarkerSize',10,'LineWidth',2);pdefb;
xlabel(Nam);ylabel 'Epmirical Cumulant'; tStr=sprintf('Empirical Cumulant For %s',Nam); title(tStr);
tStr=sprintf('Cumulant_%s',Nam);pGI(tStr);

return;