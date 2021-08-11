function D=pEvaSmlBvrLgs(nSmp,Alp,IsPlt);
%function D=pEvaSmlBvrLgs(nSmp,Alp,IsPlt);

o('Generate data from multivariate extreme value distribution with Gumbel marginals and exchangeable logistic dependency');
    
%Re-initialise random number generator
rand('state',sum(100*clock));

%Check input arguments
if nargin==0;o('SmlBvrLgs: Running test case since nargin=0');
    nSmp=1000;
    Alp=0.01;
    IsPlt=1;
end;
if nargin==1;o('SmlBvrLgs: Error: Incorrect number of arguments');
    return;
end;
if nargin==2;
    IsPlt=0;
end;

%Output argument
D=ones(nSmp,2).*NaN;

%Simulate first variate from it's Gumbel (double exponential) marginal distribution
D(:,1)=-log(-log(rand(nSmp,1)));

%Simulationg procedure is as follows:
%For each simulated value of the first variate (say x)
%1 simulate nSmp values for the second variate (say y) from its Gumbel marginal
%2 calculate the cumulative probability for each value pair (x y)
%3 select the value of y to retain by selecting the value of cumulant at random from [0,1] and retain the best matching y
%
%If   P(X<=x,Y<=y) = FXY(x,y)
%Then P(Y<=y| X=x) = P(Y<=y | X in [x, x+dx)) / P(X in [x, x+dx))
%                  = (P(Y<=y | X=x+dx) - P(Y<=y | X=x+dx)) / (P(X<=x+dx) - P(X<=x))
%                  = dFXY / dFX
%                  = (dFXY/dx) / (dFX/dx)
%So the conditional distribution of Y|X is given by the partial derivative of FXY wrt x divided by the density of X
%
%For a bivariate Gumbel distribution, result is given in Phil's black & red book for 20090522

tSmp=min(nSmp,1000);
for iS=1:nSmp;
    %find y value corresponding to randomly selected cumulant of conditional distribution
    %turned out to be very slow
    P=rand(1,1);
    x=D(iS,1);
    y0=D(iS,1);
    options=optimset('Display','off'); % Turn off Display
    D(iS,2)=fsolve(@(y) FitCndCdfBvrLgs(y,x,Alp,P), y0,options);
end;

if IsPlt==1;o('SmlBvrLgs: Plotting');
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

function E=FitCndCdfBvrLgs(y,x,Alp,P);
E=(P-CndCdfBvrLgs(y,x,Alp)).^2;
return;

function P=CndCdfBvrLgs(y,x,Alp);
%function P=CndCdfBvrLgs(y,x,Alp);
%Conditional cumulant of bivariate Gumbel distribution
g=(exp(-x/Alp)+exp(-y/Alp));
c1=exp(x*(1-1/Alp));
c2=g.^(Alp-1);
c3=exp(exp(-x)-g.^Alp);
P=c1.*c2.*c3;
return;

