function [B,avXo,avYo,il_opt,r,min_mse,R2,lam,mse,Yh,Yhb,YPred]=pRR(Xo,Yo,ngp,how_l,lampc,XPred);
%function [B,avXo,avYo,il_opt,r,min_mse,R2,lam,mse,Yh,Yhb]=RR(Xo,Yo,ngp,how_l,lampc,XPred);
%THIS IS THE CURRENT VERSION
%
%Kernal algorithm for cross-validated ridge regression
%
%PJ : 28 August 1998
%
%Inputs:
%Xo      : n * p     : explanatory data matrix
%Yo      : n * q     : response data matrix
%ngp     : scalar    : number of cross-validation groups
%how_l   : scalar    : =0 => common ridge parameter for all responses
%                      =1 => individual ridge parameters for responses
%lampc   : scalar    : maximum shrinkage, as percentage of Xo variance
%
%Outputs:
%B       : p * q     : ridge regression parameter estimate
%avXo    : 1 * p     : average observation
%avYo    : 1 * q     : average response
%l_opt   : scalar    : if how_l=0, optimal shrinkage parameter
%il_opt  : scalar    : if how_l=0, index of optimal shrinkage parameter
%l_opt   : 1 * q     : if how_l=1, optimal shrinkage parameter
%il_opt  : 1 * q     : if how_l=1, index of optimal shrinkage parameter
%r       : scalar    : if how_l=0, shrunken p/n (for C&W-RR)
%min_mse : 1*(q+1)   : min. cross-validated MSEs, for individual responses
%                    : and for combined standardised response
%R2      : 1*(q+1)   : max. cross-validated R2s
%lam     : 100*1     : search grid values of shrinkage parameter used
%mse     : 100*(q+1) : values of MSE on search grid
%Yh      : n * q     : predicted values
%
%Notes:
%17.04.97- lampc=50 works ok for SAP spectra
%17.04.97- no elimination of extreme values during cross-validation
%19.11.97- sorted out problem with centring. Did lots of tests to ensure that the program
%          now works. (In the previous version, centring was done outside the cross-validation => bias!)
%28.08.98- Found coding error. Program works OK for univariate responses, but crashed for multivariate.
%          Changed avg --> avg(j) on line ~149
%          Works fine now.

[n,p]=size(Xo);
q=size(Yo,2);
s=fix(n/ngp);


