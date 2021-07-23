function Y=pLplRnd(n,Nep);
%n=sample size
%Nep = non-exceedance prob for sampling from tail
if nargin==1;
    Nep=0;
end;
U=rand(n,1)*(1-Nep)+Nep;
Y=-sign(U-0.5).*log(1 - 2.*abs(U-0.5));
return;