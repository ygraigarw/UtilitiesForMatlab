function y=pJet(i);

y=NaN;

if max(abs(rem(i,1)))>1e-10;
	fprintf(1,'Error: pRed: not integer\n');
	return;
end;

if min(i)<1;
	fprintf(1,'Error: pRed: min(i)<1\n');
	return;
end;

if max(i)>32;
	i=rem(i,32);if i==0; i=32; end;
	if 0;
		fprintf(1,'WARNING: pJet: max(i)>32. Setting to i mod 32\n');
	end;
end;

Jet=colormap('jet');
Jet=Jet(2:2:end,:);
y=Jet(i,:);

return;