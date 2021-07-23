function [corr,npair,isok]=pCorr(xo,SpearOrPears);
%function [corr,npair,isok]=pCorr(xo,SpearOrPears);
%
%PJ 28.09.99
%
%HISTORY
%28.09.99 - Updated from pspear.m to calculate either Spearman or Pearson correlations
%
%Calculates Spearman (rank) or Pearson (conventional) correlations for matrix xo
%- eliminates observations (rows) with missing values
%- assumes a minimum of 5 pairs necessary to calculate rank correlation
%
%Inputs
% xo : n x p matrix of data (n observations on p variables)
% SpearOrPears : Spearman (=1) or Pearson (=0)
%
%Outputs
% corr : Spearman or Pearson correlation matrix
% npair : number of good pairs on which each rank correlation is based
% isok  : indicator vector for good observations (good=1, bad=0)
%
%Also outputs text to screen on progress of calculations
%
%Uses
%Generic MATLAB utilities only

[n,p]=size(xo);

if SpearOrPears==0 | SpearOrPears==1;
else;
   fprintf(1,'Incorrect specification of SpearOrPears. Terminating\n');
   return;
end;

fprintf(1,'Locating good data\n');
isok=zeros(n,p);
for j=1:p;
   isok(:,j)=xo(:,j)~=-99;
end;

if SpearOrPears==1;
   fprintf(1,'Calculating Spearman rank correlation matrix\n');
else;
   fprintf(1,'Calculating Pearson correlation matrix\n');
end;
   
corr=ones(p,p).*-99;
npair=zeros(p,p);
for j=1:p;
   if rem(j,10)==0;
      fprintf(1,'On variable :');
      fprintf(1,'%d ',j);
   end;
   for k=j:p;
      npair(j,k)=sum(isok(:,j)==1&isok(:,k)==1);
      npair(k,j)=npair(j,k);
      if npair(j,k)>5 & std(xo(isok(:,j)==1&isok(:,k)==1,j))>0 & std(xo(isok(:,j)==1&isok(:,k)==1,k))>0 ;
         if SpearOrPears==1;      
            [junk,tmp]=sort(xo(isok(:,j)==1&isok(:,k)==1,[j k]));
            [junk,xr]=sort(tmp);
            tmp=corrcoef(xr);
         else;
            tmp=corrcoef(xo(isok(:,j)==1&isok(:,k)==1,[j k]));
         end;
         corr(j,k)=tmp(1,2);
         corr(k,j)=tmp(1,2);
      end;   
   end;
end;