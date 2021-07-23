function k=pWavNmb(T,Dpt)

% w^2 = g*k*tanh(k*d)
% Scalar inputs

g=9.81;
n=size(T,1);

k=ones(n,1).*NaN;
if n>1 & size(Dpt,1)==1;
	Dpt=ones(n,1)*Dpt;
end;
for i=1:n;
	w=2*pi/T(i);
	PrmStr=(w^2)/g;
	Fnc = @(x) (w^2 - g * x * tanh(x * Dpt(i)))^2;
	k(i)=fminsearch(Fnc,PrmStr);
end;

return;
