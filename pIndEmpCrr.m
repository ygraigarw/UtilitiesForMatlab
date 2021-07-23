function Y=pIndEmpCrr(X,rho);
%function Y=pIndEmpCrr(X,rho);
%
%Induce a rank correlation in a sample 
% X    n x 2 Data for two variables with no dependence
% rho  1 x 1 Value for equivalent MVN correlation to induce
% Y    n x 2 Permuted samples with desired dependence

if nargin==0;
    n=100;
    X(:,1)=gprnd(-0.2*ones(n,1),1,0);
    X(:,2)=gprnd(-0.2*ones(n,1),1,0);
    rho=0.9;
end;

n=size(X,1);
Sgm=[1 rho;rho 1];
SqrtSgm=sqrtm(Sgm);

Z=rand(n,2)*SqrtSgm;

%Work out how to "unorder" the sorted Zs, and apply this to sorted Xs to induce dependence
[jnk,t1]=sort(Z(:,1));
r1(t1)=(1:n)';
[jnk,t2]=sort(Z(:,2));
r2(t2)=(1:n)';
t=corrcoef(r1,r2);t=t(1,2);
fprintf(1,'Rank correlation of MVN is %g\n',t); 

[sX1,t1]=sort(X(:,1));
a1(t1)=(1:n)';
[sX2,t2]=sort(X(:,2));
a2(t2)=(1:n)';
Y=[sX1(r1) sX2(r2)];
t=corrcoef(a1,a2);tBefore=t(1,2);
fprintf(1,'Rank correlation of input columns is %g\n',tBefore); 

[jnk,t1]=sort(Y(:,1));
r1(t1)=(1:n)';
[jnk,t2]=sort(Y(:,2));
r2(t2)=(1:n)';
t=corrcoef(r1,r2);tAfter=t(1,2);
fprintf(1,'Rank correlation of output columns is %g\n',tAfter); 

if nargin==0;
    subplot(1,2,1);
    plot(X(:,1),X(:,2),'ko'); pAxsLmt; pDfl; title 'Before';
    subplot(1,2,2);
    tStr=sprintf('After: rank corr = %g\n',tAfter);
    plot(Y(:,1),Y(:,2),'ko'); pAxsLmt; pDfl; title 'After';
end;

return;