function y=pBW(i);

y=NaN;

if max(abs(rem(i,1)))>1e-10;
	fprintf(1,'Error: pBW: not integer\n');
	return;
end;

if min(i)<1;
	fprintf(1,'Error: pBW: min(i)<1\n');
	return;
end;

if max(i)>6;
	i=rem(i,6);if i==0; i=6; end;
	if 0;
		fprintf(1,'WARNING: pBW: max(i)>6. Setting to i mod 6\n');
	end;
end;

BW=ones(5,3).*NaN;
BW(1,:)=[1 1 1]*0; %black
BW(2,:)=[1 1 1]*0.4;
BW(3,:)=[1 1 1]*0.6;
BW(4,:)=[1 1 1]*0.7;
BW(5,:)=[1 1 1]*0.8;
BW(6,:)=[1 1 1]*0.9;

y=BW(i,:);

return;