%Specify basic grid of 100 points for shrinkage parameter search
%lam=(0.1:0.1:1)';
%Never put lam=0, since this can lead to very unstable results!
%lam=(0.01:0.01:1)';
ls=[1;2;5];
lam=[ls*1e-8;ls*1e-7;ls*1e-6;ls*1e-5;ls*1e-4;ls*1e-3;ls*1e-2;(0.1:0.1:1)'];
il=lam;
nl=size(lam,1);


%Set up matrices
mse=zeros(nl,q);
B=ones(p,q).*(-99);
Yhb=ones(n,nl,q).*(-99);


if(nargin<5);
  fprintf(1,'SEVERE ERROR : Insufficient arguments\n');
  return;
end;


%Mean properties of data (but note I don't mean centre => loss of dof)
avXo=mean(Xo);
avYo=mean(Yo);
 

%SVD on complete data
tmp=Xo-ones(n,1)*avXo;
if(n>p);
  [Uxo,Lxo,Vxo]=svd(tmp,0);
else;
  [Vxo,Lxo,Uxo]=svd(tmp',0);
end;
Lxo=diag(Lxo);
lam=lam*(lampc*sum(Lxo.^2)/n)/100;
fprintf(1,'Shrinkage up to %d percent of total variance %f in %d steps on a log scale\n',lampc,lam(nl),nl);
fprintf(1,'Minimum shrinkage  %f\n',lam(1));


fprintf(1,'RR-CV. Loop :');
for cv=1:ngp;

  fprintf(1,' %d',cv);

%split the data into training and test sets
  train=ones(n,1);
  if cv<ngp;
    top=s*cv;
  else;
    top=n;
  end;
  for i=1+s*(cv-1):top;
    train(i)=0;
  end;
  X=Xo(train==1,:);
  Y=Yo(train==1,:);
  X_te=Xo(train~=1,:);
  Y_te=Yo(train~=1,:);


  ntr=size(X,1);
  nte=size(X_te,1);
% fprintf(1,'ntr:%d nte:%d\n',ntr,nte);


%Centre data
  avx=mean(X);
  avy=mean(Y);
  X=X-ones(ntr,1)*avx;
  Y=Y-ones(ntr,1)*avy;
  X_te=X_te-ones(nte,1)*avx;
  Y_te=Y_te-ones(nte,1)*avy;

  if(n>p);
    [Ux,Lx,Vx]=svd(X,0);
  else;
    [Vx,Lx,Ux]=svd(X',0);
  end;
  Lx=diag(Lx);
  tmp=Lx>1e-6*max(Lx);
  Ux=Ux(:,tmp==1);
  Lx=Lx(tmp==1);
  Vx=Vx(:,tmp==1);


  tmp1=(X_te*Vx);
  tmp3=(Ux'*Y);


  for i=1:nl;
    
    tmp2=Lx./(Lx.^2 + ones(size(Lx))*lam(i) );

    Yh=tmp1*diag(tmp2)*tmp3;

    tmp=sum((Yh-Y_te).^2);
%   fprintf(1,'cv%d grid%d Yh%d Y_te%d sse%d\n',cv,i,Yh,Y_te,tmp);
%   pause;
    
    for j=1:q;
       Yhb(train~=1,i,j)=Yh(:,j)+ones(nte,1)*avy(:,j);
    end;

    for j=1:q;
       mse(i,j)=mse(i,j)+sum((Yh(:,j)-Y_te(:,j)).^2);
%      fprintf(1,'cv%d grid%d resp%d mse%d\n',cv,i,j,mse(i,j));
%      pause;
    end;

  end;

end;
fprintf(1,'\n');
 
%Store MSEs and find their minima
mse=mse./n;
mssYo=mean((Yo-ones(n,1)*mean(Yo)).^2);
if q>1;
  mse=[mse mean((mse./(ones(nl,1)*mssYo))')'];
else;
  mse=[mse mse/mssYo];
end;
[min_mse,loc_min_mse]=min(mse);
fprintf(1,'Minimum individual and standardised overall CV-MSE RR :\n');
fprintf(1,' %d',min_mse);
fprintf(1,'\n');

%Estimate R2
R2=ones(1,q)-min_mse(:,1:q)./mssYo;
fprintf(1,'Individual CV-Rsquare RR :\n');
fprintf(1,' %d',R2);
fprintf(1,'\n');


%Find optimal shrinkage parameters
min_lam=ones(1,q+1).*(-99);
for j=1:q+1;
  min_lam(j)=lam(mse(:,j)==min_mse(:,j));
end;
fprintf(1,'Ridge parameter for minimum individual and standardised overall CV-MSE :\n')
fprintf(1,' %e',min_lam);
fprintf(1,'\n');


%Check that at least some shrinkage occurs
if(how_l==1);
  l_opt=min_lam(1:q);
% il_opt=loc_min_mse(1:q)*lampc/100;
  il_opt=il(loc_min_mse(1:q));
  for j=1:q;
    if(loc_min_mse(j)==1);
      fprintf(1,'WARNING : Minimum shrinkage gives best CV-MSE for response %d\n',j);
    end;
  end;
else;
  l_opt=min_lam(q+1);
% il_opt=loc_min_mse(q+1)*lampc/100;
  il_opt=il(loc_min_mse(q+1));
  if(loc_min_mse(q+1)==1);
    fprintf(1,'WARNING : Minimum shrinkage gives best CV-MSE for combined response\n');
  end;
end;
 


%Output predicted values
Yh=ones(n,q).*(-99);
for j=1:q;
   Yh(:,j)=Yhb(:,loc_min_mse(j),j);
end;


%Calculate regression parameters for whole data matrix
%Note that svd of Xoc (not Xo) was performed above!
if exist('XPred')==1;
    nPred=size(XPred,1);
    tmp0=(XPred-ones(nPred,1)*avXo);
    YPred=nan(nPred,q);
end;
tmp1=Vxo;
tmp3=(Uxo'*Yo);
if(how_l==1);
  for j=1:q;
    tmp2=Lxo./(Lxo.^2 + ones(size(Lxo)).*l_opt(j));
    B(:,j)=tmp1*diag(tmp2)*tmp3(:,j);
    if exist('XPred')==1;
        YPred(:,j)=tmp0*B(:,j)+ones(nPred,1)*avYo(:,j);
    end;
  end;
  r=0;
else;
  tmp2=Lxo./(Lxo.^2 + ones(size(Lxo)).*l_opt);
  B=tmp1*diag(tmp2)*tmp3;
  if exist('YPred')==1;
      YPred(:,j)=tmp0*B(:,j)+ones(nPred,1)*avYo;
  end;
  tmp2=(Lxo.^2)./(Lxo.^2 + ones(size(Lxo)).*l_opt);
  r=trace(Uxo*diag(tmp2)*Uxo')./n;
  fprintf(1,'Overall optimal CV ridge parameter, original and adjusted p/n :\n')
  fprintf(1,' %f',l_opt,p/n,r);
  fprintf(1,'\n');
end;



