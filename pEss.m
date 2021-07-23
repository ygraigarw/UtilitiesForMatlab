function E=pEss(y,Vrb);

if nargin==1;
    Vrb=0;
else;
    clf;
end;

nPrm=1000;
n=size(y,1);
A=pAutCrr(y,n);

APrm=nan(nPrm,1);
for i=1:nPrm;
    tPrm=randperm(n);
    APrm(i,:)=pAutCrr(y(tPrm),1)';
end;    

ThrU=quantile(APrm,0.975);
ThrL=quantile(APrm,0.025);
%Thr=5*(ThrU-ThrL)/2; %Threshold is 2 x an extreme quantile of randomisation distribution
Thr=0.2;
t1=find(abs(A)<Thr);t1=t1(1);
E=n/(1+2*sum(A(1:t1)));
fprintf(1,'%g points used to estimate ESS with threshold of %g\n',t1,Thr);
fprintf(1,'ESS=%g\n',E);

if Vrb==1;
    subplot(2,1,1); plot(y,'k'); 
    subplot(2,1,2); hold on; plot(A,'k'); plot([1 n]',-ones(2,1)*Thr,'k'); plot([1 n]',ones(2,1)*Thr,'k');
end;

return