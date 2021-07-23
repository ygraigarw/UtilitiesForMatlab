function d=pDrch(a,n);
%function pDrch(a,n);
%
% Sample from Dirichlet distributino
%
% a p x 1 vector of concentrations
% n 1 x 1 sample size required

p = size(a,1);
r = gamrnd(repmat(a',n,1),1,n,p);
d = r ./ repmat(sum(r,2),1,p);

return;