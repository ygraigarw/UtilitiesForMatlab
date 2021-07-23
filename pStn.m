function [y,a,s]=pStn(X);
%function y=pStn(X);
%
%Standardise data to zero mean and unit standard deviation, ignoring nan
n=size(X,1);
a=nanmean(X)';
s=nanstd(X)';
if s>eps;
   y=(X-ones(n,1)*a')./(ones(n,1)*s');
else;
   y=(X-ones(n,1)*a');
   fprintf(1,'pStn: Warning: Variable with variance zero just mean-centred\n');
end;

return;