function [PkTim, PkVal]=pPot(XTim, XVal, Thr);

if nargin==0;
    XTim=(1:10000)';
    XVal=sind(XTim);
    subplot(1,2,1);
    plot(XTim, XVal, '.');
    Thr=0;
end;

if diff(XTim,2)~=0;
    fprintf(1,'Terminating: Data not equally spaced\n');
end;

n=size(XVal,1);

IsExc=(XVal-Thr)>0;

Bgn=find(diff(IsExc)==1)+1;
End=find(diff(IsExc)==-1)+1;

if XVal(1)>Thr;
    Bgn=[1;Bgn];
end;

if size(Bgn,1)>size(End,1);
    End=[End;n];
end;

Exc=[Bgn End];
nExc=size(Exc,1);
PkVal=nan(nExc,1);
PkTim=nan(nExc,1);
for iE=1:nExc;
    t=(Exc(iE,1):Exc(iE,2))';
    tPk=XVal(t);
    tTim=XTim(t);
    PkVal(iE)=max(XVal(t));
    t2=find(tPk==PkVal(iE));t2=t2(1);
    PkTim(iE)=tTim(t2);
end;

return;