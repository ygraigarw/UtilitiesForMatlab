function Y=SwapMV(X);
%function Y=SwapMV(X);
%
% PJ:12.10.98
% 
% This m-file converts all occurrence of -99 to NaN, or vice versa.
% Will terminate if it finds both -99 and NaN in matrix.
%
% Input  : X (n x p)
% Output : Y (n x p)

t1=sum(sum(X==-99)');
t2=sum(sum(isnan(X))');

if t1>0 & t2>0;
  fprintf(1,'Error : Matrix contains -99 and NaN. Terminating\n');
  return;
end;

if t1>0 & t2==0;
  fprintf(1,'Converting %d occurrences of -99 to NaN\n',t1);  
  tmp=X==-99;
  Y=X;
  Y(tmp==1)=NaN;
end;

if t1==0 & t2>0;
  fprintf(1,'Converting %d occurrences of NaN to -99\n',t2);  
  tmp=isnan(X);
  Y=X;
  Y(tmp==1)=-99;
end;

if t1==0 & t2==0;
  %fprintf(1,'Neither -99 nor NaN to convert\n');
  Y=X;
end;
