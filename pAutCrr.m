function A=pAutCrr(y,LagMxm);

n=size(y,1);
ybar=mean(y);
A=nan(LagMxm,1);

for k=1:LagMxm;
    cross_sum = zeros(n-k,1) ;
    
    % Numerator, unscaled covariance
    for i = (k+1):n;
        cross_sum(i) = (y(i)-ybar)*(y(i-k)-ybar) ;
    end;

    % Denominator, unscaled variance
    yvar = (y-ybar)'*(y-ybar) ;
    
    A(k) = sum(cross_sum) / yvar ;
end;

return;