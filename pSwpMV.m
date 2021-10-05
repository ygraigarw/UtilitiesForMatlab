function Y=SwapMV(X,MVCod);
%function Y=SwapMV(X);
%
% PJ:12.10.98
% 
% This m-file converts all occurrence of -99 to NaN, or vice versa.
% Will terminate if it finds both -99 and NaN in matrix.
%
% Input  : X (n x p)
% Output : Y (n x p)

if nargin==1;
    MVCod=-99;
end;

t1=sum(sum(X==MVCod)');
t2=sum(sum(isnan(X))');

if t1>0 & t2>0;
  fprintf(1,'Error : Matrix contains %g and NaN. Terminating\n',MVCod);
  return;
end;

if t1>0 & t2==0;
  fprintf(1,'Converting %d occurrences of %g to NaN\n',t1,MVCod);  
  tmp=X==MVCod;
  Y=X;
  Y(tmp==1)=NaN;
end;

if t1==0 & t2>0;
  fprintf(1,'Converting %d occurrences of NaN to %g\n',t2,MVCod);  
  tmp=isnan(X);
  Y=X;
  Y(tmp==1)=MVCod;
end;

if t1==0 & t2==0;
  %fprintf(1,'Neither -99 nor NaN to convert\n');
  Y=X;
end;
