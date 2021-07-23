function [bh, bCov, phi, s2, R2, yh, y, X0] = pRgr(y,X0,IsInt,IsVrb);
%function [bh, bCov, phi, s2, R2, yh, y, X0] = pRgr(y,X0,IsVrb);
%
%Multiple linear regression
%1. Expects NO intercept term (this is ALWAYS ADDED)
%2. Performs regression on standardised scale for numerical stability
%
%INPUT
% y       n x 1 response
% X0      n x p covariates (must NOT include intercept)
% IsInt   1 x 1 =1 intercept used, =0 no intercept
% IsVrb   1 x 1 =1 verbose, =0 silent
%
%OUTPUT
% bh      p+1 x 1   parameter estimates (NB p x 1 if IsInt=0)
% bCov    p+1 x p+1 parameter covariance matrix  (NB p x 1 if IsInt=0)
% phi     p+1 x 1   Correlation-Adjusted marginal coRrelation (variable importance, see https://arxiv.org/pdf/1007.5516.pdf)  (NB p x 1 if IsInt=0)
% s2        1 x 1   Estimate of error variance
% R2        1 x 1   Estimate of fit preformance (note: phi'*phi = R2)
% yh        n x 1   Fitted values
% y         n x 1   Original response
% X0        n x p   Original covariates

if nargin==0;
   X0=randn(1000,5).*(ones(1000,1)*(5:-1:1));
   y=6+X0*[0 2 3 0 5]'+randn(1000,1)*1;
   IsInt=1;
   IsVrb=1;
end;

if nargin==2; %IsVrb not specified
   IsInt=1;
   IsVrb=0;
end;

if nargin==3; %IsVrb not specified
   IsVrb=0;
end;

[n,p]=size(X0);

%% Create design matrix
if IsInt==1; %with intercept
   if IsVrb==1; fprintf(1,'Inserting intercept\n'); end;
   X=[ones(n,1) X0];
else; %no intercept
   if IsVrb==1; fprintf(1,'No intercept\n'); end;
   X=X0;
end;

%% Regression on standardised scale, to avoid numerical problems
if rank(X'*X)==size(X,2); %full rank case
   bh=X\y; %this estimates the three regression parameters
else;
   fprintf(1,'WARNING: rank deficient X matrix. Using generalised inverse.\n');
   bh=pinv(X'*X)*X'*y;
end;
if IsVrb==1;
    fprintf(1,'Parameter estimates\n');
    fprintf(1,'bh');fprintf(1,' %.3g',bh); fprintf(1,'\n');
end;

%% Fitted values
yh=X*bh; %this estimates the FITTED VALUES from the regression

%% R2 statistic
R2=1-sum((y-yh).^2)/sum((y-mean(y)).^2); %this estimates the regression performance (R^2=0 rubbish, R^2=1 perfect)
if IsVrb==1;
   fprintf(1,'R2=%g\n',R2);
end;

%% Parameter covariance
s2=sum((y-yh).^2)/(n-(p+1));
if rank(X'*X)==size(X,2); %full rank case
   bCov=inv(X'*X)*s2;
else;
   fprintf(1,'WARNING: rank deficient X matrix. Using generalised inverse.\n');
   bCov=pinv(X'*X)*s2;
end;

%% Parameter importance (t-statistics)
if IsVrb==1;
   fprintf(1,'Parameter importance(>3 is good)\n');
   fprintf(1,'bh/s_{bh}');fprintf(1,' %.3g',bh./sqrt(diag(bCov))); fprintf(1,'\n');
end;

%% Covariate contributions to variance explained 
%% Correlation-adjusted marginal correlations (CAR: see https://arxiv.org/pdf/1007.5516.pdf)
if 1; %use SVD approach; doesn't matter if rank deficient X'*X
   [U,L,V]=svd(X,0);
   omg=V*U'*y/sqrt(y'*y);
else; %long-hand
   omg=sqrtm(inv(X'*X))*X'*y/(sqrt(y'*y));
end;
phi=omg.^2;
if IsVrb==1;
   fprintf(1,'Correlation-adjusted marginal correlations (CAR)\n');
   fprintf(1,'phi');fprintf(1,' %.3g',phi); fprintf(1,'\n');
end;

return;