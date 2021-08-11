function ChiBar=pChiBar(X,NepVct,nBS);
%function ChiBar=pChiBar(X,NepVct,nBS);
%
%PhJ 20210811
%
%Estimate chibar(u) statistic from a bivariate sample
%
% X      n x 2 bivariate sample
% NepVct p x 1 vector of marginal non-exceedance probabilities at which to evaluate ChiBar(u)
% nBS    1 x 1 number of bootstrap resamples (first is always the original sample)
%
% ChiBar nBS x p values of ChiBar for nBS bootstrap resamples and p thresholds
%
%The calculation is as follows
% 1. Estimate Eta(u) using the method of Ledford and Tawn. www.lancs.ac.uk/~jonathan/EKJ11.pdf Appendix A
% 2. Estimate ChiBar(u) using ChiBar=2*Eta-1
%
%Basics
% ChiBar(u)=2 Eta(u)-1
% Eta(u) is estimated GP shape from fit to MINIMA observations; data must be on standard Frechet scale
% ChiBar(inf)=1 => Asymptotic dependence
% Chi(inf) in (0,1] => Asymptotic independence with POSITIVE association
% ChiBar(inf)=0 => Independent
% Chi(inf) in [-1,0) => Asymptotic independence with NEGATIVE association
%
% See http://www.lancs.ac.uk/~jonathan/EKJ11.pdf for basics
% See http://www.lancs.ac.uk/~jonathan/OcnEng10.pdf Section 4 for discussion on asymptotic properties
% of asymmetric logistic and Normal

if nargin==0;
    X=randn(1000,2);
    NepVct=(0.7:0.01:0.99)';
    nBS=50;
end;

n=size(X,1);
p=size(NepVct,1);

% Estimate Eta(u)
Eta=nan(nBS,p);
for iB=1:nBS;
    
    % Create bootstrap resample
    if iB==1;
        tX=X;
    else;
        I=(1:n)';
        tI=randsample(I,n,1);
        tX=X(tI,:);
    end;
    
    % Estimate empirical quantiles
    tR=pRnk(tX);
    tU=(tR+0.5)/(n+1);
    
    % Transform threshold exceedances to Frechet scale
    tF=-1./log(tU);
    
    % Find minimum of Frechet variate values
    tM=min(tF,[],2);
    
    Thr=quantile(tM,NepVct);
    
    % Loop over thresholds
    for j=1:p;
        
        % Fit GP to minimum of Frechet-scale threshold exceedances
        if sum(tM>Thr(j))>50;
            tP=gpfit(tM(tM>Thr(j))-Thr(j));
            Eta(iB,j)=tP(1);
        end;
        
    end;
    
end;

% Estimate ChiBar(u)
ChiBar=2*Eta-1;

if nargin==0;
    clf;hold on;
    plot(NepVct,ChiBar(1,:)','ko-')
    plot(NepVct,quantile(ChiBar,0.025),'k:')
    plot(NepVct,quantile(ChiBar,0.975),'k:')
end;

return;