function y=pKLDvr(X1,X2,nQ);
%function y=pKLDvr(X1,X2,nQ);
%
% X1 and X2 are random samples OF THE SAME SIZE from two distributions for comparison
% nQ is the number of quantile to use to partition the joint sample
%
% X1 is anticipated to be an array size n x 1 (i.e. a set of observed data)
% X2 is anticipated to be another sample size n x 1 (i.e. another set of observed data)
%    or a set of samples (possibly simulated from the same fitted model) of size n x p

if nargin==0;
    n=100;
    p=100;
    X1=randn(n,1);
    X2=randn(n,p);
    nQ=10;
end;

n=size(X1,1);
[m,p]=size(X2);

if m~=n;
    fprintf(1,'pKLDvr error. Sample sizes must be the same\n');
    return;
end;

% Loop over the p samples from X2, calculate KLD between X1 and X2(:,j)
KL=nan(p,1);
for j=1:p;
    
    Edg=quantile([X1;X2(:,p)],linspace(0,1,nQ+1))';
    Edg=Edg(2:end);
    
    F1=sum(X1*ones(1,nQ)<=ones(n,1)*Edg')'/n;
    F2=sum(X2(:,p)*ones(1,nQ)<=ones(n,1)*Edg')'/n;
    
    % Symmetric KL divergence
    KL(j)=0.5*sum(F1.*log(F1./F2)+F2.*log(F2./F1));
    
    if isnan(KL(j))==1;
        fprintf(1,'pKLDvr returning NaN. Consider reducing number of quantiles\n');
        return;
    end;

end;

% Report mean KL over p samples from X2
y=mean(KL);

return;