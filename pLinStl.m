function y=pLinStl(i);
%function y=pLinStl(i);
%
%Philip Jonathan, Statistics & Chemometrics, Thornton. 
%"p*"-utilities 20091110
%
%Line styles for plotting
%
%History
%20100912 - Refined header

y=NaN;

if max(abs(rem(i,1)))>1e-10;
	fprintf(1,'Error: pLinSty: not integer\n');
	return;
end;

if min(i)<1;
	fprintf(1,'Error: pLinSty: min(i)<1\n');
	return;
end;

if max(i)>4;
	i=rem(i,4);if i==0; i=4; end;
	if 0;
		fprintf(1,'WARNING: pLinSty: max(i)>4. Setting to i mod 4\n');
	end;
end;

LinSty=cell(4,1);
LinSty{1}='-'; %solid
LinSty{2}='--';%dashed
LinSty{3}=':';%dotted
LinSty{4}='-.';%dash-dot

y=LinSty{i};