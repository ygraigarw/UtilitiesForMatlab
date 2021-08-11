function D=pEvaSmlBvrNrm(nSmp,Rho,IsPlt);
%function D=pEvaSmlBvrNrm(nSmp,Rho,IsPlt);

pO('Generate data from multivariate distribution with Gumbel marginals and multivariate normal dependency');
    
%Re-initialise random number generator
rand('state',sum(100*clock));

%Check input arguments
if nargin==0;pO('SmlBvrNrm: Running test case since nargin=0');
    nSmp=1000;
    Rho=0.5;
    IsPlt=1;
end;
if nargin==1;pO('SmlBvrNrm: Error: Incorrect number of arguments');
    return;
end;
if nargin==2;
    IsPlt=0;
end;

%Output argument
D=ones(nSmp,2).*NaN;

%Generate data from standard bivariate normal
Z=randn(nSmp,2);

%Transform so that data has covariance structure [1 Rho; Rho 1]
sqrtSgm=sqrtm([1 Rho;Rho 1]);
X=Z*sqrtSgm;

if 0;%Check X
    pO('Covariance X''*X is:');
    disp(X'*X/(nSmp-1));
end;

%Transform to Gumbel marginals using probability integral transform
Phi=normcdf(X,0,1); %values of cumulative probability corresponding to X (which is marginally N(0,1))
D=-log(-log(Phi)); %transform cumulative probabilities to Gumbel variates

if IsPlt==1;pO('SmlBvrNrm: Plotting');
    clf;
    subplot(1,2,1);hold on;
    plot(D(:,1),D(:,2),'k.');pDflBig;
    drawnow;
    subplot(1,2,2);hold on;
    FVal=((1:nSmp)'-0.5)/nSmp;
    y=sort(D(:,1));
    plot(y,exp(-exp(-y)),'m-');
    plot(y,FVal,'r-');pDflBig;
    y=sort(D(:,2));
    plot(y,exp(-exp(-y)),'c-');
    plot(y,FVal,'b-'); pDflBig;
end;

return;

function o(Txt);
fprintf(1,'%s\n',Txt);
return;