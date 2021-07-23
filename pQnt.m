function [Qnt,CndQnt,Prb]=pQnt(X,NEP,MVCod);

%initialise output
Qnt=NaN;
CndQnt=NaN;
Prb=NaN;

%handle different numbers of input arguments
if nargin==0;
  X=rand(100,1);
  X(1:20)=NaN;
  NEP=0.5; %assume median needed;
  MVCod=NaN; %assume NaN for MV
  fprintf(1,'pQnt: Test case: True Qnt=0.40, CndQnt=0.50, Prb=0.80\n');
elseif nargin==1;
  NEP=0.5; %assume median needed;
  MVCod=NaN; %assume NaN for MV
elseif nargin==2;
  MVCod=NaN;
end;

%check input consistent with expectation
[nX,n2,n3,n4,n5]=size(X);
if n5>1;
  fprintf(1,'pMdn: Error: Does not work with 5-D arrays\n');
  return;
end
if ~isvector(NEP);
  fprintf(1,'pMdn: Error: NEP must be a vector\n');
  return;
else;
  nNEP=length(NEP);
end;
if ~isscalar(MVCod);
  fprintf(1,'pMdn: Error: MVCod must be a scalar\n');
  return;
end;

Qnt=ones(n2,n3,n4,nNEP)+NaN;
CndQnt=ones(n2,n3,n4,nNEP)+NaN;
Prb=ones(n2,n3,n4,nNEP)+NaN;

for i2=1:n2;
  for i3=1:n3;
    for i4=1:n4;
      
      rX=X(:,i2,i3,i4); %data to use
      
      %isolate non-missing values
      if isnan(MVCod)==1;
        tX=rX(isnan(rX)==0);
        nMV=sum(isnan(rX)==1);
      else;
        tX=rX(rX~=MVCod);
        nMV=sum(rX==MVCode);
      end;
      
      %number of non-missing values
      nNonMV=nX-nMV;
      
      %sort non-missing values in ascending order
      sX=sort(tX);
      
      %add back correct number of missing values at front
      %this assumes that missing value == non-occurrence of event
      if nMV>0;
        t2X=ones(nMV,1)+NaN;
        s2X=[t2X;sX];
      else;
        s2X=sX;
      end;
      
      %quantile (unconditional, unconditional on occurrences - i.e. including non-occurrences)
      QntLct=round(NEP*nX); QntLct(QntLct<=0)=1; QntLct(QntLct>nX)=nX;
      Qnt(i2,i3,i4,:)=s2X(QntLct);
      if nNonMV>0;%conditional quantile (conditional on occurrence)
        CndQntLct=round(NEP*nNonMV); CndQntLct(CndQntLct<=0)=1; CndQntLct(QntLct>nNonMV)=nNonMV;
        CndQnt(i2,i3,i4,:)=sX(CndQntLct);
        %probability of occurrence of non-missing value
        Prb(i2,i3,i4,:)=1-nMV/nX;
      else;
        CndQnt(i2,i3,i4)=Qnt(i2,i3,i4);
        Prb(i2,i3,i4,:)=1;
      end;
      
    end;
  end;
end;

if nargin==0;
  fprintf(1,'pQnt: Test case: Est  Qnt=%04.2f, CndQnt=%04.2f, Prb=%04.2f\n',Qnt,CndQnt,Prb);
end;

return;