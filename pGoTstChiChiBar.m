clf; clc; clear; pLtx;

%% Check utility for pChi and pChiBar code
%
%Basics
% Chi(u)=P(X2>u|X1>u) with X1 and X2 on common marginal scale 
% Chi(inf)=0 => Asymptotic independence
% Chi(inf) in (0,1] => Asymptotic dependence
%
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

%% Bivariate logistic
% Eta=1 => ChiBar==1 (unless Alp==1)
% => You should check ChiBar=1
nSmp=1e4;
NepVct=[0.7:0.01:0.99]';
nBS=100;
Alp=0.5;
IsPlt=0;

% Generate data
D=pEvaSmlBvrLgs(nSmp,Alp,IsPlt);

% Estimate Chi
Chi=pChi(D,NepVct,nBS);

% Estimate ChiBar
ChiBar=pChiBar(D,NepVct,nBS);

% Plot
subplot(2,3,1); hold on; 
plot(D(:,1),D(:,2),'.','color',pNicClrBW(1),'markersize',20);
pAxsLmt;pDflBig;
title 'Asymm. log. dependence';

subplot(1,3,2);hold on; 
plot(NepVct,Chi(1,:)','o-','color',pNicClrBW(1));
plot(NepVct,quantile(Chi,0.025),':','color',pNicClrBW(1));
plot(NepVct,quantile(Chi,0.975),':','color',pNicClrBW(1));

subplot(1,3,3);hold on; 
plot(NepVct,ChiBar(1,:)','o-','color',pNicClrBW(1));
plot(NepVct,quantile(ChiBar,0.025),':','color',pNicClrBW(1));
plot(NepVct,quantile(ChiBar,0.975),':','color',pNicClrBW(1));
plot(NepVct,ones(size(NepVct,1),1),'-','color',pNicClrBW(1));

%% Bivariate normal
% Eta=(1+Rho)/2 => ChiBar==Rho (<1 unless Rho=1)
% Bivariate normal converges really slowly, so you need huge samples to see asymptotic behaviour
% => You should check that ChiBar=Rho and than Chi->0 with increasing threshold
nSmp=1e4;
NepVct=[0.7:0.01:0.99]';
nBS=100;
Rho=0.1;
IsPlt=0;

% Generate data
D=pEvaSmlBvrNrm(nSmp,Rho,IsPlt);

% Estimate Chi
Chi=pChi(D,NepVct,nBS);

% Estimate ChiBar
ChiBar=pChiBar(D,NepVct,nBS);

% Plot
subplot(2,3,4);hold on; 
plot(D(:,1),D(:,2),'.','color',pNicClrBW(2),'markersize',20)
pAxsLmt;pDflBig;
title 'Normal dependence';
xlabel 'Gumbel margin';
ylabel 'Gumbel margin';

subplot(1,3,2);hold on; 
plot(NepVct,Chi(1,:)','o-','color',pNicClrBW(2));
plot(NepVct,quantile(Chi,0.025),':','color',pNicClrBW(2));
plot(NepVct,quantile(Chi,0.975),':','color',pNicClrBW(2));
plot(NepVct,0*ones(size(NepVct,1),1),'-','color',pNicClrBW(2));
pAxsLmt;pDflBig;
xlabel 'NEP'; title('$\chi(u)$');

subplot(1,3,3);hold on; 
plot(NepVct,ChiBar(1,:)','o-','color',pNicClrBW(2));
plot(NepVct,quantile(ChiBar,0.025),':','color',pNicClrBW(2));
plot(NepVct,quantile(ChiBar,0.975),':','color',pNicClrBW(2));
plot(NepVct,Rho*ones(size(NepVct,1),1),'-','color',pNicClrBW(2));
pAxsLmt;pDflBig;
xlabel 'NEP'; title('$\bar{\chi}(u)$');