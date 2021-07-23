function y=pRed(i);

y=NaN;

if max(abs(rem(i,1)))>1e-10;
	fprintf(1,'Error: pRed: not integer\n');
	return;
end;

if min(i)<1;
	fprintf(1,'Error: pRed: min(i)<1\n');
	return;
end;

if max(i)>6;
	i=rem(i,6);if i==0; i=6; end;
	if 0;
		fprintf(1,'WARNING: pRed: max(i)>6. Setting to i mod 6\n');
	end;
end;

Red=ones(10,3).*NaN;
for iR=1:10;
	Red(iR,:)=[1 0 0]*((11-iR)/10)^2;
end;

y=Red(i,:);

return;