function [Dst,I,L,D,Dlt]=pDst2Lin(L,D,Dlt);
%% Calculates the minimum distance of each point in set D to line L
% D  nD x 2 point with x and y coordinates
% L  nL x 2 points (x,y coordinates) defining a curve L;
% L is assumed to be linear between consecutive points
% Dlt 1 x 1 distance for points in D to be considered "close" to L
% I  nD x 1 0/1 indicator that points in D are close (=1) to L

%% If no input, use toy data
if nargin==0;
    %% L is "rough" circle
    th=(0:0.1:2*pi)';
    x=cos(th);
    y=sin(th);
    L=[x,y];
    %% D is random points
    D=randn(100,2)*0.5;
    %% Dlt is small (so points have to be "on line" to match
    Dlt=0.1;
end;

nL=size(L,1);
nD=size(D,1);
Dst=ones(nD,1)*inf; %Dst set to inf
%% Loop over points in D, find minimum distance for each
for iD=1:nD;
    if rem(iD,100)==0;fprintf(1,'+');end;
    if rem(iD,1000)==0;fprintf(1,'\n');end;
    rD=D(iD,:)';
    tMnmPrpDst=inf; %temporary minimum distance set to inf
    %% Loop over line segements of L
    for iL=1:nL-1;
        r1=L(iL,:)';
        r2=L(iL+1,:)';
        tLinDst=(r2-r1)'*(rD-r1)/((r2-r1)'*(r2-r1));
        if tLinDst>=0 & tLinDst<=1; %you should project on to line segment
            tTh=acos((r2-r1)'*(rD-r1)/sqrt((r2-r1)'*(r2-r1)*(rD-r1)'*(rD-r1)));
            tPrpDst=sqrt((rD-r1)'*(rD-r1))*sin(tTh);
        else; %shortest distance is from end of line segment
            tPrpDst=sqrt(min((rD-r1)'*(rD-r1),(rD-r2)'*(rD-r2)));
        end;
        tMnmPrpDst=min(tPrpDst,tMnmPrpDst);
    end;
    Dst(iD)=min(tMnmPrpDst,Dst(iD));
end;

%% Find points in D close to L
I=Dst<=Dlt;

%% Plot solution when using toy data
if nargin==0
    clf;hold on;
    plot(L(:,1),L(:,2),'b.');
    plot(D(:,1),D(:,2),'ro');
    plot(D(I,1),D(I,2),'k*');
end;

%% Normal completion
return;