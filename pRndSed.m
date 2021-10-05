function y=pRndSed(Inp);
% function y=pRndSed(Inp);
%
% With no input arguments, uses the current "clock" time to set the random seed
% which means that every time pRndSed is called, we get "independent" randomness
%
% With Inp specified, will give THE SAME random seed
% so that you can repeat a calculation (involving random numbers) exactly

if nargin==0;
    y=sum(100*clock);
else;
    y=Inp;
end;

rng(y,'twister');

return;
