function R=pRnk(X);

[n,p]=size(X);

%Create rank matrix, handling NaN carefully
IsOk=isnan(X)==0;
R=ones(n,p).*NaN;
for j=1:p;
    if sum(IsOk(:,j))>0;
        t=X(IsOk(:,j)==1,j);
        [jnk,t1]=sort(t);
        [jnk,t2]=sort(t1);
        R(IsOk(:,j)==1,j)=t2;
    end;
end;

return;
