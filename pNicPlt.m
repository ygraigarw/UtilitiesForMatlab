function pnicplt(X,Y,Str,FntSiz,Ttl);

switch nargin
    case {0,1}
        fprintf(1,'pnicplt: Info: pnicplt(X,Y,Str,FntSiz)\n');
        fprintf(1,'pnicplt: Error: Insufficient inputs. Terminating\n');
        return;
    case 2;
        Str='k.';
        FntSiz=12;
        Ttl=sprintf('%s v %s',pU2H(inputname(2)),pU2H(inputname(1)));
    case 3;
        FntSiz=12;
        Ttl=sprintf('%s v %s',pU2H(inputname(2)),pU2H(inputname(1)));
    case 4;
        Ttl=sprintf('%s v %s',pU2H(inputname(2)),pU2H(inputname(1)));
    case {6,7}
        fprintf(1,'pnicplt: Info: pnicplt(X,Y,Str,FntSiz)\n');
        fprintf(1,'pnicplt: Error: Too many inputs. Terminating\n');
        return;
end;

pPlt(X,Y,Str);

set(gca,'FontSize',FntSiz,'FontName','Sylfaen');
grid on;
box on;

xlabel(pU2H(inputname(1)));
ylabel(pU2H(inputname(2)));
title(Ttl);
pAxsLmt;

return;