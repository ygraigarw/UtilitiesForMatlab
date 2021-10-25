function y=pKLDvr(X1,X2,nQ);
%function y=pKLDvr(X1,X2,nQ);
%
% X1 and X2 are random samples from two distributions for comparison
% nQ is the number of quantiles to use to partition the joint sample
%
% X1 is anticipated to be an array size n x 1 (i.e. a set of observed data)
% X2 is anticipated to be another sample size m x 1 (i.e. another set of observed data)
%    or a set of samples (possibly simulated from the same fitted model) of size m x p
%
% KL divergence is calculated for (sub)sets of equal maximum size between X1 and each column of X2
% The mean KL divergence is then output

if nargin==0;
    n=1000;
    p=100;
    X1=randn(n,1);
    X2=randn(n,p);
    nQ=10;
end;

n1=size(X1,1);
[n2,p]=size(X2);

% Use the minimum of n1 and n2 for KLD calculations
n=min(n1,n2);

% Loop over the p samples from X2, calculate KLD between X1 and X2(:,j)
KL=nan(p,1);
for j=1:p;

    % Randomly resample X1 and X2(:,j) with replacement for sample size n
    tX1=randsample(X1,n,1);  % Third input imposes resampling with replacement
    tX2=randsample(X2(:,j),n,1); % Third input imposes resampling with replacement
    
    % Find quantile levels
    Edg=quantile([tX1;tX2],linspace(0,1,nQ+1))';
    Edg=Edg(2:end); % Omit smallest quantile at cdf=0
    
    % Estimate empirical cdf
    F1=sum(tX1*ones(1,nQ)<=ones(n,1)*Edg')'/n;
    F2=sum(tX2*ones(1,nQ)<=ones(n,1)*Edg')'/n;
    
    % Symmetric KLD
    KL(j)=0.5*sum(F1.*log(F1./F2)+F2.*log(F2./F1));
    
    % Flag NaN output
    if isnan(KL(j))==1;
        fprintf(1,'pKLDvr returning NaN. Consider reducing number of quantiles\n');
        y=NaN;
        return;
    end;

end;

% Report mean KL over p samples from X2
y=mean(KL);

return;