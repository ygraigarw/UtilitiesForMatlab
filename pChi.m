function Chi=pChi(X,NepVct,nBS);
%function Chi=pChi(X,NepVct,nBS);
%
%PhJ 20210811
%
%Estimate chi(u) statistic from a bivariate sample
%
% X      n x 2 bivariate sample
% NepVct p x 1 vector of marginal non-exceedance probabilities at which to evaluate chi(u)
% nBS    1 x 1 number of bootstrap resamples (first is always the original sample)
%
% Chi  nBS x p values of Chi for nBS bootstrap resamples and p thresholds
%
%Basics
% Chi(u)=P(X2>u|X1>u) with X1 and X2 on common marginal scale 
% Chi(inf)=0 => Asymptotic independence
% Chi(inf) in (0,1] => Asymptotic dependence
%
% See http://www.lancs.ac.uk/~jonathan/EKJ11.pdf for basics
% See http://www.lancs.ac.uk/~jonathan/OcnEng10.pdf Section 4 for discussion on asymptotic properties
% of asymmetric logistic and Normal

% Use this if no input
if nargin==0;
    X=randn(1000,2);
    NepVct=(0.7:0.01:0.99)';
    nBS=250;
end;

n=size(X,1);
p=size(NepVct,1);

% Quantiles to use
Thr=quantile(X,NepVct);

Chi=nan(nBS,p);
for iB=1:nBS;
    
    % Always use original data for first bootstrap
    if iB==1;
        tX=X;
    else;
        I=(1:n)';
        tI=randsample(I,n,1);
        tX=X(tI,:);
    end;
    
    % Estimate Chi by counting
    for j=1:p;
        t=tX(:,1)>Thr(j,1);
        tn=sum(t);
        Chi(iB,j)=sum(tX(t,2)>Thr(j,2))/tn;
    end;
end;

if nargin==0;
    hold on;
    plot(NepVct,Chi(1,:)','ko-')
    plot(NepVct,quantile(Chi,0.025),'k:')
    plot(NepVct,quantile(Chi,0.975),'k:')
end;

return;