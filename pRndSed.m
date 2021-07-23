function y=pRndSed(Inp);

if nargin==0;
    y=sum(100*clock);
else;
    y=Inp;
end;

rng(y,'twister');

return;
