function [LOF,beta]=pSmtSpl(y,X,P,L,W);
%Smoothing spline
%minimise w.r.t. beta: (y-X*beta)'*(y-X*beta) + lmb * beta' * P * beta
%-------------------------------------------------------------------------------------------
%y:  n x 1 response 
%X:  n x p explanatory
%P:  p x p penalty matrix
%L: nL x 1 possible enalty coefficients
%W:  n x 1 OPTIONAL weight vector (=0 to eliminate NaN in y)
%-------------------------------------------------------------------------------------------
%LOF(:,1): fitting sum of squares
%LOF(:,2): leave-one-out prediction sum of squares
%beta: optimal regression vector
%-------------------------------------------------------------------------------------------
nL=size(L,1);
LOF=ones(nL,2)+NaN;
beta=NaN;

%-------------------------------------------------------------------------------------------
if nargin==4; W=ones(size(y,1),1); end;
%-------------------------------------------------------------------------------------------
y(W==0)=0;
Wy=W.*y;
if sum(isnan(Wy))>0; fprintf(1,'NaN detected. Terminating\n'); return; end;
XtWX=X'*diag(W)*X;
%-------------------------------------------------------------------------------------------
%Iterate over possible penality coefficients
for iL=1:nL;
    Dsg=(XtWX+L(iL)*P);
    beta=Dsg\(X'*Wy);
    H=diag(X*(Dsg\X')*diag(W));
    LOF(iL,1)=(y-X*beta)'*(y-X*beta);
    LOF(iL,2)=sum((((y-X*beta))./(1-H)).^2);
end;
%-------------------------------------------------------------------------------------------
%Optimal model
iOpt=find(LOF(:,2)==min(LOF(:,2)),1,'first'); %optimal index
Dsg=(X'*X+L(iOpt)*P);
beta=Dsg\(X'*Wy); %optimal regression vector
%-------------------------------------------------------------------------------------------
return;